{
  description = "NixOS and Home Manager Master Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Deliberately NO `follows` here. Nixvim is tested against its own pinned
    # nixpkgs revision, and its docs explicitly recommend against overriding it:
    # "Nixvim is tested against its own Nixpkgs revision. We recommend not
    # overriding its nixpkgs input with follows."
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    areofyl-fetch.url = "github:areofyl/fetch";

    # REMOVED: flake-parts. It was declared but never referenced in `outputs`,
    # so it was a dead input costing an extra fetch.
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      niri,
      noctalia,
      ...
    }@inputs:
    {
      nixosConfigurations.znet = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          { nixpkgs.overlays = [ (import ./overlays/imageio-skip-broken-tests.nix) ]; }

          # REMOVED: nixvim.nixosModules.nixvim
          # Only the Home Manager module is used now, so `programs.nixvim`
          # is defined exactly once (in the HM module namespace).

          niri.nixosModules.niri
          inputs.noctalia.nixosModules.default
          home-manager.nixosModules.home-manager

          {
            # All home-manager settings live here. The duplicate block that was
            # in configuration.nix has been removed.
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            # Makes `inputs` resolvable inside home.nix.
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.mz = {
              imports = [
                ./home.nix
              ];
            };
          }
        ];
      };
    };
}
