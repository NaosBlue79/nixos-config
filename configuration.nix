{ config, pkgs, ... }:

{

  nixpkgs.config = {
    allowUnfree = true;
  };

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

  services.displayManager.sddm.enable = true;

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

  services.xserver.enable = true;
  services.displayManager.defaultSession = "niri";
  programs.niri.enable = true;


  # Needed for screen locking, notifications, etc. on Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.nixvim = {
    enable = true;
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
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";


  # System-level packages (available to all users)
  environment.systemPackages = with pkgs; [
    home-manager
    jq
    git
    vim
    bat
    nixd
    wget
    btop
    neovim
    ghostty
    swaylock
    swayidle
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

  environment.sessionVariables = {
    editor = "neovim";
    browser = "librewolf";
    terminal = "ghostty";
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
