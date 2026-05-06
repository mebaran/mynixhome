{
  imports = [
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
      matchBlocks."*".addKeysToAgent = "yes";
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
