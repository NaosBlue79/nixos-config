 { config, lib, pkgs, ... }:

let
  mocha = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    surface0 = "#313244";
    surface1 = "#45475a";
    base = "#1e1e2e";
    crust = "#11111b";
  };
in
{
  programs.niri = {
    settings = {

      input = {
        keyboard.xkb.layout = "us";

        touchpad = {
          tap = true;
          natural-scroll = false;
          click-method = "button-areas";
        };
      };

      layout = {
        gaps = 16;
        always-center-single-column = true;

        focus-ring = {
          enable = true;
          width = 3;
          active.color = mocha.lavender;
          inactive.color = mocha.surface1;
        };

        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
      };

      workspaces = {
        "1" = {};
        "2" = {};
        "3" = {};
        "4" = {};
        "5" = {};
      };

      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "mako" ]; }
        { command = [ "swww-daemon" ];}
        { command = [ "swww" "img" "/home/mz/Downloads/wallhaven-oggvw9.jpg"]; }
      ];

      binds = with config.lib.niri.actions; {

        #
        # Applications
        #
        "Mod+Return".action = spawn "ghostty";
        "Mod+T".action = spawn "ghostty";
        "Mod+D".action = spawn "wofi" "--show" "drun";
        "Mod+E".action = spawn "thunar";
        "Mod+B".action = spawn "firefox";

        #
        # Session
        #
        "Mod+Q".action = close-window;
        "Mod+Shift+Q".action = quit;

        "Mod+Ctrl+L".action =
          spawn "swaylock" "-f" "-c" mocha.crust;

        #"Mod+Shift+C".action = reload-config;

        #
        # Navigation
        #
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;

        #
        # Move windows
        #
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+L".action = move-column-right;

        #
        # Layout
        #
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;

        #
        # Floating
        #
        "Mod+V".action = toggle-window-floating;

        #
        # Workspaces
        #
        "Mod+1".action = focus-workspace "1";
        "Mod+2".action = focus-workspace "2";
        "Mod+3".action = focus-workspace "3";
        "Mod+4".action = focus-workspace "4";
        "Mod+5".action = focus-workspace "5";

        #
        # Audio
        #
        "XF86AudioRaiseVolume".action =
          spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+5%";

        "XF86AudioLowerVolume".action =
          spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-5%";

        "XF86AudioMute".action =
          spawn "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle";

        #
        # Brightness
        #
        "XF86MonBrightnessUp".action =
          spawn "brightnessctl" "set" "+5%";

        "XF86MonBrightnessDown".action =
          spawn "brightnessctl" "set" "5%-";
      };
    };
  };
}
