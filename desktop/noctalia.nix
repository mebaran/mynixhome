{
  config,
  lib,
  pkgs,
  ...
}: let
  noctaliaExe = lib.getExe config.programs.noctalia.package;
  noctaliaMsg = args: lib.escapeShellArgs (["noctalia" "msg"] ++ args);
in {
  config = lib.mkIf (config.me.desktop.shell == "noctalia") {
    programs.noctalia = {
      enable = true;
      systemd.enable = false;
    };

    programs.niri.settings = {
      spawn-at-startup = [
        {argv = [noctaliaExe];}
      ];

      window-rules = [
        {
          matches = [
            {app-id = "dev.noctalia.Noctalia.Settings";}
          ];
          open-floating = true;
          default-column-width.fixed = 1080;
          default-window-height.fixed = 920;
        }
      ];

      debug.honor-xdg-activation-with-invalid-serial = [];

      binds = {
        "Mod+Space".action.spawn-sh = noctaliaMsg ["panel-toggle" "launcher"];
        "Mod+S".action.spawn-sh = noctaliaMsg ["panel-toggle" "control-center"];
        "Mod+Comma".action.spawn-sh = noctaliaMsg ["settings-toggle"];
        "Mod+V".action.spawn-sh = noctaliaMsg ["panel-toggle" "clipboard"];
        "Mod+M".action.spawn-sh = noctaliaMsg ["panel-toggle" "control-center" "system"];
        "Mod+Y".action.spawn-sh = noctaliaMsg ["panel-toggle" "wallpaper"];
        "Super+X".action.spawn-sh = noctaliaMsg ["panel-toggle" "session"];
        "Mod+N".action.spawn-sh = noctaliaMsg ["panel-toggle" "control-center" "notifications"];
        "Ctrl+Alt+Delete".action.spawn-sh = noctaliaMsg ["panel-toggle" "control-center" "system"];

        "XF86AudioRaiseVolume".action.spawn-sh = noctaliaMsg ["volume-up"];
        "XF86AudioLowerVolume".action.spawn-sh = noctaliaMsg ["volume-down"];
        "XF86AudioMute".action.spawn-sh = noctaliaMsg ["volume-mute"];
        "XF86MonBrightnessUp".action.spawn-sh = noctaliaMsg ["brightness-up"];
        "XF86MonBrightnessDown".action.spawn-sh = noctaliaMsg ["brightness-down"];
      };
    };

    home.activation.createNoctaliaWallpaperDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/Pictures/Wallpapers"
    '';

    home.packages = with pkgs; [
      curl
      jq
      wl-clipboard
    ];
  };
}
