{ config, pkgs, inputs, ... }:

let
  # Catppuccin Mocha palette (subset used by user-level programs)
  mocha = {
    base = "#1e1e2e";
    crust = "#11111b";
    lavender = "#b4befe";
    surface0 = "#313244";
    surface1 = "#45475a";
    text = "#cdd6f4";
    blue = "#89b4fa";
  };
in
{
  nixpkgs.config.allowUnfree = true;

  home.username = "mz";
  home.homeDirectory = "/home/mz";

  imports = [
    ./nixvim.nix
    ./ghostty.nix
    ./scripts.nix
    ./fetch.nix
    ./waybar-config.nix
  ];

  # User-specific packages
  home.packages = with pkgs; [
    git
    htop
    ripgrep
    fd
    lua
    obsidian
    wofi
    mako
    thunar
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      nixos-update = "sudo nixos-rebuild switch --flake /home/mz/nix-config#znet";
      btw = "echo i us nixos btw";
    };
    profileExtra = ''
      # Auto-start Sway on login
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
  };

  gtk = {
    enable = true;
    theme.name = "Catppuccin-Mocha-Standard-Lavender-dark";
    cursorTheme.name = "Catppuccin-Mocha-Lavender";
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
  };

  # Home Manager-managed wofi (user-level)
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

      #outer-box { padding: 4px; }
      #scroll { padding: 4px; }

      #entry {
        padding: 6px 8px;
        border-radius: 4px;
        color: ${mocha.text};
      }

      #entry:selected {
        background-color: ${mocha.surface1};
        color: ${mocha.blue};
      }

      #text { color: ${mocha.text}; }
      #text:selected { color: ${mocha.blue}; }
    '';
  };

  # Mako as a user program (Home Manager)
  programs.mako = {
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
      icons = "on";
      max-icon-size = 32;
    };
  };

  home.stateVersion = "26.05";
}
