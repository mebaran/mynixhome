{
  mynixvim,
  system,
  username,
  homeDirectory,
  ...
}: {
  home = {
    inherit username homeDirectory;
  };
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  home.packages = [
    mynixvim.packages.${system}.nixlang
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
