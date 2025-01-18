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
    mynixvim.packages.${system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    USQL_PAGER = "pspg";
  };

  imports = [
    ./packages.nix
    ./programs.nix
    ./files.nix
  ];
}
