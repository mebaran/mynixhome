{
  lib,
  pkgs,
  aitools,
  mytools,
  ...
}: let
  bruin = pkgs.callPackage ./bruin.nix {};
  aipkgs = with aitools; [
    codex
    codex-acp
    eca
    gemini-cli
    goose-cli
    opencode
  ];
in {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs;
    [
      bruin
      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      yq-go # yaml processor https://github.com/mikefarah/yq
      poppler-utils
      watch

      # networking tools
      curl
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      wget #classic downloader
      wormhole-rs #magic wormhole with Rust goodness

      #sql
      pspg
      postgresql
      sqlite
      lazysql
      duckdb

      # misc
      broot
      file
      gawk
      gnupg
      gnused
      gnutar
      imagemagick
      psutils
      rage
      which
      zstd
      jujutsu
      miller
      dconf

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nh
      nix-output-monitor

      # productivity
      glow # markdown previewer in terminal

      # AI and MCP
      repomix

      # npm and npx
      bun
      nodejs

      # cloud
      awscli2
      google-cloud-sdk
    ]
    ++ aipkgs ++ lib.attrValues mytools;
  home.sessionVariables = {
    USQL_PAGER = "pspg";
  };
}
