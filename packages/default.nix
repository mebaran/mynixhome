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
    workmux
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
      gnutar
      zstd

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
      imagemagick
      openssl
      psutils
      rage
      which
      miller
      dconf
      nix-update

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor
      alejandra

      # productivity
      glow # markdown previewer in terminal
      just # project command runner and executable runbooks

      # JavaScript and TypeScript runtimes
      deno
      nodejs

      # cloud
      # awscli2 installed via home manager
      google-cloud-sdk
      opentofu
      render-cli

      # AV
      mpv
      # ffmpeg-full
    ]
    ++ localPackages
    ++ aipkgs
    ++ lib.attrValues mytools;
  home.sessionVariables = {
    USQL_PAGER = "pspg";
  };
}
