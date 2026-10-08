{ config, pkgs, ... }:

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

          bind = with config.lib.niri.actions; [
            { mod = [ "Super" ]; key = "T"; action = spawn "ghostty"; }
            { mod = [ "Super" ]; key = "D"; action = spawn "wofi --show drun"; }
            { mod = [ "Super" ]; key = "Q"; action = spawn  close-window; }
            { mod = [ "Super" "Ctrl" ]; key = "L"; action = spawn "swaylock"; }
          ];
      };
  };
}  
