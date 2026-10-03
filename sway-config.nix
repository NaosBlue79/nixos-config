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

  services.mako = {
    enable = true;
    settings = {
      font = "Iosevka Nerd Font 11";
      background-color = mocha.base;
      text-color = mocha.text;
      border-color = mocha.blue;
      border-size = 2;
      padding = "12,15";
      margin = "10";
      default-timeout = 3000;
      # Add urgency levels for visual hierarchy
      icons = "on";
      max-icon-size = 32;
    };
  };

  programs.wofi = {
    enable = true;
    settings = {
      width = 450;
      height = 350;
      location = "top_center";
      show = "drun";
      prompt = "Applications";
      insensitive = true;
      allow_images = true;
      image_size = 32;
    };
    style = ''
      * {
        font-family: "Iosevka Nerd Font";
        font-size: 12px;
        all: unset;
      }

      window {
        background-color: ${mocha.base};
        border: 2px solid ${mocha.lavender};
        border-radius: 8px;
        padding: 12px;
      }

      #input {
        background-color: ${mocha.surface0};
        color: ${mocha.text};
        padding: 8px 12px;
        border: 1px solid ${mocha.surface1};
        border-radius: 6px;
        margin-bottom: 12px;
      }

      #input:focus {
        border: 1px solid ${mocha.blue};
        outline: 2px solid ${mocha.blue}22;
      }

      #outer-box {
        padding: 4px;
      }

      #scroll {
        padding: 4px;
      }

      #entry {
        padding: 6px 8px;
        border-radius: 4px;
        color: ${mocha.text};
      }

      #entry:selected {
        background-color: ${mocha.surface1};
        color: ${mocha.blue};
      }

      #text {
        color: ${mocha.text};
      }

      #text:selected {
        color: ${mocha.blue};
      }
    '';
  };
}
