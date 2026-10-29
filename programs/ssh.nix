{lib, ...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*".AddKeysToAgent = "yes";

      # Dev microvm on omen (see mynixsys). omen serves it on a local port that
      # boots the VM on first connect; everywhere else, jump through omen.
      "liquid-omen" = {
        HostName = "127.0.0.1";
        Port = 2201;
        ProxyJump = "omen";
        HostKeyAlias = "liquid-omen";
      };
      # On omen itself, connect directly (first value wins in ssh_config).
      liquid-omen-on-omen = lib.hm.dag.entryBefore ["liquid-omen"] {
        header = ''Match host liquid-omen exec "test $(hostname -s) = omen"'';
        ProxyJump = "none";
      };
    };
  };
}
