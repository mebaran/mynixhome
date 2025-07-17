{pkgs}: let
  mkOpencodePackage = {
    urlSuffix,
    sha256,
    isDarwin ? false,
  }:
    pkgs.stdenv.mkDerivation rec {
      pname = "opencode";
      version = "0.3.18";

      src = pkgs.fetchzip {
        url = "https://github.com/sst/opencode/releases/download/v${version}/opencode-${urlSuffix}.zip";
        inherit sha256;
        stripRoot = false;
      };

      nativeBuildInputs =
        if !isDarwin
        then [pkgs.autoPatchelfHook]
        else [];

      buildInputs =
        if !isDarwin
        then [
          pkgs.stdenv.cc.cc.lib
          pkgs.xorg.libX11
        ]
        else [];

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
    sha256 = "1k156f70ch333l3g02g7k7qg3p5z9n0y0jgpzrqcw2z2f7k1g5yq";
  };

  aarch64-linux = mkOpencodePackage {
    urlSuffix = "linux-arm64";
    sha256 = "0qcn3jdh369bsm88b2ljmm33h3h3i7dqyysd84j2y9y6f8yqgqyn";
  };

  aarch64-darwin = mkOpencodePackage {
    urlSuffix = "darwin-arm64";
    sha256 = "12f7q3jmyiw9z7z63l29biw2d2c4d2y30q9b6acwy3wz8d1j8prc";
    isDarwin = true;
  };
}
