{
  lib,
  stdenvNoCC,
  fetchurl,
}: let
  version = "3.9.8";
  releases = {
    x86_64-linux = {
      target = "x86_64-unknown-linux-musl";
      hash = "sha256-DZ+S+QdJ2TcQXy6JJlEI8IKqDTqtdULw8Bo+AFexfQg=";
    };
    aarch64-linux = {
      target = "aarch64-unknown-linux-musl";
      hash = "sha256-qa+0LBddw8nlBhF/wQC6ZE0DDoBfNpExBZF8ythaQoA=";
    };
    aarch64-darwin = {
      target = "aarch64-apple-darwin";
      hash = "sha256-K3Sd/fp0p0nIxBHYucGroReCbFXhcedCWTMX6LqOf7M=";
    };
  };
  release = releases.${stdenvNoCC.hostPlatform.system};
in
  stdenvNoCC.mkDerivation {
    pname = "lean-ctx";
    inherit version;

    src = fetchurl {
      url = "https://github.com/yvgude/lean-ctx/releases/download/v${version}/lean-ctx-${release.target}.tar.gz";
      inherit (release) hash;
    };

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -Dm755 lean-ctx "$out/bin/lean-ctx"
      runHook postInstall
    '';

    meta = {
      description = "Cognitive context layer for agentic systems";
      homepage = "https://github.com/yvgude/lean-ctx";
      license = lib.licenses.mit;
      mainProgram = "lean-ctx";
      platforms = builtins.attrNames releases;
    };
  }
