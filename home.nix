{
  config,
  pkgs,
  mynixvim,
  system,
  username,
  homeDirectory,
  ...
}: let
  colors = config.stylix.targets.nixvim.exportedModule;
in {
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night-eighties.yaml";
  
  programs.home-manager.enable = true;
  
  home = {
    inherit username homeDirectory;
  };
  
  home.stateVersion = "24.11";
  
  home.packages = [
    (mynixvim.packages.${system}.nixlang.extend colors)
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
 
  imports = [
    ./files
    ./packages
    ./programs
  ];
}
