{pkgs, ...}: {
  home = {
    packages = [pkgs.goose-cli];
    file.".config/goose/config.yaml".source = ./config.yaml;
    sessionVariables = {
      GOOSE_PROVIDER = "anthropic";
      ANTHROPIC_HOST = "https://api.anthropic.com";
      GOOSE_MODEL = "claude-sonnet-4-0";
    };
  };
}
