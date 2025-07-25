{pkgs}: let
  mkGoosePackage = {
    urlSuffix,
    sha256,
    isDarwin ? false,
  }:
    pkgs.stdenv.mkDerivation rec {
      pname = "goose"; #-${archSuffix}";
      version = "1.1.4";

      src = pkgs.fetchzip {
        url = "https://github.com/block/goose/releases/download/v${version}/goose-${urlSuffix}.tar.bz2";
        inherit sha256;
        stripRoot = false; # Adjust to true if the archive has a top-level directory
      };

      nativeBuildInputs =
        if !isDarwin
        then [pkgs.autoPatchelfHook]
        else [];

      buildInputs =
        if !isDarwin
        then [
          pkgs.stdenv.cc.cc.lib # For libc, etc.
          pkgs.xorg.libX11
          # Add more if needed, e.g., pkgs.openssl
        ]
        else [];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        install -Dm755 goose $out/bin/goose  # Adjust if binary name/path differs
        # Copy additional files (e.g., configs, man pages) here if present in src
        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = "Goose AI agent by Block";
        homepage = "https://github.com/block/goose";
        license = licenses.mit; # Verify from repo
        platforms =
          if isDarwin
          then platforms.darwin
          else platforms.linux;
        maintainers = []; # Add if desired
      };
    };
in {
  x86_64-linux = mkGoosePackage {
    urlSuffix = "x86_64-unknown-linux-gnu";
    sha256 = "sha256-UNIdlDLJJ/phO+MrwUFG9IP5IYnszy6S2QpnfJItY54=";
  };

  aarch64-linux = mkGoosePackage {
    urlSuffix = "aarch64-unknown-linux-gnu";
    sha256 = "sha256-o4OgSkGGGL6Euzc4i8XQjdkUOFFMze2UE3jG/RWoW8w=";
  };

  aarch64-darwin = mkGoosePackage {
    urlSuffix = "aarch64-apple-darwin";
    sha256 = "sha256-OAQBRhQE45SARoz3faBzwBJVoQq7K4tfPK/pBsircL4=";
    isDarwin = true;
  };
}
