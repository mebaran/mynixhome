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
    ./packages.nix
    ./programs
    ./programs/python.nix
    ./programs/zsh.nix
    ./programs/zellij/zellij.nix
    ./programs/goose/goose.nix
    ./files.nix
  ];
}
