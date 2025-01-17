{ pkgs, ...}:
{
  programs.zsh = {
    enable = true;
    enableVteIntegration = true;
    enableSyntaxHighlighting = true;
    history = {
      ignoreAllDups = true;
      ignoreSpace = true;
    };
  };
  
  # setup zsh autocomplete plugin
  home.packages = with pkgs; [
    zsh-autocomplete
    agkozak-zsh-prompt
  ];
  programs.zsh.enableCompletion = false;
  programs.zsh.initExtra = ''
    source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    zstyle ':autocomplete:*' min-input 999
    bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
    bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

    export AGKOZAK_BLANK_LINES=1 
    fpath += (${pkgs.agkozak-zsh-prompt})
    autoload promptinit; promptinit
    prompt agkozak-zsh-prompt
  '';

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
  };
}
