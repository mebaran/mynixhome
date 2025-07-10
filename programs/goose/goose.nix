{pkgs, ...}: {
  home = {
    packages = [pkgs.goose-cli];
    file.".config/goose/config.yaml".source = ./config.yaml;
    sessionVariables = {
      GOOSE_PROVIDER = "anthropic";
      GOOSE_MODEL = "claude-sonnet-4-0";
      ANTHROPIC_HOST = "https://api.anthropic.com";
    };
  };
}
