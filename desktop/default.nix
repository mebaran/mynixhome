{
  lib,
  niriPackage,
  ...
}: {
  imports = [
    ./niri-base.nix
    ./dms.nix
    ./noctalia.nix
  ];

  options.me.desktop.shell = lib.mkOption {
    type = lib.types.enum [
      "dms"
      "noctalia"
    ];
    default = "noctalia";
    description = "Desktop shell to run under niri.";
  };

  config.programs = {
    niri.package = niriPackage;

    ghostty = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
