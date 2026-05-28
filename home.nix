{
  aitools,
  config,
  pkgs,
  username,
  homeDirectory,
  ...
}: let
  colors = config.stylix.targets.nixvim.exportedModule;
in {
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";

  gtk.gtk4.theme = config.gtk.theme;

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
  };

  home.stateVersion = "24.11";

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    _module.args.aitools = aitools;
    nixpkgs.useGlobalPackages = true;
    imports = [
      ./nixvim/config
      ./nixvim/lang/nixlang.nix
      ./nixvim/lang/python.nix
      ./nixvim/lang/web.nix
      ./nixvim/lang/sql.nix
      ./nixvim/lang/golang.nix
      ./nixvim/lang/json.nix
      ./nixvim/lang/markdown.nix
      colors
    ];
  };

  imports = [
    ./files
    ./packages
    ./programs
  ];
}
