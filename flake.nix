{
  description = "NixOS and Home Manager Master Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    areofyl-fetch.url = "github:areofyl/fetch";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }@inputs:
    {
      nixosConfigurations.znet = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
	  nixvim.nixosModules.nixvim
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.mz = {
              imports = [
                nixvim.homeModules.nixvim
                ./home.nix
              ];
            };

	   home-manager.users.root = {
	     imports = [
	       nixvim.homeModules.nixvim
	       ./nixvim.nix
	      ];
	      home.stateVersion = "26.05";
	    };
          }
        ];
      };
    };
}
