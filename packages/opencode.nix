{pkgs}: let
  mkOpencodePackage = {
    urlSuffix,
    sha256,
    isDarwin ? false,
  }:
    pkgs.stdenv.mkDerivation rec {
      pname = "opencode";
      version = "0.3.19";

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
    sha256 = "sha256-2fpsVRYRrdkPwBM4XcjVX//VF4nSF8q0FFzljqRsprQ=";
  };

  aarch64-linux = mkOpencodePackage {
    urlSuffix = "linux-arm64";
    sha256 = "sha256-DKIMvT+fxDu6GNw7XC+cbv8Vxdf3QxA/VXHSzzlK0rg=";
  };

  aarch64-darwin = mkOpencodePackage {
    urlSuffix = "darwin-arm64";
    sha256 = "sha256-0Bl1Q99We9u5VRwIE3BYPMPLZg8M7mK1whFV4oU3O7s=";
    isDarwin = true;
  };
}
