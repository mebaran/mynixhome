{
  lib,
  pkgs,
  aitools,
  skillSources,
  ...
}: let
  # Pi is Nix-managed; Pi packages remain mutable/updateable under ~/.pi/agent.
  piPkg = aitools.pi;
  pi = lib.getExe piPkg;
  npx = "${pkgs.nodejs}/bin/npx";

  globalSkills = {
    skill-creator = ''
      ---
      name: skill-creator
      description: Create, update, validate, and improve Agent Skills for Pi, Codex, Claude Code, or API agents. Use when the user wants a new skill, wants to refactor an existing SKILL.md, asks about skill triggering/frontmatter/progressive disclosure, or wants reusable workflow instructions with scripts, references, or assets.
      ---

      # Skill Creator

      Create skills as compact operational instructions for future agents. Assume the model is capable; include only workflow, domain knowledge, resources, and validation steps that are not obvious from the user request or repository context.

      ## Workflow

      1. Identify the target runtime: Pi, Codex, Claude Code, Claude API, or a portable Agent Skills directory.
      2. Gather 2-4 realistic trigger prompts and failure modes before writing.
      3. Choose the smallest useful structure:
         - `SKILL.md` only for short procedural guidance.
         - `references/` for long docs, schemas, examples, or runtime-specific variants.
         - `scripts/` for deterministic or repeatedly rewritten code.
         - `assets/` for templates, media, boilerplate, or files copied into outputs.
      4. Write frontmatter with `name` and `description`. Prefer lowercase hyphenated names. Make the description trigger-focused: what the skill does, and the concrete user requests or code contexts that should activate it.
      5. Write the body in imperative form. Put action order, tool choices, validation, and boundaries near the top.
      6. Validate with realistic prompts and inspect whether the skill would trigger, whether it gives enough operational detail, and whether it wastes context.

      ## Runtime Conventions

      For portable Agent Skills, project skills live in `.agents/skills/<name>/SKILL.md`; global user skills live in `~/.agents/skills/<name>/SKILL.md`.

      For Pi-native skills, project skills live in `.pi/skills/<name>/SKILL.md`; Pi user skills live in `~/.pi/agent/skills/<name>/SKILL.md`. Prefer `.agents/skills` when the skill should also be visible to Codex-style tooling.

      For Codex, user skills normally live in `$CODEX_HOME/skills` or `~/.codex/skills`. If the OpenAI `skill-creator` system skill is available, read it for the current Codex-specific scaffolding and `agents/openai.yaml` expectations.

      For Claude Code, user skills normally live in `~/.claude/skills`; project skills live in `.claude/skills`. When packaging for Claude apps or API workflows, keep the skill portable and avoid relying on Pi- or Codex-only tools unless the compatibility section says so.

      ## Quality Bar

      Keep `SKILL.md` lean. Move large examples, schemas, API notes, or comparison matrices to referenced files and state when to read them. Do not add README, changelog, or implementation-history files unless the target runtime requires them.

      Include deterministic scripts when correctness matters more than agent discretion. Test any script you add.

      Prefer one strong skill over many overlapping skills. If two skills would trigger on the same request, merge them or make their descriptions clearly non-overlapping.
    '';

    skill-curator = ''
      ---
      name: skill-curator
      description: Audit, prune, organize, and migrate Agent Skill collections for Pi, Codex, Claude Code, or shared repositories. Use when the user wants to simplify a skills system, choose global vs project-local skills, remove redundant skills, compare OpenAI and Claude skills, or design a maintainable skill catalog.
      ---

      # Skill Curator

      Curate for low cognitive load and reliable triggering. A good base catalog is small, general, and high leverage; project catalogs should contain domain-specific workflows, local schemas, cloud/account procedures, and repo conventions.

      ## Default Policy

      Keep global skills to reusable agent operations:
      - skill creation and improvement
      - plugin or tool creation
      - API documentation workflows
      - research/document handling only if used frequently across projects

      Keep local project skills for:
      - cloud accounts, deployment flows, and runbooks
      - product/domain schemas
      - repository architecture and validation commands
      - customer, tenant, or environment-specific procedures

      Avoid globally installing large provider catalogs unless the user invokes them constantly. Prefer on-demand project install for AWS, Kubernetes, database, and framework-specific packs.

      ## Audit Steps

      1. List discovered skill roots and identify source precedence.
      2. Group skills by trigger domain and remove overlaps.
      3. Flag skills that mostly restate model-common knowledge.
      4. Keep skills with scripts, local references, fragile workflows, or high repeat frequency.
      5. Move project-specific skills into `.pi/skills`, `.codex/skills`, or `.claude/skills` inside the repo.
      6. Keep global skills writable only when the user wants interactive editing; otherwise manage them through dotfiles or Home Manager.

      ## Pi Guidance

      Use Pi's `/skill` manager for browsing, previewing, toggling, and creating Pi-native project/global skills. Use `.agents/skills/<name>/SKILL.md` for repo-portable local installs. Use `~/.agents/skills/<name>/SKILL.md` for global skills that should appear across compatible agent runtimes. Use `.pi/skills` or `~/.pi/agent/skills` only when you specifically want Pi-native placement.
    '';

    cli-creator = ''
      ---
      name: cli-creator
      description: Design and build durable command-line tools for future agents, especially from APIs, OpenAPI specs, SDKs, local scripts, admin workflows, or repeated shell procedures. Use when the user wants a reusable CLI plus a companion skill rather than a one-off script.
      ---

      # CLI Creator

      Build CLIs for repeatable agent use: stable commands, composable reads/writes, predictable JSON output, clear auth, and safe defaults.

      ## Workflow

      1. Confirm the CLI solves a repeated workflow rather than a one-off task.
      2. Choose the smallest runtime that fits the repo: existing language/toolchain first; Python or Node only when the repo lacks a better convention.
      3. Provide read commands before write commands. Writes should support dry-run or preview when practical.
      4. Emit stable JSON for machine consumption; keep human formatting optional.
      5. Make auth explicit through env vars, config files, or existing local credentials. Never bake secrets into generated files.
      6. Add focused tests for parsing, auth/config resolution, and at least one read path.
      7. Create a companion skill that tells future agents which command to run first, how to discover IDs, how to perform safe reads, and what requires user approval.

      ## Companion Skill Checklist

      Include command existence checks, auth setup, discovery commands, safe examples, write/dry-run examples, validation commands, and boundaries. Keep API reference details in CLI docs or `references/`, not in the skill body.
    '';

    openai-docs = ''
      ---
      name: openai-docs
      description: Answer or implement work involving OpenAI APIs, Codex, ChatGPT apps, Agents SDK, Responses API, Realtime API, model selection, model migration, or OpenAI prompt upgrades. Use when current OpenAI documentation or Codex behavior matters.
      ---

      # OpenAI Docs

      Prefer official OpenAI documentation over memory. For current facts, search or fetch official OpenAI sources first, especially for model names, API parameters, SDK behavior, pricing, availability, or Codex customization surfaces.

      ## Source Priority

      Use developer documentation, API reference, and the Codex manual before third-party sources. Restrict fallback web searches to official OpenAI domains unless the user asks for broader research.

      ## Codex Surface Map

      Use the smallest durable surface:
      - Prompt/thread context for one-off instructions.
      - `AGENTS.md` for repo conventions.
      - `.codex/config.toml` for trusted-repo Codex settings.
      - Global config for personal defaults.
      - Skill for reusable task workflows.
      - Plugin for skills plus commands, MCP servers, hooks, or assets.
      - MCP/app connector for live external data or authorized private workspace data.

      ## Answering Rules

      State when current docs could not be checked. Keep migrations narrow and behavior-preserving. Do not invent model availability, API fields, or pricing.
    '';
  };

  openaiGlobalSkillNames = [
    "yeet"
    "gh-address-comments"
    "gh-fix-ci"
  ];

  globalSkillFiles = lib.mapAttrs' (name: text:
    lib.nameValuePair ".agents/skills/${name}/SKILL.md" {inherit text;})
  globalSkills;

  openaiGlobalSkillFiles = builtins.listToAttrs (map (name: {
      name = ".agents/skills/${name}";
      value.source = "${skillSources.openai-skills}/skills/.curated/${name}";
    })
    openaiGlobalSkillNames);

  # Fallback pi theme generated from the stylix base16 scheme
  # (tokyo-city-dark). Used whenever no noctalia/matugen theme is active;
  # the noctalia-theme extension overrides it at runtime when present.
  piTheme = {
    name = "tokyo-city";
    vars = {
      bg = "#171D23"; # base00
      bgAlt = "#1D252C"; # base01
      bgHigh = "#28323A"; # base02
      gray = "#526270"; # base03
      fgMuted = "#B7C5D3"; # base04
      fg = "#D8E2EC"; # base05
      red = "#F7768E"; # base08
      orange = "#FF9E64"; # base09
      green = "#9ECE6A"; # base0B
      cyan = "#89DDFF"; # base0C
      blue = "#7AA2F7"; # base0D
      purple = "#BB9AF7"; # base0E
    };
    colors = {
      accent = "blue";
      border = "bgHigh";
      borderAccent = "blue";
      borderMuted = "bgHigh";
      success = "green";
      error = "red";
      warning = "orange";
      muted = "fgMuted";
      dim = "gray";
      text = "";
      thinkingText = "fgMuted";
      selectedBg = "bgHigh";
      userMessageBg = "bgAlt";
      userMessageText = "";
      customMessageBg = "bgAlt";
      customMessageText = "";
      customMessageLabel = "blue";
      toolPendingBg = "bgAlt";
      toolSuccessBg = "bgAlt";
      toolErrorBg = "bgAlt";
      toolTitle = "blue";
      toolOutput = "";
      mdHeading = "blue";
      mdLink = "cyan";
      mdLinkUrl = "fgMuted";
      mdCode = "green";
      mdCodeBlock = "";
      mdCodeBlockBorder = "bgHigh";
      mdQuote = "fgMuted";
      mdQuoteBorder = "bgHigh";
      mdHr = "bgHigh";
      mdListBullet = "cyan";
      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "fgMuted";
      syntaxComment = "gray";
      syntaxKeyword = "purple";
      syntaxFunction = "blue";
      syntaxVariable = "orange";
      syntaxString = "green";
      syntaxNumber = "orange";
      syntaxType = "cyan";
      syntaxOperator = "blue";
      syntaxPunctuation = "fgMuted";
      thinkingOff = "bgHigh";
      thinkingMinimal = "gray";
      thinkingLow = "cyan";
      thinkingMedium = "blue";
      thinkingHigh = "purple";
      thinkingXhigh = "red";
      bashMode = "orange";
    };
    export = {
      pageBg = "#171D23";
      cardBg = "#1D252C";
      infoBg = "#28323A";
    };
  };

  piSettings = {
    defaultProvider = "openai-codex";
    defaultModel = "gpt-5.5";

    theme = "tokyo-city";

    # Use the Nix-provided npm for Pi package install/update operations.
    npmCommand = ["${pkgs.nodejs}/bin/npm"];

    enableSkillCommands = true;

    packages = [
      "npm:pi-subagents"
      "npm:pi-lean-ctx"
      "npm:pi-btw"
      "npm:@vanillagreen/pi-web-tools"
      "npm:@vanillagreen/pi-skills-manager"
    ];

    vstack.extensionManager.config."@vanillagreen/pi-web-tools" = {
      enabled = true;
      autoEnable = true;
      defaultProvider = "auto";
      enabledProviders = [
        "exa"
        "exa-mcp"
        "duckduckgo"
        "openai-native"
      ];
      exaDeepResearchEnabled = true;
      exaAdvancedEnabled = true;
    };
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
in {
  home.packages = [
    piPkg
    piSkillsUpdate
    piSkillsCheck
  ];
  home.file =
    {
      ".pi/agent/settings.json".text = builtins.toJSON piSettings;
      ".pi/agent/themes/tokyo-city.json".text = builtins.toJSON piTheme;
    }
    // globalSkillFiles
    // openaiGlobalSkillFiles;
}
