{
  lib,
  pkgs,
  aitools,
  mytools,
  ...
}: let
  aipkgs = with aitools; [
    codex
    gemini-cli
    goose-cli
    qwen-code
  ];
in {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs;
    [
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
    ]
    ++ aipkgs ++ lib.attrValues mytools;
  home.sessionVariables = {
    USQL_PAGER = "pspg";
  };
}
