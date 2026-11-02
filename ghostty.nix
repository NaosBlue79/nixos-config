{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      # Built-in Ghostty theme
      theme = 
          "Gruvbox Material";
          #"Dracula";
          #"Catppuccin Mocha";
          #"GitHub Dark";
          #TokyoNight";
          #"Aurora";

      # Transparency and blur
      background-opacity = 0.5;
      background-blur = 100;

      # Font installed by configuration.nix
      font-family = "Iosevka Nerd Font";

      # Optional appearance settings
      font-size = 12;
      window-padding-x = 12;
      window-padding-y = 10;
      confirm-close-surface = false;
      cursor-style = "block";
      window-decoration = false;
    };
  };
}
