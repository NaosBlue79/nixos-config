{ config, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "mz";
  home.homeDirectory = "/home/mz";

  imports = [
    inputs.noctalia.homeModules.default
    ./ghostty.nix
    ./scripts.nix
    ./fetch.nix
    ./niri.nix
    ./pyroclear.nix
  ];

  # User-specific packages
  home.packages = with pkgs; [
    git
    htop
    ripgrep
    fd
    lua
    obsidian
    thunar
    nh
    nom
    manix
    wifitui
    yazi
    spotify
    youtube-tui
    mpvpaper
    mpv
    nixmate
    kitty
  ];

systemd.user.services.noctalia = {
  Unit = {
    Description = "Noctalia Shell";
    After = [ "graphical-session.target" ];
  };

  Service = {
    ExecStart = "${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia";
    Restart = "on-failure";
  };

  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      nixos-update = "sudo nixos-rebuild switch --flake /etc/nixos#znet";
      btw = "echo i us nixos btw";
    };

    profileExtra = ''
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec niri-session
      fi
    '';
  };

  gtk = {
    enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
  };

  home.stateVersion = "26.05";
}
