{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "26.05";

  home.username = "mz";
  home.homeDirectory = "/home/mz";

  imports = [
    inputs.noctalia.homeModules.default
    inputs.nixvim.homeModules.nixvim
    ./nixvim.nix      
    ./ghostty.nix
    ./scripts.nix
    ./fetch.nix
    ./niri.nix
    ./pyroclear.nix
  ];

  # REMOVED: nixpkgs.config.allowUnfree = true;
  # Redundant under home-manager.useGlobalPkgs = true, which reuses the system
  # pkgs instance. allowUnfree is already set in configuration.nix, and setting
  # nixpkgs.config here is at best inert and at worst trips an assertion.

  # Everything you actually use interactively lives here, so it updates
  # independently of the system and rolls back per-user.
  home.packages = with pkgs; [
    # --- moved up from environment.systemPackages ---
    bat
    btop
    jq
    wget
    nixd
    ripgrep
    fd
    htop
    lua
    librewolf
    swaylock
    swayidle
    wl-clipboard # provides wl-copy / wl-paste for the nvim clipboard
    pavucontrol
    newsraft
    imagemagick
    win2xcur
    zenity
    python3
    python314Packages.wandb # verify this exists in your nixpkgs revision
    ghostty
    kitty

    # --- already here ---
    obsidian
    thunar
    nom
    manix
    wifitui
    yazi
    spotify
    youtube-tui
    mpvpaper
    mpv
    nixmate
    lazygit
  ];

  # NOTE: `git`, `nh`, `bat` and `starship` were previously listed in both
  # systemPackages and home.packages. Deduplicated: git/nh stay at system
  # level, bat is here, and starship comes from programs.starship below.
  # `neovim` was also dropped from systemPackages — nixvim provides nvim now.

  # NOTE: Noctalia is registered in three places (nixosModules, homeModules,
  # and this hand-written unit). It works, so it's left alone — but if the
  # shell ever double-starts or fails to start, this is the first suspect.
  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia Shell";
      After = [ "graphical-session.target" ];
    };

    Service = {
      # FIXED: pkgs.system -> pkgs.stdenv.hostPlatform.system
      # (this was the source of the "'system' has been renamed" warning)
      ExecStart = "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

programs.starship = {
  enable = true;
  enableBashIntegration = true;
  enableZshIntegration = true;
  enableFishIntegration = true;

  # Starship configuration settings
  settings = {
    # Inserts a blank line between shell prompts
    add_newline = true;

    # Define the order and layout of prompt modules
    format = ''
      [░▒▓]($style)[$os$username$hostname](bg:#3c3836 fg:#fbf1c7)[▓▒░](fg:#3c3836 bg:#504945)[$directory](bg:#504945 fg:#fbf1c7)[▓▒░](fg:#504945 bg:#b8bb26)[$git_branch$git_status](bg:#b8bb26 fg:#282828)[▓▒░](fg:#b8bb26 bg:#8ec07c)[$c$elixir$elm$golang$haskell$java$julia$nodejs$nim$rust](bg:#8ec07c fg:#282828)[▓▒░](fg:#8ec07c bg:#fe8019)[$nix_shell](bg:#fe8019 fg:#282828)[▓▒░](fg:#fe8019) 
      $character
    '';

    # Gruvbox Material Color Palette Definition
    palettes.gruvbox_material = {
      bg0 = "#282828";
      bg1 = "#3c3836";
      bg2 = "#504945";
      bg3 = "#665c54";
      fg0 = "#fbf1c7";
      fg1 = "#ebdbb2";
      red = "#ea6962";
      orange = "#fe8019";
      yellow = "#a9b665";
      green = "#b8bb26";
      aqua = "#8ec07c";
      blue = "#7daea3";
      purple = "#d3869b";
    };

    # Apply the custom palette
    palette = "gruvbox_material";

    # Module Configurations
    character = {
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
    };

    username = {
      show_always = true;
      style_user = "bg:#3c3836 fg:#fbf1c7";
      style_root = "bg:#3c3836 fg:#ea6962";
      format = "[$user]($style)";
    };

    directory = {
      style = "bg:#504945 fg:#fbf1c7";
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncation_symbol = "…/";
    };

    git_branch = {
      symbol = " ";
      style = "bg:#b8bb26 fg:#282828";
      format = "[ $symbol$branch ]($style)";
    };

    git_status = {
      style = "bg:#b8bb26 fg:#282828";
      format = "[($all_status$ahead_behind )]($style)";
    };

    nix_shell = {
      symbol = " ";
      style = "bg:#fe8019 fg:#282828";
      format = "[ $symbol$state( \\($name\\)) ]($style)";
    };
  };
};

  programs.nixvim = {
    # Routes yanks/deletes to the system clipboard via wl-clipboard.
    opts.clipboard = "unnamedplus";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # theme = "" so starship owns the prompt. A theme here would fight it.
    "oh-my-zsh" = {
      enable = true;
      theme = "";
      plugins = [ "git" "z" "zsh-autosuggestions" "fzf-tab" "copyfile" "copypath" "zsh-syntax-highlighting" ];
    };

    shellAliases = {
      ll = "ls -l";
      nixos-update = "sudo nixos-rebuild switch --flake /etc/nixos#znet";
      btw = "echo i use nixos btw";
    };

    # Starts niri on tty1 when there's no display manager session.
    # NOTE: you also have sddm enabled, so this is a second entry point.
    # Intentional fallback is fine; otherwise drop one of the two.
    profileExtra = ''
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec niri-session
      fi
    '';
  };

  gtk = {
    enable = true;
    # No theme set — add e.g. `theme.name` / `iconTheme.name` if you want one.
  };

  qt = {
    enable = true;
    # NOTE: Kvantum is a Qt *style*, not a platform theme. Left as-is because
    # it currently works. If theming misbehaves, try:
    #   platformTheme.name = "qtct";
    #   style.name = "kvantum";
    platformTheme.name = "kvantum";
  };
}

