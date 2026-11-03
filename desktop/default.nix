{pkgs, ...}: {
  imports = [
    ./niri-base.nix
    ./noctalia.nix
    ./paseo.nix
  ];

  home.packages = [pkgs.file-roller];

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "gtk-single-instance" = true;
      "quit-after-last-window-closed" = false;
    };
  };
}
