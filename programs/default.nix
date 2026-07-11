{
  xdg.configFile."direnv/direnvrc".text = ''
    use_aws_profile() {
      local profile="''${1:-''${AWS_PROFILE:-default}}"
      local region="''${2:-''${AWS_DEFAULT_REGION:-us-west-2}}"
      local credentials_output
      local credentials_status

      export AWS_PROFILE="$profile"
      export AWS_SDK_LOAD_CONFIG=1

      export AWS_DEFAULT_REGION="$region"
      export AWS_REGION="$region"

      credentials_output="$(
        AWS_PROFILE="$profile" aws configure export-credentials \
          --profile "$profile" \
          --format env \
          --no-cli-pager 2>&1
      )"
      credentials_status=$?

      if [ "$credentials_status" -eq 0 ]; then
        eval "$credentials_output"
        log_status "Loaded AWS credentials for profile '$profile'"
        return 0
      fi

      unset AWS_ACCESS_KEY_ID
      unset AWS_SECRET_ACCESS_KEY
      unset AWS_SESSION_TOKEN
      unset AWS_CREDENTIAL_EXPIRATION

      log_error "AWS credentials unavailable for profile '$profile'"
      log_error "$credentials_output"
      log_status "Run: aws-login '$profile' && direnv reload"
      return 0
    }
  '';

  imports = [
    ./pi.nix
    ./python.nix
    ./tmux.nix
    ./yazi.nix
    ./zellij
    ./zsh.nix
  ];
  programs = {
    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    lesspipe = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fd = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      colors = "auto";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    git = {
      enable = true;
      settings = {
        user.name = "mebaran";
        user.email = "mebaran@gmail.com";
      };
      ignores = [
        ".direnv/"
        ".envrc"
      ];
    };

    lazygit = {
      enable = true;
    };

    gh = {
      enable = true;
    };

    gh-dash = {
      enable = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*".AddKeysToAgent = "yes";
    };

    keychain = {
      enable = true;
      enableZshIntegration = true;
      keys = [];
    };

    nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
    };

    pgcli = {
      enable = true;
      settings = {
        main = {
          pager = "pspg";
          multi-line = true;
        };
      };
    };

    jq = {
      enable = true;
      # colors = "some-color-scheme"; # Replace with actual color scheme if desired
    };

    aria2 = {
      enable = true;
    };

    bat = {
      enable = true;
    };

    btop = {
      enable = true;
    };
  };
}
