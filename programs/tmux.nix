{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.pain-control
      tmuxPlugins.session-wizard
      tmuxPlugins.tmux-fzf
    ];
    keyMode = "vi";
    escapeTime = 0;
  };
  home.packages = [
    pkgs.tmuxp
  ];
}
