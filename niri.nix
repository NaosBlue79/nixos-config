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
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#8f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };
in
{
  programs.niri = {
    enable = true;
    settings = {
      input = {
        keyboard = {
          xkb = {
            layout = "us";
          };
        };
        touchpad = {
          tap = true;
          natural-scroll = false;
        };
      };

      output = {
        "eDP-1" = {
          resolution = [ 1600 900 ];
          refresh-rate = 60.0;
          scale = 1.0;
        };
      };

      layout = {
        gaps = 16;
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
      };

      workspaces = [
        { name = "1"; }
        { name = "2"; }
        { name = "3"; }
      ];

      binds = with config.lib.niri.actions; [
        { mod = [ "Super" ]; key = "T"; action = spawn "ghostty"; }
        { mod = [ "Super" ]; key = "D"; action = spawn "wofi --show drun"; }
        { mod = [ "Super" ]; key = "Q"; action = close-window; }
        { mod = [ "Super" "Ctrl" ]; key = "L"; action = spawn "swaylock -f -c ${mocha.crust}"; }

        { mod = [ "Super" ]; key = "H"; action = focus-column-left; }
        { mod = [ "Super" ]; key = "J"; action = focus-window-down; }
        { mod = [ "Super" ]; key = "K"; action = focus-window-up; }
        { mod = [ "Super" ]; key = "L"; action = focus-column-right; }

        { mod = [ "Super" "Shift" ]; key = "H"; action = move-column-left; }
        { mod = [ "Super" "Shift" ]; key = "J"; action = move-window-down; }
        { mod = [ "Super" "Shift" ]; key = "K"; action = move-window-up; }
        { mod = [ "Super" "Shift" ]; key = "L"; action = move-column-right; }

        { mod = [ "Super" ]; key = "1"; action = activate-workspace 0; }
        { mod = [ "Super" ]; key = "2"; action = activate-workspace 1; }
        { mod = [ "Super" ]; key = "3"; action = activate-workspace 2; }

        { mod = [ "Super" "Shift" ]; key = "1"; action = move-window-to-workspace 0; }
        { mod = [ "Super" "Shift" ]; key = "2"; action = move-window-to-workspace 1; }
        { mod = [ "Super" "Shift" ]; key = "3"; action = move-window-to-workspace 2; }

        { mod = [ "Super" ]; key = "F"; action = maximize-column; }
        { mod = [ "Super" ]; key = "C"; action = center-column; }
        { mod = [ "Super" "Shift" ]; key = "F"; action = fullscreen-window; }
        { mod = [ "Super" "Shift" ]; key = "C"; action = reload-config; }

        { mod = []; key = "XF86AudioRaiseVolume"; action = spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"; }
        { mod = []; key = "XF86AudioLowerVolume"; action = spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"; }
        { mod = []; key = "XF86AudioMute"; action = spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"; }
        { mod = []; key = "XF86MonBrightnessUp"; action = spawn "brightnessctl set +5%"; }
        { mod = []; key = "XF86MonBrightnessDown"; action = spawn "brightnessctl set 5%-"; }
      ];
    };
  };
}
