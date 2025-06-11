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
    UV_PYTHON_DOWNLOADS = "never";
    USQL_PAGER = "pspg";
  };

  imports = [
    ./packages.nix
    ./programs/programs.nix
    ./programs/zsh.nix
    ./programs/zellij/zellij.nix
    ./files.nix
  ];
}
