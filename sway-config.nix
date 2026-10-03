{ config, lib, pkgs, ... }:

let
  # Catppuccin Mocha palette
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
    overlay1 = "#7f849c";
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
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "wofi --show drun";

      gaps = {
        inner = 8;
        outer = 4;
      };

      # Enhanced window styling
      window = {
        border = 2;
        titlebar = false;
        commands = [
          {
            criteria = { class = ".*"; };
            command = "border pixel 2";
          }
        ];
      };

      # Color scheme (Catppuccin Mocha)
      colors = {
        focused = {
          border = mocha.lavender;
          background = mocha.base;
          text = mocha.text;
          indicator = mocha.mauve;
          childBorder = mocha.lavender;
        };
        focusedInactive = {
          border = mocha.surface1;
          background = mocha.mantle;
          text = mocha.subtext0;
          indicator = mocha.surface1;
          childBorder = mocha.surface1;
        };
        unfocused = {
          border = mocha.surface0;
          background = mocha.mantle;
          text = mocha.subtext1;
          indicator = mocha.surface0;
          childBorder = mocha.surface0;
        };
        urgent = {
          border = mocha.red;
          background = mocha.base;
          text = mocha.red;
          indicator = mocha.peach;
          childBorder = mocha.red;
        };
        placeholder = {
          border = mocha.overlay0;
          background = mocha.mantle;
          text = mocha.text;
          indicator = mocha.overlay0;
          childBorder = mocha.overlay0;
        };
      };

      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+Return" = "exec ghostty";
          "${mod}+d" = "exec wofi --show drun";
          "${mod}+Shift+q" = "kill";
          "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -b 'Yes' 'swaymsg exit'";
          "${mod}+Shift+o" = "exec swaylock -f -c ${mocha.crust}";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          "${mod}+1" = "workspace 1";
          "${mod}+2" = "workspace 2";
          "${mod}+3" = "workspace 3";
          "${mod}+4" = "workspace 4";
          "${mod}+5" = "workspace 5";
          "${mod}+6" = "workspace 6";
          "${mod}+7" = "workspace 7";
          "${mod}+8" = "workspace 8";
          "${mod}+9" = "workspace 9";

          "${mod}+Shift+1" = "move container to workspace 1";
          "${mod}+Shift+2" = "move container to workspace 2";
          "${mod}+Shift+3" = "move container to workspace 3";
          "${mod}+Shift+4" = "move container to workspace 4";
          "${mod}+Shift+5" = "move container to workspace 5";
          "${mod}+Shift+6" = "move container to workspace 6";
          "${mod}+Shift+7" = "move container to workspace 7";
          "${mod}+Shift+8" = "move container to workspace 8";
          "${mod}+Shift+9" = "move container to workspace 9";

          "${mod}+v" = "split vertical";
          "${mod}+b" = "split horizontal";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+Shift+c" = "reload";

          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        };

      startup = [
        { command = "mako"; }
        { command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway"; }
      ];

      bars = [
        { command = "waybar"; }
      ];

      output = {
        "*" = {
          bg = "${mocha.base} solid_color";
          #bg = /home/mz/Downloads/spacewallpaper.jpg;
        };
      };
    };
  };
}
