{ inputs, ... }:

{
  imports = [
    # This module is imported in fetch.nix.
    # Do not import it again in home.nix or flake.nix.
    inputs.areofyl-fetch.homeManagerModules.default
  ];

  programs.fetch = {
    enable = true;

    labelColor = "blue";

    info = [
      "os"
      "host"
      "kernel"
      "uptime"
      "packages"
      "shell"
      "display"
      "wm"
      "terminal"
      "cpu"
      "memory"
      "disk"
      "ip"
      "battery"
    ];

    speed = 1.0;
    spin = "xy";
    shading = #".,-~:;=!*#$@";
	      #" ․⁚⁖⁘⁙";
	      #" ░▒▓█";
	      #"oO8oO0QoQ0o8Oo";
        "NaosBlue79";
    light = "top-left";
  };
}
