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
    sha256 = "sha256-f6pbZRyA/VujXvCONeLhSWccWfH+MpVisclejcYAWLo=";
  };

  aarch64-linux = mkOpencodePackage {
    urlSuffix = "linux-arm64";
    sha256 = "sha256-ayf518hC0DqwkaK92GXgeDC/YTHwByrHbfju3Bm93Ss=";
  };

  aarch64-darwin = mkOpencodePackage {
    urlSuffix = "darwin-arm64";
    sha256 = "sha256-wy+Hb2feHKTDBDG9csoRw7KIYlVA/VAZ4IyOW1PuPoA=";
    isDarwin = true;
  };
}
