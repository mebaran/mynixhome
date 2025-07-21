{pkgs}: let
  mkOpencodePackage = {
    urlSuffix,
    sha256,
    isDarwin ? false,
  }:
    pkgs.stdenv.mkDerivation rec {
      pname = "opencode";
      version = "0.3.46";

      src = pkgs.fetchzip {
        url = "https://github.com/sst/opencode/releases/download/v${version}/opencode-${urlSuffix}.zip";
        inherit sha256;
        stripRoot = false;
      };

      dontFixup = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        install -Dm755 opencode $out/bin/opencode
        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = "Open-source AI coding agent by SST";
        homepage = "https://github.com/sst/opencode";
        license = licenses.mit; # Assuming MIT, verify from repo
        platforms =
          if isDarwin
          then platforms.darwin
          else platforms.linux;
        maintainers = [];
      };
    };
in {
  x86_64-linux = mkOpencodePackage {
    urlSuffix = "linux-x64";
    sha256 = "sha256-eYMUuf8gqpqTF6/XeQ9sR3NBBhUXfg7pW7o/hJBzCM0=";
  };

  aarch64-linux = mkOpencodePackage {
    urlSuffix = "linux-arm64";
    sha256 = "sha256-KZO1Gwr1O9ZB5MaSKnDnfFqoi3fJR7EosSLbBJ+LQLo=";
  };

  aarch64-darwin = mkOpencodePackage {
    urlSuffix = "darwin-arm64";
    sha256 = "sha256-sUrVU1WRxiYVXIKFUj4TMUJrZ8mXSoQbjSnrW9Gcv9w=";
    isDarwin = true;
  };
}
