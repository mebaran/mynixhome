{
  config,
  paseo,
  ...
}: let
  home = config.home.homeDirectory;
in {
  # `paseo` CLI for pairing (QR/link) and daemon management.
  home.packages = [paseo.default];

  # Paseo daemon for driving coding agents from the phone/web/desktop clients.
  # Mirrors upstream's nix/module.nix, but as a user unit so agents run as us
  # with our claude login and tools. Clients connect directly over tailscale:
  # the port is never opened in the host firewall, which only trusts
  # tailscale0, so binding all interfaces doesn't expose it on the LAN.
  systemd.user.services.paseo = {
    Unit = {
      Description = "Paseo - self-hosted daemon for AI coding agents";
      After = ["network-online.target"];
    };
    Service = {
      Type = "simple";
      Environment = [
        "PASEO_HOME=${home}/.paseo"
        "PASEO_LISTEN=0.0.0.0:6767"
        # DNS-rebinding allowlist for MagicDNS names; IPs are always allowed.
        "PASEO_HOSTNAMES=.tail209f5d.ts.net"
        # Agent CLIs (claude, codex, git, gh, ...) spawned by the daemon need
        # the user's profile, not systemd's minimal PATH.
        "PATH=${home}/.nix-profile/bin:${home}/.local/state/nix/profile/bin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin"
      ];
      ExecStart = "${paseo.default}/bin/paseo-server --no-relay";
      Restart = "on-failure";
      RestartSec = 5;
      KillSignal = "SIGTERM";
      TimeoutStopSec = 15;
    };
    Install.WantedBy = ["default.target"];
  };
}
