{
  lib,
  pkgs,
  aitools,
  mytools,
  ...
}: let
  aipkgs = with aitools; [
    # codex-acp
    hunk
    skills
    spec-kit
    workmux
    vix
  ];
  localPackages = lib.attrValues {
    dbxcli = pkgs.callPackage ./dbxcli.nix {};
  };
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
      duckdb

      # misc
      file
      gawk
      gnused
      gnutar
      imagemagick
      openssl
      psutils
      rage
      which
      zstd
      miller
      dconf

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor
      alejandra

      # productivity
      glow # markdown previewer in terminal
      just # project command runner and executable runbooks

      # AI and MCP
      nix-update
      repomix

      # JavaScript and TypeScript runtimes
      deno
      nodejs

      # cloud
      google-cloud-sdk
      opentofu
      render-cli

      # AV
      # ffmpeg-full
    ]
    ++ localPackages
    ++ aipkgs
    ++ lib.attrValues mytools;
  home.sessionVariables = {
    USQL_PAGER = "pspg";
  };
}
