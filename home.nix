{ config, pkgs, inputs, ... }:

{

  home.stateVersion = "26.05";

  home.username = "mz";
  home.homeDirectory = "/home/mz";

  imports = [
    inputs.noctalia.homeModules.default
    inputs.nixvim.homeModules.nixvim
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

  #systemd.user.services.noctalia = {
  #  Unit = {
  #    Description = "Noctalia Shell";
  #    After = [ "graphical-session.target" ];
  #  };

  #  Service = {
  #    ExecStart = "${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia";
  #    Restart = "on-failure";
  #  };

  #  Install = {
  #    WantedBy = [ "graphical-session.target" ];
  #  };
  #};

  systemd.user.services.noctalia.Service.ExecStart = 
  "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia";

  programs.nixvim = {
    enable = true;
    opts.clipboard = "unnamed plus";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    "oh-my-zsh" = {
      enable = true;
      theme = "";
      plugins = [ "git" "z" ];
    };

    shellAliases = {
      ll = "ls -l";
      nixos-update = "sudo nixos-rebuild switch --flake /etc/nixos#znet";
      btw = "echo i use nixos btw";
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
}
