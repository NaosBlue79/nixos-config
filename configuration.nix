{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "znet";
  networking.networkmanager.enable = true;

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

  # Enable Wayland + Sway
  services.xserver.enable = true;
  
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

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

  programs.firefox.enable = true;

  # System-level packages (available to all users)
  environment.systemPackages = with pkgs; [
    home-manager
    git
    vim
    wget
    btop
    neovim
    swaylock
    swayidle
    wl-clipboard
    pavucontrol
    brightnessctl
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
