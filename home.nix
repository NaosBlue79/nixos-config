{ config, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "mz";
  home.homeDirectory = "/home/mz";

  imports = [
    ./nixvim.nix
    ./ghostty.nix
    ./scripts.nix
    ./fetch.nix
    ./sway-config.nix
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

  home.stateVersion = "26.05";
}
