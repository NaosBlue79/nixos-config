{ config, pkgs, ... }:

{
  system.stateVersion = "26.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true; # Optional: detect other OSes like Windows
    };
    efi.canTouchEfiVariables = true; 
  };  
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.displayManager.sddm = {
  enable = true;
  wayland.enable = true; # Enables experimental Wayland support
  # compositor = "kwin"; # Optional: change from default "weston"
  };

  services.xserver.enable = true;  
  programs.niri.enable = true;

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  networking.hostName = "znet";
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Needed for screen locking, notifications, etc. on Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  security.polkit.enable = true;
  services.dbus.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."mz" = {
    isNormalUser = true;
    description = "mz";
    extraGroups = [ "networkmanager" "wheel" ];
  };


  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;


  # System-level packages (available to all users)
  environment.systemPackages = with pkgs; [
    home-manager
    nh
    jq
    git
    vim
    bat
    nixd
    wget
    btop
    neovim
    gparted
    ghostty
    swaylock
    swayidle
    starship
    newsraft
    wl-clipboard
    pavucontrol
    brightnessctl
    proton-vpn
    librewolf
    python3
    win2xcur
    python314Packages.wandb
    imagemagick
    zenity
    wireguard-tools
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

}
