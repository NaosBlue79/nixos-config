{ config, pkgs, inputs, ... }:

{
 
  home.username = "mz";
  home.homeDirectory = "/home/mz";

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
   ];

    programs.nixvim = {
      enable = true;
   };

  # User-specific packages
  home.packages = with pkgs; [
    git
    htop
  ];

  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake /home/mz/nix-config#znet";
      btw = "echo i us nixos btw";
    };
  };



  # Critically important: This defines the release version state.
  # Match this to your NixOS/Home Manager release version.
  home.stateVersion = "26.05"; 
}

