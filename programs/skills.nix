{skillSources}: let
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
in rec {
  packages = [];

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

  startupSkillNames = [
    "yeet"
    "github-code-review"
    "agent-pr-manager"
  ];

  codingSkillNames = [
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

  dataEngSkillNames =
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

  inherit awsSkillNames duckdbSkillNames openaiSkillNames;
}
