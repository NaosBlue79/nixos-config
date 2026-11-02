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
      useOSProber = true; # detect other OSes like Windows
    };
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver.enable = true;
  programs.niri.enable = true;

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  networking.hostName = "znet";
  networking.networkmanager.enable = true;

  # Left as `false` for WireGuard / Proton VPN. If you ever drop those,
  # "loose" is a narrower setting that keeps some anti-spoofing protection.
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

  # MOVED: programs.nixvim now lives in home.nix. Nixvim generates a *user's*
  # Neovim config, so it belongs in the Home Manager namespace.

  # REMOVED: security.polkit.enable and services.dbus.enable.
  # Both default to true in NixOS, so they were no-ops.

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
    # "video" added for backlight control (brightnessctl).
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # REMOVED: the home-manager block that duplicated flake.nix, plus the
  # commented-out copy of it. All home-manager settings are in flake.nix now.

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;


  # Trimmed to things the *system* needs, or that must exist outside any
  # user session. Interactive tools moved to home.packages in home.nix.
  environment.systemPackages = with pkgs; [
    home-manager # for the `home-manager` CLI
    nh # system rebuild helper
    git # system-level VCS
    vim # minimal rescue editor (keep!)
    gparted # disk administration
    wireguard-tools # needs root to manage interfaces
    proton-vpn # needs daemon / NetworkManager integration
    brightnessctl # backlight, paired with the "video" group above
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];
}
