{
  lib,
  skillSources,
}: let
  awsSkillNames = [
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

  duckdbSkillNames = [
    "duckdb-docs"
    "query"
    "attach-db"
    "read-file"
  ];

  openaiSkillNames = [
    "yeet"
  ];

  pydanticSkillNames = [
    "building-pydantic-ai-agents"
    "logfire-instrumentation"
    "logfire-query"
    "logfire-ui"
    "pydantic-ai-harness"
  ];

  logfireSkillNames = [
    "logfire-instrumentation"
    "logfire-query"
    "logfire-ui"
  ];

  otherSkillPackages = [
    {
      name = "github-code-review";
      source = "ruvnet/ruflo@github-code-review";
    }
    {
      name = "agent-pr-manager";
      source = "ruvnet/ruflo@agent-pr-manager";
    }
    {
      name = "lsp-setup";
      source = "github/awesome-copilot@lsp-setup";
    }
  ];

  skillPackagesFor = repo: names:
    map (name: {
      inherit name;
      source = "${repo}@${name}";
    })
    names;

  sourceSkillPath = source: name: "${source}/skills/${name}";
  sourcePluginPath = source: name: "${source}/plugins/${name}";

  namedPaths = pathFor: names:
    map (name: {
      inherit name;
      path = pathFor name;
    })
    names;

  pathEntry = name: path: {inherit name path;};
  pluginSkillsPath = source: name: "${source}/plugins/${name}/skills";
  pydanticSkillPaths = namedPaths (sourceSkillPath skillSources.pydantic-skills) pydanticSkillNames;
  logfireSkillPaths = namedPaths (sourceSkillPath skillSources.pydantic-skills) logfireSkillNames;
in rec {
  packagePacks = {
    core = [
      "npm:pi-subagents"
      "npm:pi-lean-ctx"
      "npm:pi-btw"
      "npm:pi-web-access"
    ];
  };

  defaultPackagePackNames = ["core"];
  packages = lib.unique (lib.concatLists (map (name: packagePacks.${name}) defaultPackagePackNames));

  repositorySkillPaths = [
    "${skillSources.openai-skills}/skills/.curated"
    "${skillSources.openai-skills}/skills/.experimental"
    "${skillSources.duckdb-skills}"
    "${skillSources.duckdb-skills}/skills"
    "${skillSources.aws-agent-toolkit-for-aws}/skills"
    "${skillSources.pydantic-skills}/skills"
  ];

  managedSkills =
    skillPackagesFor "openai/skills" openaiSkillNames
    ++ otherSkillPackages
    ++ skillPackagesFor "aws/agent-toolkit-for-aws" awsSkillNames
    ++ skillPackagesFor "duckdb/duckdb-skills" duckdbSkillNames;

  skillPacks = {
    startup = {
      description = "Default mutable skills loaded by normal Pi sessions.";
      skillNames = [
        "yeet"
        "github-code-review"
        "agent-pr-manager"
      ];
      skillPaths = [];
    };

    repositories = {
      description = "Pinned Nix skill source trees exposed for Pi skill discovery.";
      skillNames = [];
      skillPaths = repositorySkillPaths;
    };

    coding = {
      description = "AWS and LSP skills for software projects.";
      skillNames = [
        "aws-iam"
        "aws-cdk"
        "aws-cloudformation"
        "aws-serverless"
        "aws-sdk-python-usage"
        "connecting-lambda-to-api-gateway"
        "connecting-lambda-to-dynamodb"
        "debugging-lambda-timeouts"
        "creating-api-gateway-stage"
        "lsp-setup"
      ];
      skillPaths = [];
    };

    aws = {
      description = "All managed AWS Agent Toolkit skills.";
      skillNames = awsSkillNames;
      skillPaths = [];
    };

    data-eng = {
      description = "DuckDB, data lake, and database-oriented skills.";
      skillNames =
        duckdbSkillNames
        ++ [
          "aws-iam"
          "connecting-to-data-source"
          "exploring-data-catalog"
          "finding-data-lake-assets"
          "ingesting-into-data-lake"
          "querying-data-lake"
          "creating-data-lake-table"
          "creating-amazon-aurora-db-cluster-with-instances"
          "exporting-rds-to-s3"
          "securing-s3-buckets"
          "storing-and-querying-vectors"
          "troubleshooting-s3-files"
        ];
      skillPaths = [];
    };

    logfire = {
      description = "Pinned Pydantic Logfire skills.";
      skillNames = [];
      skillPaths = map (skill: skill.path) logfireSkillPaths;
    };

    pydantic = {
      description = "All pinned Pydantic skills.";
      skillNames = [];
      skillPaths = map (skill: skill.path) pydanticSkillPaths;
    };
  };

  defaultSkillPackNames = ["startup" "repositories"];

  profilePackNames = {
    code = ["startup" "coding"];
    data = ["startup" "data-eng"];
    aws = ["startup" "aws"];
    logfire = ["startup" "logfire"];
    pydantic = ["startup" "pydantic"];
  };

  projectPacks = {
    aws = {
      description = "Project-local AWS Agent Toolkit skills and plugins.";
      skills = [
        (pathEntry "aws" "${skillSources.aws-agent-toolkit-for-aws}/skills")
      ];
      plugins = namedPaths (sourcePluginPath skillSources.aws-agent-toolkit-for-aws) [
        "aws-core"
        "aws-agents"
        "aws-data-analytics"
      ];
    };

    aws-core = {
      description = "Project-local AWS Core skills and plugin.";
      skills = [
        (pathEntry "aws-core" (pluginSkillsPath skillSources.aws-agent-toolkit-for-aws "aws-core"))
      ];
      plugins = namedPaths (sourcePluginPath skillSources.aws-agent-toolkit-for-aws) ["aws-core"];
    };

    aws-agents = {
      description = "Project-local AWS agent-building skills and plugin.";
      skills = [
        (pathEntry "aws-agents" (pluginSkillsPath skillSources.aws-agent-toolkit-for-aws "aws-agents"))
      ];
      plugins = namedPaths (sourcePluginPath skillSources.aws-agent-toolkit-for-aws) ["aws-agents"];
    };

    aws-data-analytics = {
      description = "Project-local AWS data analytics skills and plugin.";
      skills = [
        (pathEntry "aws-data-analytics" (pluginSkillsPath skillSources.aws-agent-toolkit-for-aws "aws-data-analytics"))
      ];
      plugins = namedPaths (sourcePluginPath skillSources.aws-agent-toolkit-for-aws) ["aws-data-analytics"];
    };

    logfire = {
      description = "Project-local Logfire skills plus Logfire Codex/Pi plugins.";
      skills = [
        (pathEntry "logfire" (pluginSkillsPath skillSources.pydantic-skills "logfire"))
      ];
      plugins = namedPaths (sourcePluginPath skillSources.pydantic-skills) [
        "logfire"
        "logfire-exporter"
      ];
    };

    pydantic = {
      description = "Project-local Pydantic AI and Logfire skills/plugins.";
      skills = [
        (pathEntry "pydantic" "${skillSources.pydantic-skills}/skills")
      ];
      plugins = namedPaths (sourcePluginPath skillSources.pydantic-skills) [
        "ai"
        "logfire"
        "logfire-exporter"
        "pydantic-ai-harness"
      ];
    };
  };

  inherit awsSkillNames duckdbSkillNames openaiSkillNames pydanticSkillNames logfireSkillNames;
}
