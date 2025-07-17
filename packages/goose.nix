{pkgs}: let
  mkGoosePackage = {
    urlSuffix,
    sha256,
    isDarwin ? false,
  }:
    pkgs.stdenv.mkDerivation rec {
      pname = "goose"; #-${archSuffix}";
      version = "1.1.1";

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
    sha256 = "1h3x23kjw17cg2y7z4j7hmc22nr9fv7qczgr587q0q15w20fvwl3";
  };

  aarch64-linux = mkGoosePackage {
    urlSuffix = "aarch64-unknown-linux-gnu";
    sha256 = "03qzjiasx7qa466acw2sgvn9xc3nq6gaqx75kjgq4s1pb4qw932g";
  };

  aarch64-darwin = mkGoosePackage {
    urlSuffix = "aarch64-apple-darwin";
    sha256 = "1i3lj6gygmjqr5yzzpbdwzq2m8r1qyy16nb454jags2jh419gsbq";
    isDarwin = true;
  };
}
