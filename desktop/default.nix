{pkgs, ...}: {
  imports = [
    ./niri-base.nix
    ./noctalia.nix
    ./paseo.nix
  ];

  home.packages = with pkgs; [dconf file-roller mpv];

  xdg.terminal-exec = {
    enable = true;
    settings.default = ["com.mitchellh.ghostty.desktop"];
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "gtk-single-instance" = true;
      "quit-after-last-window-closed" = false;
    };
  };
}
