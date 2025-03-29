{
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

    git = {
      enable = true;
      userName = "mebaran";
      userEmail = "mebaran@gmail.com";
      delta.enable = true;
      ignores = [
        ".direnv/"
        ".envrc"
      ];
    };

    lazygit = {
      enable = true;
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    keychain = {
      enable = true;
      enableZshIntegration = true;
      agents = [
        "ssh"
      ];
      keys = [];
    };

    nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
    };

    zellij = {
      enable = true;
      settings = {
        simplified_ui = true;
        pane_frames = false;
        show_startup_tips = false;
      };
    };

  };
}
