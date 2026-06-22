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

  piSkills = import ./skills.nix {inherit lib skillSources;};

  # Skills installed by `npx skills add ... -g` normally land here.
  skillPath = name: "$HOME/.agents/skills/${name}";
  skillPaths = names: map skillPath names;
  skillInstallLine = skill: "${npx} --yes skills add ${lib.escapeShellArg skill.source} -g -y";
  skillsForPackNames = packNames:
    lib.concatLists (map (name: let
      pack = piSkills.skillPacks.${name};
    in
      (skillPaths pack.skillNames) ++ pack.skillPaths)
    packNames);
  defaultSkills = skillsForPackNames piSkills.defaultSkillPackNames;
  profileSkills = name: skillsForPackNames piSkills.profilePackNames.${name};

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

  projectPackManifests = lib.mapAttrs (name: pack:
    pkgs.writeText "pi-pack-${name}.json" (builtins.toJSON {
      inherit name;
      inherit (pack) description skills plugins;
    }))
  piSkills.projectPacks;

  projectPackList = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: pack: "${name}\t${pack.description}") piSkills.projectPacks);
  projectPackInstallCases = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: pack: ''
      ${lib.escapeShellArg name})
        install -d "$target/.agents/skills" "$target/.agents/plugins" "$target/.agents/pi-packs"
        ${lib.concatMapStringsSep "\n" (skill: "link_entry \"$target/.agents/skills/${skill.name}\" ${lib.escapeShellArg skill.path}") pack.skills}
        ${lib.concatMapStringsSep "\n" (plugin: "link_entry \"$target/.agents/plugins/${plugin.name}\" ${lib.escapeShellArg plugin.path}") pack.plugins}
        cp ${projectPackManifests.${name}} "$target/.agents/pi-packs/${name}.json"
        echo "installed Pi pack '${name}' into $target"
        ;;
    '')
    piSkills.projectPacks);
  projectPackShowCases = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: _pack: ''
      ${lib.escapeShellArg name})
        cat ${projectPackManifests.${name}}
        ;;
    '')
    piSkills.projectPacks);

  piPack = pkgs.writeShellApplication {
    name = "pi-pack";
    runtimeInputs = [pkgs.coreutils];
    text = ''
      usage() {
        cat <<'USAGE'
      usage:
        pi-pack list
        pi-pack show <pack>
        pi-pack install <pack> [project-dir]
      USAGE
      }

      link_entry() {
        dest="$1"
        src="$2"

        if [ -e "$dest" ] || [ -L "$dest" ]; then
          if [ ! -L "$dest" ]; then
            echo "refusing to replace existing non-symlink: $dest" >&2
            exit 1
          fi
        fi

        ln -sfnT "$src" "$dest"
      }

      command="''${1:-list}"
      case "$command" in
        list)
          cat <<'PACKS'
      ${projectPackList}
      PACKS
          ;;

        show)
          pack="''${2:-}"
          if [ -z "$pack" ]; then
            usage >&2
            exit 2
          fi

          case "$pack" in
      ${projectPackShowCases}
            *)
              echo "unknown Pi pack: $pack" >&2
              exit 2
              ;;
          esac
          ;;

        install)
          pack="''${2:-}"
          if [ -z "$pack" ]; then
            usage >&2
            exit 2
          fi

          target="''${3:-$PWD}"
          target="$(cd "$target" && pwd -P)"

          case "$pack" in
      ${projectPackInstallCases}
            *)
              echo "unknown Pi pack: $pack" >&2
              exit 2
              ;;
          esac
          ;;

        help|--help|-h)
          usage
          ;;

        *)
          usage >&2
          exit 2
          ;;
      esac
    '';
  };

  piSettings = {
    defaultProvider = "openai-codex";
    defaultModel = "gpt-5.5";

    # Use the Nix-provided npm for Pi package install/update operations.
    npmCommand = ["${pkgs.nodejs}/bin/npm"];

    enableSkillCommands = true;

    packages = piSkills.packages;

    skills = defaultSkills;

    theme = "catppuccin-mocha";
  };

  skillFlags = skills: lib.concatMapStringsSep " " (skill: "--skill ${skill}") skills;
in {
  home.packages = [
    piPkg
    piSkillsInstall
    piSkillsUpdate
    piSkillsCheck
    piPack
  ];
  home.file.".pi/agent/settings.json".text = builtins.toJSON piSettings;

  programs.zsh.shellAliases = {
    # Exact profile launchers: no implicit skill discovery; only the listed
    # installed/updateable skills are loaded.
    pi-code = "${pi} --no-skills ${skillFlags (profileSkills "code")}";
    pi-data = "${pi} --no-skills ${skillFlags (profileSkills "data")}";
    pi-aws = "${pi} --no-skills ${skillFlags (profileSkills "aws")}";
    pi-logfire = "${pi} --no-skills ${skillFlags (profileSkills "logfire")}";
    pi-pydantic = "${pi} --no-skills ${skillFlags (profileSkills "pydantic")}";

    # Keep previous names as aliases.
    pi-code-clean = "pi-code";
    pi-data-clean = "pi-data";

    # Skill package maintenance.
    pi-skills-reinstall = "pi-skills-install";
  };
}
