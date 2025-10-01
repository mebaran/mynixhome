{
  pkgs,
  lib,
  config,
  ...
}: {
  systemd.user.services = {
    cliphist-text = {
      Unit.Description = "wl-paste + cliphist service for text";
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
      };
    };

    cliphist-image = {
      Unit.Description = "wl-paste + cliphist service for text";
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
      };
    };

    swaybg = {
      Unit.Description = "swaybg service";
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swaybg}/bin/.swaybg-wrapped -m fill -i ${
          pkgs.graphite-gtk-theme.override {wallpapers = true;}
        }/share/backgrounds/wave-Dark.jpg";
        Restart = "on-failure";
      };
    };
  };

  services.hypridle.enable = true;

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gtk
  #     xdg-desktop-portal-gnome
  #   ];
  #   config = {
  #     common = {
  #       default = [
  #         "gnome"
  #         "gtk"
  #       ];
  #       "org.freedesktop.impl.portal.Access" = ["gtk"];
  #       "org.freedesktop.impl.portal.Notification" = ["gtk"];
  #       "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
  #       "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
  #     };
  #   };
  # };

  home.packages = with pkgs; [
    cliphist
    hyprlock
    networkmanagerapplet
    playerctl
    qalculate-gtk
    swaynotificationcenter
    swayosd
    wl-clipboard
    wl-clip-persist
    wl-color-picker
    wofi-power-menu
  ]; 
  
  programs = {
    waybar.enable = true;
    wofi.enable = true;

    niri = {
      enable = true;
      settings = {
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
        screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d-%H%M%S.png";
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        environment = {
          ELM_DISPLAY = "wl";
          GDK_BACKEND = "wayland,x11";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland,x11";
          CLUTTER_BACKEND = "wayland";
          NIXOS_OZONE_WL = "1";
        };

        spawn-at-startup = let
          sh = [
            "sh"
            "-c"
          ];
        in [
          {command = sh ++ ["wl-clip-persist --clipboard regular"];}
          {command = sh ++ ["cliphist wipe"];}
          {command = sh ++ ["systemctl --user start app-com.mitchellh.ghostty.service"];}
          {command = sh ++ ["systemctl --user start cliphist-text.service"];}
          {command = sh ++ ["systemctl --user start cliphist-image.service"];}
          {command = sh ++ ["systemctl --user start hypridle.service"];}
          {command = sh ++ ["systemctl --user start waybar.service"];}
          {command = sh ++ ["systemctl --user start swaybg.service"];}
          {command = sh ++ ["systemctl --user start swaync.service"];}
          {command = ["swayosd-server"];}
          {command = ["nm-applet"];}
        ];

        input = {
          power-key-handling.enable = false;
          warp-mouse-to-focus.enable = true;

          mouse = {
            accel-speed = 0.5;
          };

          touchpad = {
            accel-speed = 0.5;
          }; 

          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "25%";
          };
        };

        binds = with config.lib.niri.actions; let
          sh = spawn "sh" "-c";
        in {
          "Alt+Tab".action = toggle-overview;
          "Alt+Right".action = focus-column-or-monitor-right;
          "Alt+Left".action = focus-column-or-monitor-left;
          "Alt+Up".action = focus-window-or-workspace-up;
          "Alt+Down".action = focus-window-or-workspace-down;

          "Ctrl+Alt+D".action = toggle-window-floating;
          "Ctrl+Alt+F".action = fullscreen-window;
          "Ctrl+Alt+Right".action = consume-or-expel-window-right;
          "Ctrl+Alt+Left".action = consume-or-expel-window-left;
          "Ctrl+Alt+Up".action = move-window-up-or-to-workspace-up;
          "Ctrl+Alt+Down".action = move-window-down-or-to-workspace-down;
          "Ctrl+Alt+Return".action = move-window-to-monitor-next;
          "Ctrl+Alt+Q".action = switch-preset-column-width;
          "Ctrl+Alt+A".action = switch-preset-window-height;
          "Ctrl+Alt+W".action = maximize-column;
          "Ctrl+Alt+S".action = expand-column-to-available-width;
          "Ctrl+Alt+Tab".action = toggle-column-tabbed-display;

          "Alt+1".action = focus-workspace 1;
          "Alt+2".action = focus-workspace 2;
          "Alt+3".action = focus-workspace 3;
          "Alt+4".action = focus-workspace 4;
          "Alt+5".action = focus-workspace 5;
          "Alt+6".action = focus-workspace 6;
          "Alt+7".action = focus-workspace 7;
          "Alt+8".action = focus-workspace 8;
          "Alt+9".action = focus-workspace 9;
          "Alt+0".action = focus-workspace 10;

          "Print".action = screenshot;
          "XF86PowerOff".action = sh "pidof wofi-power-menu || wofi-power-menu";
          "XF86AudioMute".action = sh "swayosd-client --output-volume=mute-toggle";
          "XF86AudioPlay".action = sh "playerctl play-pause";
          "XF86AudioPrev".action = sh "playerctl previous";
          "XF86AudioNext".action = sh "playerctl next";
          "XF86AudioRaiseVolume".action = sh "swayosd-client --output-volume=raise";
          "XF86AudioLowerVolume".action = sh "swayosd-client --output-volume=lower";
          "XF86MonBrightnessUp".action = sh "swayosd-client --brightness=raise";
          "XF86MonBrightnessDown".action = sh "swayosd-client --brightness=lower";

          "Super+X".action = close-window;
          "Super+A".action = sh "pidof wofi || wofi"; # launcher
          "Super+L".action = sh "loginctl lock-session"; # lock screen
          "Super+P".action = sh "pidof wofi-power-menu || wofi-power-menu"; # power options
          "Super+Y".action = sh "swaync-client -t"; # notification hub
          "Super+V".action = sh "cliphist list | wofi -S dmenu | cliphist decode | wl-copy"; # clipboard history
          "Super+T".action = spawn "ghostty +new-window"; # terminal
          "Super+C".action = spawn "qalculate-gtk"; # calculator
          "Super+B".action = sh "pidof wl-color-picker || wl-color-picker"; # color-picker
        };

        gestures.hot-corners.enable = false;

        layout = {
          gaps = 8;
          default-column-width.proportion = 0.5;
          insert-hint.display = {
            color = "rgba(224, 224, 224, 30%)";
          };

          preset-column-widths = [
            {proportion = 1.0 / 3.0;}
            {proportion = 0.5;}
            {proportion = 2.0 / 3.0;}
          ];

          preset-window-heights = [
            {proportion = 1.0 / 3.0;}
            {proportion = 0.5;}
            {proportion = 2.0 / 3.0;}
            {proportion = 1.0;}
          ];

          border.enable = false;

          focus-ring = {
            enable = true;
            width = 2;
            active = {
              color = "#e0e0e0ff";
            };
            inactive = {
              color = "#00000000";
            };
          };

          tab-indicator = {
            enable = true;
            place-within-column = true;
            width = 8;
            corner-radius = 8;
            gap = 8;
            gaps-between-tabs = 8;
            position = "top";
            active = {
              color = "rgba(224, 224, 224, 100%)";
            };
            inactive = {
              color = "rgba(224, 224, 224, 30%)";
            };
            length.total-proportion = 1.0;
          };
        };

        overview.backdrop-color = "#0f0f0f";

        window-rules = [
          {
            geometry-corner-radius = let
              radius = 8.0;
            in {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
            clip-to-geometry = true;
            draw-border-with-background = false;
          }
          {
            matches = [
              {app-id = ".blueman-manager-wrapped";}
              {app-id = "nm-connection-editor";}
              {app-id = "com.saivert.pwvucontrol";}
              {app-id = "org.pipewire.Helvum";}
              {app-id = "com.github.wwmm.easyeffects";}
              {app-id = "wdisplays";}
              {app-id = "qalculate-gtk";}
            ];
            open-floating = true;
          }
          {
            matches = [
              {is-window-cast-target = true;}
            ];

            focus-ring = {
              active = {
                color = "rgba(224, 53, 53, 100%)";
              };
              inactive = {
                color = "rgba(224, 53, 53, 30%)";
              };
            };

            tab-indicator = {
              active = {
                color = "rgba(224, 53, 53, 100%)";
              };
              inactive = {
                color = "rgba(224, 53, 53, 30%)";
              };
            };
          }
        ];
      };
    };
  };
}
