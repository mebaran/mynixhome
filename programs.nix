{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableVteIntegration = true;
    history = {
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
  programs.zsh.enableCompletion = false;
  programs.zsh.initExtra = ''
    # ZSH Autocomplete Config
    zstyle ':autocomplete:*' min-input 999
    bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
    bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

    # AGKOZAK Config
    export AGKOZAK_BLANK_LINES=1
    autoload promptinit; promptinit
    prompt agkozak-zsh-prompt
  '';
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd d"
    ];
  };
  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "enhanced"
    ];
  };
  programs.zsh.shellAliases = {
    j = "z";
  };
  
  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.lesspipe = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fd = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    colors = "auto";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "mebaran";
    userEmail = "mebaran@gmail.com";
    delta.enable = true;
    ignores = [
      ".direnv/"
      ".envrc"
    ];
  };

  programs.lazygit = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    agents = [
      "ssh"
    ];
    keys = [];
  };

  programs.nix-your-shell = {
    enable = true;
    enableZshIntegration = true;
  };
}
