{
  lib,
  pkgs,
  aitools,
  ...
}: let
  # Pi is Nix-managed; Pi packages remain mutable/updateable under ~/.pi/agent
  # and third-party Agent Skills remain mutable/updateable under ~/.agents/skills.
  #
  piPkg = aitools.pi;

  pi = lib.getExe piPkg;
  npx = "${pkgs.nodejs}/bin/npx";

  # Skills installed by `npx skills add ... -g` normally land here.
  agentSkill = name: "$HOME/.agents/skills/${name}";

  managedSkills = [
    {
      name = "yeet";
      source = "openai/skills@yeet";
    }
    {
      name = "github-code-review";
      source = "ruvnet/ruflo@github-code-review";
    }
    {
      name = "agent-pr-manager";
      source = "ruvnet/ruflo@agent-pr-manager";
    }
    # ── AWS Agent Toolkit (aws/agent-toolkit-for-aws) ──
    # Core skills (13)
    {
      name = "amazon-bedrock";
      source = "aws/agent-toolkit-for-aws@amazon-bedrock";
    }
    {
      name = "aws-amplify";
      source = "aws/agent-toolkit-for-aws@aws-amplify";
    }
    {
      name = "aws-billing-and-cost-management";
      source = "aws/agent-toolkit-for-aws@aws-billing-and-cost-management";
    }
    {
      name = "aws-cdk";
      source = "aws/agent-toolkit-for-aws@aws-cdk";
    }
    {
      name = "aws-cloudformation";
      source = "aws/agent-toolkit-for-aws@aws-cloudformation";
    }
    {
      name = "aws-containers";
      source = "aws/agent-toolkit-for-aws@aws-containers";
    }
    {
      name = "aws-iam";
      source = "aws/agent-toolkit-for-aws@aws-iam";
    }
    {
      name = "aws-messaging-and-streaming";
      source = "aws/agent-toolkit-for-aws@aws-messaging-and-streaming";
    }
    {
      name = "aws-observability";
      source = "aws/agent-toolkit-for-aws@aws-observability";
    }
    {
      name = "aws-sdk-js-v3-usage";
      source = "aws/agent-toolkit-for-aws@aws-sdk-js-v3-usage";
    }
    {
      name = "aws-sdk-python-usage";
      source = "aws/agent-toolkit-for-aws@aws-sdk-python-usage";
    }
    {
      name = "aws-sdk-swift-usage";
      source = "aws/agent-toolkit-for-aws@aws-sdk-swift-usage";
    }
    {
      name = "aws-serverless";
      source = "aws/agent-toolkit-for-aws@aws-serverless";
    }
    # Specialized: analytics (6)
    {
      name = "aws-cleanrooms";
      source = "aws/agent-toolkit-for-aws@aws-cleanrooms";
    }
    {
      name = "connecting-to-data-source";
      source = "aws/agent-toolkit-for-aws@connecting-to-data-source";
    }
    {
      name = "exploring-data-catalog";
      source = "aws/agent-toolkit-for-aws@exploring-data-catalog";
    }
    {
      name = "finding-data-lake-assets";
      source = "aws/agent-toolkit-for-aws@finding-data-lake-assets";
    }
    {
      name = "ingesting-into-data-lake";
      source = "aws/agent-toolkit-for-aws@ingesting-into-data-lake";
    }
    {
      name = "querying-data-lake";
      source = "aws/agent-toolkit-for-aws@querying-data-lake";
    }
    # Specialized: databases (2)
    {
      name = "creating-amazon-aurora-db-cluster-with-instances";
      source = "aws/agent-toolkit-for-aws@creating-amazon-aurora-db-cluster-with-instances";
    }
    {
      name = "exporting-rds-to-s3";
      source = "aws/agent-toolkit-for-aws@exporting-rds-to-s3";
    }
    # Specialized: EC2 (3)
    {
      name = "creating-ec2-image-builder-pipeline";
      source = "aws/agent-toolkit-for-aws@creating-ec2-image-builder-pipeline";
    }
    {
      name = "launching-ec2-instance-with-best-practices";
      source = "aws/agent-toolkit-for-aws@launching-ec2-instance-with-best-practices";
    }
    {
      name = "setting-up-ec2-instance-profiles";
      source = "aws/agent-toolkit-for-aws@setting-up-ec2-instance-profiles";
    }
    # Specialized: migration (1)
    {
      name = "aws-transform";
      source = "aws/agent-toolkit-for-aws@aws-transform";
    }
    # Specialized: networking (5)
    {
      name = "configuring-vpc-endpoints-for-private-aws-service-access";
      source = "aws/agent-toolkit-for-aws@configuring-vpc-endpoints-for-private-aws-service-access";
    }
    {
      name = "connecting-vpcs-with-peering";
      source = "aws/agent-toolkit-for-aws@connecting-vpcs-with-peering";
    }
    {
      name = "creating-production-vpc-multi-az";
      source = "aws/agent-toolkit-for-aws@creating-production-vpc-multi-az";
    }
    {
      name = "enabling-lambda-vpc-internet-access";
      source = "aws/agent-toolkit-for-aws@enabling-lambda-vpc-internet-access";
    }
    {
      name = "routing-traffic-with-route53-and-cloudfront";
      source = "aws/agent-toolkit-for-aws@routing-traffic-with-route53-and-cloudfront";
    }
    # Specialized: operations (3)
    {
      name = "setting-up-cloudtrail-multi-region";
      source = "aws/agent-toolkit-for-aws@setting-up-cloudtrail-multi-region";
    }
    {
      name = "setting-up-cloudwatch-alarm-notifications";
      source = "aws/agent-toolkit-for-aws@setting-up-cloudwatch-alarm-notifications";
    }
    {
      name = "troubleshooting-application-failures";
      source = "aws/agent-toolkit-for-aws@troubleshooting-application-failures";
    }
    # Specialized: security (1)
    {
      name = "creating-secrets-using-best-practices";
      source = "aws/agent-toolkit-for-aws@creating-secrets-using-best-practices";
    }
    # Specialized: serverless (4)
    {
      name = "connecting-lambda-to-api-gateway";
      source = "aws/agent-toolkit-for-aws@connecting-lambda-to-api-gateway";
    }
    {
      name = "connecting-lambda-to-dynamodb";
      source = "aws/agent-toolkit-for-aws@connecting-lambda-to-dynamodb";
    }
    {
      name = "debugging-lambda-timeouts";
      source = "aws/agent-toolkit-for-aws@debugging-lambda-timeouts";
    }
    {
      name = "creating-api-gateway-stage";
      source = "aws/agent-toolkit-for-aws@creating-api-gateway-stage";
    }
    # Specialized: storage (5)
    {
      name = "creating-data-lake-table";
      source = "aws/agent-toolkit-for-aws@creating-data-lake-table";
    }
    {
      name = "securing-s3-buckets";
      source = "aws/agent-toolkit-for-aws@securing-s3-buckets";
    }
    {
      name = "storing-and-querying-vectors";
      source = "aws/agent-toolkit-for-aws@storing-and-querying-vectors";
    }
    {
      name = "troubleshooting-efs";
      source = "aws/agent-toolkit-for-aws@troubleshooting-efs";
    }
    {
      name = "troubleshooting-s3-files";
      source = "aws/agent-toolkit-for-aws@troubleshooting-s3-files";
    }
    {
      name = "lsp-setup";
      source = "github/awesome-copilot@lsp-setup";
    }
    {
      name = "duckdb-docs";
      source = "duckdb/duckdb-skills@duckdb-docs";
    }
    {
      name = "query";
      source = "duckdb/duckdb-skills@query";
    }
    {
      name = "attach-db";
      source = "duckdb/duckdb-skills@attach-db";
    }
    {
      name = "read-file";
      source = "duckdb/duckdb-skills@read-file";
    }
  ];

  skillPath = name: agentSkill name;
  skillInstallLine = skill: "${npx} --yes skills add ${lib.escapeShellArg skill.source} -g -y";

  piSkillsInstall = pkgs.writeShellApplication {
    name = "pi-skills-install";
    text = lib.concatMapStringsSep "\n" skillInstallLine managedSkills;
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

    packages = [
      "npm:pi-subagents"
      "npm:@vanillagreen/pi-skills-manager"
      "npm:@vanillagreen/pi-web-tools"
      "npm:pi-lean-ctx"
      "npm:@victor-software-house/pi-curated-themes"
    ];

    theme = "catppuccin-mocha";

    # Keep global startup lean. Profile aliases below load exact skills with
    # --no-skills and explicit --skill paths.
    skills = [
      (skillPath "yeet")
      (skillPath "github-code-review")
      (skillPath "agent-pr-manager")
    ];
  };

  # ── Profile: coding (general dev + IAM + infrastructure) ──
  codingSkills = [
    (skillPath "aws-iam")
    (skillPath "aws-cdk")
    (skillPath "aws-cloudformation")
    (skillPath "aws-serverless")
    (skillPath "aws-sdk-python-usage")
    (skillPath "connecting-lambda-to-api-gateway")
    (skillPath "connecting-lambda-to-dynamodb")
    (skillPath "debugging-lambda-timeouts")
    (skillPath "creating-api-gateway-stage")
    (skillPath "lsp-setup")
  ];

  # ── Profile: data engineering (DuckDB + AWS analytics/storage/DBs) ──
  dataEngSkills = [
    (skillPath "duckdb-docs")
    (skillPath "query")
    (skillPath "attach-db")
    (skillPath "read-file")
    (skillPath "aws-iam")
    (skillPath "connecting-to-data-source")
    (skillPath "exploring-data-catalog")
    (skillPath "finding-data-lake-assets")
    (skillPath "ingesting-into-data-lake")
    (skillPath "querying-data-lake")
    (skillPath "creating-data-lake-table")
    (skillPath "creating-amazon-aurora-db-cluster-with-instances")
    (skillPath "exporting-rds-to-s3")
    (skillPath "securing-s3-buckets")
    (skillPath "storing-and-querying-vectors")
    (skillPath "troubleshooting-s3-files")
  ];

  # ── Profile: AWS (all 43 Agent Toolkit skills) ──
  awsSkills = map skillPath [
    # Core
    "amazon-bedrock"
    "aws-amplify"
    "aws-billing-and-cost-management"
    "aws-cdk"
    "aws-cloudformation"
    "aws-containers"
    "aws-iam"
    "aws-messaging-and-streaming"
    "aws-observability"
    "aws-sdk-js-v3-usage"
    "aws-sdk-python-usage"
    "aws-sdk-swift-usage"
    "aws-serverless"
    # Analytics
    "aws-cleanrooms"
    "connecting-to-data-source"
    "exploring-data-catalog"
    "finding-data-lake-assets"
    "ingesting-into-data-lake"
    "querying-data-lake"
    # Databases
    "creating-amazon-aurora-db-cluster-with-instances"
    "exporting-rds-to-s3"
    # EC2
    "creating-ec2-image-builder-pipeline"
    "launching-ec2-instance-with-best-practices"
    "setting-up-ec2-instance-profiles"
    # Migration
    "aws-transform"
    # Networking
    "configuring-vpc-endpoints-for-private-aws-service-access"
    "connecting-vpcs-with-peering"
    "creating-production-vpc-multi-az"
    "enabling-lambda-vpc-internet-access"
    "routing-traffic-with-route53-and-cloudfront"
    # Operations
    "setting-up-cloudtrail-multi-region"
    "setting-up-cloudwatch-alarm-notifications"
    "troubleshooting-application-failures"
    # Security
    "creating-secrets-using-best-practices"
    # Serverless
    "connecting-lambda-to-api-gateway"
    "connecting-lambda-to-dynamodb"
    "debugging-lambda-timeouts"
    "creating-api-gateway-stage"
    # Storage
    "creating-data-lake-table"
    "securing-s3-buckets"
    "storing-and-querying-vectors"
    "troubleshooting-efs"
    "troubleshooting-s3-files"
  ];

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
    pi-code = "${pi} --no-skills ${skillFlags codingSkills}";
    pi-data = "${pi} --no-skills ${skillFlags dataEngSkills}";
    pi-aws = "${pi} --no-skills ${skillFlags awsSkills}";

    # Keep previous names as aliases.
    pi-code-clean = "pi-code";
    pi-data-clean = "pi-data";

    # Skill package maintenance.
    pi-skills-reinstall = "pi-skills-install";
  };
}
