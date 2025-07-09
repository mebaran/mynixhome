{
  pkgs,
  lib,
  ...
}: let
  mkZellijWasmPlugin = {
    pname,
    version,
    url,
    hash,
  }:
    pkgs.stdenv.mkDerivation {
      inherit pname version;
      src = pkgs.fetchurl {inherit url hash;};
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/
        cp $src $out/${pname}.wasm
      '';
    };
  zellij-forgot = mkZellijWasmPlugin rec {
    pname = "zellij-forgot";
    version = "0.4.1";
    url = "https://github.com/karimould/zellij-forgot/releases/download/${version}/zellij_forgot.wasm";
    hash = "sha256-kBGZG+I9PMKhXtyAy6XRW4Sqht0/RCDcv86p0WjxvN8=";
  };
  zellij-what-time = mkZellijWasmPlugin rec {
    pname = "zellij-what-time";
    version = "0.1.1";
    url = "https://github.com/pirafrank/zellij-what-time/releases/download/${version}/zellij-what-time.wasm";
    hash = "sha256-EseRfAWVHQXwPli5SwOKkJgS0GB79dqJxSAqqZAONrA=";
  };
  aliasPlugin = a: p: ''${a} location="file:${p}/${p.pname}.wasm"'';
in {
  programs.zellij = {
    enable = true;
    settings = {
      simplified_ui = true;
      pane_frames = false;
      show_startup_tips = false;
    };
  };
  xdg.configFile."zellij/config.kdl".text = lib.strings.concatLines [
    ''
      plugins {
        ${aliasPlugin "forgot" zellij-forgot}
        ${aliasPlugin "what-time" zellij-what-time}
      }
    ''
    (builtins.readFile ./config.kdl)
  ];
  xdg.configFile."zellij/layouts/default.kdl".source = ./layouts/default.kdl;
}
