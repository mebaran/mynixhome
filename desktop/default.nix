{
  imports = [
    ./dms.nix
  ];
  programs = {
    ghostty = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
