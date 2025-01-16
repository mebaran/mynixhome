{ pkgs, ...}:
{
  programs.zsh = {
    enable = true;
    enableVteIntegration = true;
    history = {
      ignoreAllDups = true;
      ignoreSpce = true;
    };
  };
  
  # setup zsh autocomplete plugin
  home.packages = with pkgs; [
    zsh-autocomplete
  ];
  programs.zsh.enableCompletion = false;
  programs.zsh.initExtra = ''
    source ${pkgs.zsh-autocomplete}/zsh-autocomplete.plugin.zsh
    zstyle ':autocomplete:*' min-input 999
    bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
    bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
  '';

  # direnv setup
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd j"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "mebaran";
    email = "mebaran@gmail.com";
    delta.enable = true;
    ignores = [
      ".direnv/"
      ".envrc"
    ];
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = true;
  };

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    agents = [
      "ssh"
    ];
  };
}
