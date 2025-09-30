{pkgs, ...}: {
  imports = [
    ./fuzzel.nix
    ./hyprlock.nix
    ./niri.nix
  ];
  programs = {
    ghostty = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
