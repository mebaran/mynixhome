{config, pkgs, ...}: {
  stylix.targets.dank-material-shell.enable = true;

  programs.dank-material-shell = {
    enable = true;
    enableDynamicTheming = false;

    systemd.enable = false;

    niri = {
      enableSpawn = true;
      enableKeybinds = false;
      includes.enable = true;
    };

    plugins = {
      dankterminaltheme.enable = true;
      wallpaperCarousel.enable = true;
      wallpaperShufflerPlugin.enable = true;

      aiAssistant.enable = true;
      aiOverviewControl.enable = true;
      codexBar.enable = true;
      claudeUsage.enable = true;

      nvidiaGpuMonitor.enable = true;
      networkIndicator.enable = true;
      nixMonitor.enable = true;
      dankDiskUsage.enable = true;
      resourceMonitor.enable = true;
      audioInhibit.enable = true;

      webSearch.enable = true;
      dankPomodoroTimer.enable = true;
      timer.enable = true;
      stopwatch.enable = true;
    };
  };

  home.packages = with pkgs; [
    curl
    jq
    wl-clipboard
  ];

  programs.niri.settings.layout.focus-ring = with config.lib.stylix.colors.withHashtag; {
    enable = true;
    width = 4;
    active.color = base0D;
    inactive.color = base03;
    urgent.color = base08;
  };
}
