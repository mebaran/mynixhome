{pkgs, ...}: let
  pyDist = pkgs.python3.withPackages (ps:
    with ps; [
      ipython
      ipython-sql
      aider-chat
      llm
      llm-anthropic
      llm-gemini
      llm-jq
      llm-ollama
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
    bat
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    poppler-utils
    watch

    # networking tools
    curl
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses
    wormhole-rs #magic wormhole with Rust goodness

    #sql
    pspg
    pgcli
    usql
    sqlite
    postgresql
    lazysql

    # misc
    age
    file
    gawk
    gnupg
    gnused
    gnutar
    imagemagick
    tree
    which
    zstd

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon

    # AI and MCP
    goose-cli

    # Python progs
    pyDist
  ];
}
