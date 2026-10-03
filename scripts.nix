{ pkgs, ... }:

let
  nixosApply = pkgs.writeShellApplication {
    name = "nixos-apply";

    runtimeInputs = with pkgs; [
      git
      nix
      sudo
    ];

    text = ''
      set -euo pipefail

      repo="/home/mz/nix-config"
      flake="$repo#znet"

      cd "$repo"

      echo "Staging Nix configuration files..."

      git add \
        flake.nix \
        configuration.nix \
        hardware-configuration.nix \
        home.nix \
        nixvim.nix \
        ghostty.nix \
        scripts.nix

      echo "Checking flake..."
      nix flake check --show-trace

      echo "Rebuilding NixOS..."
      sudo nixos-rebuild switch --flake "$flake" --show-trace

      if ! git diff --cached --quiet; then
        git commit -m "Update NixOS configuration $(date +%F)"
        echo "Configuration committed."
      else
        echo "No staged changes to commit."
      fi

      echo
      echo "Current Git status:"
      git status --short
    '';
  };
in
{
  home.packages = [
    nixosApply
  ];
}
