{pkgs, system, ...}: let
  goose-pkg = pkgs.callPackage ./goose.nix {inherit pkgs;};
  opencode-pkg = pkgs.callPackage ./opencode.nix {inherit pkgs;};
in {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
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
    ipcalc # it is a calculator for the IPv4/v6 addresses
    wormhole-rs #magic wormhole with Rust goodness

    #sql
    pspg
    usql
    sqlite
    postgresql
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

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    # AI and MCP
    gemini-cli
    repomix

    # npm and npx
    bun
    nodejs
    
    # custom packages
    goose-pkg.${system} #latest goose
    opencode-pkg.${system} #latest opencode
  ];
  home.sessionVariables = {
    USQL_PAGER = "pspg";
  };
}
