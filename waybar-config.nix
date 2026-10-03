{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;

        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "clock" = {
          format = "{:%H:%M %Z}";
          timezone = "America/Chicago";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><big>{:%A, %d %B %Y}</big></tt>";
        };

        "pulseaudio" = {
          format = "♪ {volume}%";
          format-muted = "♪ muted";
          on-click = "pavucontrol";
        };

        "network" = {
          format-wifi = "Wi-Fi {essid} ({signalStrength}%)";
          format-ethernet = "Ethernet";
          format-disconnected = "Disconnected";
        };

        "cpu" = {
          format = "CPU {usage}%";
          interval = 10;
        };

        "memory" = {
          format = "RAM {percentage}%";
          interval = 10;
        };

        "battery" = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = [ "󰂎" "󰂏" "󰂐" "󰂑" "󰂒" "󰂓" "󰂔" "󰂕" "󰂖" "󰂗" "󰂘" ];
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "Iosevka Nerd Font";
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.95);
        color: #cdd6f4;
        border-bottom: 1px solid #45475a;
      }

      #workspaces button {
        padding: 0 10px;
        color: #a6adc8;
      }

      #workspaces button.active {
        color: #a6e3a1;
        background-color: rgba(166, 227, 161, 0.1);
      }

      #workspaces button:hover {
        color: #f38ba8;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio {
        padding: 0 15px;
        color: #cdd6f4;
      }

      #battery.charging {
        color: #a6e3a1;
      }

      #battery.warning {
        color: #f9e2af;
      }

      #battery.critical {
        color: #f38ba8;
      }

      #tray {
        padding: 0 10px;
      }
    '';
  };
}
