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
    ./packages
    ./programs
    ./programs/python.nix
    ./programs/tmux.nix
    ./programs/zsh.nix
    ./programs/zellij/zellij.nix
    ./files.nix
  ];
}
