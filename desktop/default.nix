{...}: {
  imports = [
    ./niri-base.nix
    ./noctalia.nix
  ];

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "gtk-single-instance" = true;
      "quit-after-last-window-closed" = false;
    };
  };
}
