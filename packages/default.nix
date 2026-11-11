{
  lib,
  pkgs,
  aitools,
  ...
}: let
  aipkgs = with aitools; [
    # codex-acp
    claude-code
    hunk
    skills
  ];
  localPackages = lib.attrValues {
    dbxcli = pkgs.callPackage ./dbxcli.nix {};
    pgservicedburi = pkgs.callPackage ./pgservicedburi.nix {};
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

      # shared libs needed by nushell plugins (e.g. gstat)
      libgit2
      zstd 

      # utils
      yq-go # yaml processor https://github.com/mikefarah/yq
      poppler-utils
      watch

      # networking tools
      curl
      eternal-terminal
      mosh
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
      ffmpeg
      openssl
      psutils
      rage
      which
      miller
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
      playwright-test

      # cloud
      # awscli2 installed via home manager
      # google-cloud-sdk  # disabled: not needed
      opentofu
      render-cli
    ]
    ++ localPackages
    ++ aipkgs;
  home.sessionVariables = {
    USQL_PAGER = "pspg";
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
  };
}
