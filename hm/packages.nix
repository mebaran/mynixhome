{
  pkgs,
  ...
}: {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    bat
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq

    # networking tools
    curl
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    #sql
    pspg
    pgcli
    psql
    usql

    # misc
    age
    file
    gawk
    gnupg
    gnused
    gnutar
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
  ];

}
