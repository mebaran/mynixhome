{
  lib,
  pkgs,
  aitools,
  skillSources,
  ...
}: let
  # Pi is Nix-managed; Pi packages remain mutable/updateable under ~/.pi/agent
  # and third-party Agent Skills remain mutable/updateable under ~/.agents/skills.
  #
  piPkg = aitools.pi;

  pi = lib.getExe piPkg;
  npx = "${pkgs.nodejs}/bin/npx";

  piSkills = import ./skills.nix {inherit skillSources;};

  # Skills installed by `npx skills add ... -g` normally land here.
  skillPath = name: "$HOME/.agents/skills/${name}";
  skillPaths = names: map skillPath names;
  skillInstallLine = skill: "${npx} --yes skills add ${lib.escapeShellArg skill.source} -g -y";

  piSkillsInstall = pkgs.writeShellApplication {
    name = "pi-skills-install";
    text = lib.concatMapStringsSep "\n" skillInstallLine piSkills.managedSkills;
  };

  piSkillsUpdate = pkgs.writeShellApplication {
    name = "pi-skills-update";
    text = ''
      ${npx} --yes skills update
      ${pi} update --extensions
    '';
  };

  piSkillsCheck = pkgs.writeShellApplication {
    name = "pi-skills-check";
    text = ''
      ${npx} --yes skills check
    '';
  };

  piSettings = {
    defaultProvider = "openai-codex";
    defaultModel = "gpt-5.5";

    # Use the Nix-provided npm for Pi package install/update operations.
    npmCommand = ["${pkgs.nodejs}/bin/npm"];

    enableSkillCommands = true;

    packages =
      [
        "npm:pi-subagents"
        "npm:@vanillagreen/pi-skills-manager"
        "npm:@vanillagreen/pi-web-tools"
        "npm:pi-lean-ctx"
        "npm:@victor-software-house/pi-curated-themes"
      ]
      ++ piSkills.packages;

    skills = (skillPaths piSkills.startupSkillNames) ++ piSkills.repositorySkillPaths;

    theme = "catppuccin-mocha";
  };

  skillFlags = skills: lib.concatMapStringsSep " " (skill: "--skill ${skill}") skills;
in {
  home.packages = [
    piPkg
    piSkillsInstall
    piSkillsUpdate
    piSkillsCheck
  ];
  home.file.".pi/agent/settings.json".text = builtins.toJSON piSettings;

  programs.zsh.shellAliases = {
    # Exact profile launchers: no implicit skill discovery; only the listed
    # installed/updateable skills are loaded.
    pi-code = "${pi} --no-skills ${skillFlags (skillPaths piSkills.codingSkillNames)}";
    pi-data = "${pi} --no-skills ${skillFlags (skillPaths piSkills.dataEngSkillNames)}";
    pi-aws = "${pi} --no-skills ${skillFlags (skillPaths piSkills.awsSkillNames)}";

    # Keep previous names as aliases.
    pi-code-clean = "pi-code";
    pi-data-clean = "pi-data";

    # Skill package maintenance.
    pi-skills-reinstall = "pi-skills-install";
  };
}
