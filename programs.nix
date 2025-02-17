{pkgs, ...}: {
  programs = {
    zsh = {
      enable = true;
      enableVteIntegration = true;
      history = {
        extended = true;
        append = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };
      plugins = with pkgs; [
        {
          name = "zsh-autocomplete";
          src = "${zsh-autocomplete}/share/zsh-autocomplete";
        }
        {
          name = "agkozak-zsh-prompt";
          src = "${agkozak-zsh-prompt}/share/zsh/site-functions";
        }
      ];
      syntaxHighlighting.enable = true;
    };

    # setup zsh autocomplete plugin
    zsh.enableCompletion = false;
    zsh.initExtra = ''
      # ZSH Autocomplete Config
      zstyle ':autocomplete:*' min-input 999
      bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
      bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

      # AGKOZAK Config
      export AGKOZAK_BLANK_LINES=1
      autoload promptinit; promptinit
      prompt agkozak-zsh-prompt
    '';
    zoxide = {
      enable = true;
      options = [
        "--cmd d"
      ];
    };
    z-lua = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "enhanced"
      ];
    };
    zsh.shellAliases = {
      j = "z";
      e = "$EDITOR";
    };
    zsh.envExtra = ''
      if [[ -f "$HOME/.zshkeys" ]]; then
        source "$HOME/.zshkeys"
      fi
    '';

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
  };
}
