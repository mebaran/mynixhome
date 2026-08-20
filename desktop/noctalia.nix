{
  config,
  lib,
  pkgs,
  ...
}: let
  noctaliaExe = lib.getExe config.programs.noctalia.package;
  noctaliaMsg = args: lib.escapeShellArgs (["noctalia" "msg"] ++ args);
in {
  programs.noctalia = {
    enable = true;
    systemd.enable = false;

    settings = {
      shell.polkit_agent = true;

      lockscreen.enabled = true;

      idle = {
        behavior_order = [
          "lock"
          "screen-off"
        ];
        pre_action_fade_seconds = 2;

        behavior.lock = {
          enabled = true;
          timeout = 600;
          action = "lock";
        };

        behavior."screen-off" = {
          enabled = true;
          timeout = 660;
          action = "screen_off";
        };
      };
    };
  };

  xdg.stateFile = let
    templateDir = "noctalia/community-templates/neovim_mini_base16";
    piTemplateDir = "noctalia/community-templates/pi-agent";
  in {
    "${templateDir}/apply.sh".source = ./noctalia/templates/neovim_mini_base16/apply.sh;
    "${templateDir}/matugen-template.lua".source = ./noctalia/templates/neovim_mini_base16/matugen-template.lua;
    "${templateDir}/template.toml".source = ./noctalia/templates/neovim_mini_base16/template.toml;
    "${piTemplateDir}/pi-theme.json" = {
      source = ./noctalia/templates/pi/pi-theme.json;
      force = true;
    };
    "${piTemplateDir}/template.toml" = {
      source = ./noctalia/templates/pi/template.toml;
      force = true;
    };
  };

  wayland.windowManager.niri.settings = {
    _children = [
      {spawn-at-startup = [noctaliaExe];}
      {
        window-rule._children = [
          {match._props.app-id = "dev.noctalia.Noctalia.Settings";}
          {open-floating = true;}
          {default-column-width.fixed = 1080;}
          {default-window-height.fixed = 920;}
        ];
      }
    ];

    binds = {
      "Mod+S".spawn-sh = noctaliaMsg ["panel-toggle" "control-center"];
      "Mod+Comma".spawn-sh = noctaliaMsg ["settings-toggle"];
      "Mod+V".spawn-sh = noctaliaMsg ["panel-toggle" "clipboard"];
      "Mod+M".spawn-sh = noctaliaMsg ["panel-toggle" "control-center" "system"];
      "Mod+Y".spawn-sh = noctaliaMsg ["panel-toggle" "wallpaper"];
      "Super+X".spawn-sh = noctaliaMsg ["panel-toggle" "session"];
      "Mod+N".spawn-sh = noctaliaMsg ["panel-toggle" "control-center" "notifications"];
      "Ctrl+Alt+Delete".spawn-sh = noctaliaMsg ["panel-toggle" "control-center" "system"];

      "XF86AudioRaiseVolume".spawn-sh = noctaliaMsg ["volume-up"];
      "XF86AudioLowerVolume".spawn-sh = noctaliaMsg ["volume-down"];
      "XF86AudioMute".spawn-sh = noctaliaMsg ["volume-mute"];
      "XF86MonBrightnessUp".spawn-sh = noctaliaMsg ["brightness-up"];
      "XF86MonBrightnessDown".spawn-sh = noctaliaMsg ["brightness-down"];
    };
  };

  home.activation.createNoctaliaWallpaperDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/Pictures/Wallpapers"
  '';

  home.packages = with pkgs; [
    curl
    wl-clipboard
  ];
}
