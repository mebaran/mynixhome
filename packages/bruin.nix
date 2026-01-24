{ lib, stdenvNoCC, fetchurl }:

let
  pname = "bruin";
  version = "0.11.428";

  sources = {
    x86_64-linux = {
      url = "https://github.com/bruin-data/bruin/releases/download/v${version}/bruin_Linux_x86_64.tar.gz";
      hash = "sha256-6BePhLI/lYUJtQDI78MYJUfC2ntLgO2ia9yNgaCbMkg=";
    };
    aarch64-linux = {
      url = "https://github.com/bruin-data/bruin/releases/download/v${version}/bruin_Linux_arm64.tar.gz";
      hash = "sha256-N2JtViqYht/g1b5jnszX3kPqDwuNmEHKOf2qGQp2KJA=";
    };
    x86_64-darwin = {
      url = "https://github.com/bruin-data/bruin/releases/download/v${version}/bruin_Darwin_x86_64.tar.gz";
      hash = "sha256-kqdNNt2kxJrByd/3A6YpNd0xYecQJeBBJiwGCFzR4GE=";
    };
    aarch64-darwin = {
      url = "https://github.com/bruin-data/bruin/releases/download/v${version}/bruin_Darwin_arm64.tar.gz";
      hash = "sha256-f1OnKghpiS8i+wy0+8P8JzG6TvWCY8drNMavkoY7ycM=";
    };
  };

  srcInfo =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

in
stdenvNoCC.mkDerivation {
  inherit pname version;
  src = fetchurl srcInfo;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    tar -xzf "$src" -C $out/bin
    chmod +x $out/bin/bruin
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI to build data pipelines with SQL and Python";
    homepage = "https://github.com/bruin-data/bruin";
    license = licenses.asl20;
    mainProgram = "bruin";
    platforms = builtins.attrNames sources;
  };
}
