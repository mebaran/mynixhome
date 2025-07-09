{pkgs, ...}: let
  pyDist = pkgs.python3.withPackages (ps:
    with ps; [
      ipython
      llm
      llm-anthropic
      llm-gemini
      llm-jq
      llm-ollama
      llm-openrouter
    ]);
in {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip

    # lang runners
    nodejs
    uv

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
    opencode
    repomix

    # npm and npx
    nodejs

    # Python progs
    pyDist
  ];
}
