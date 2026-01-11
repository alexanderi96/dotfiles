{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # Media and graphics
    gimp
    vlc
    # Wayland/Hyprland utilities
    grim
    slurp
    swappy
    wl-clipboard
    hyprpicker
    waypaper
    inotify-tools
  ];

  xdg.configFile = {
    "hypr" = { source = ./dotfiles/config/hypr; recursive = true; };
    "waybar" = { source = ./dotfiles/config/waybar; recursive = true; };
    "kitty" = { source = ./dotfiles/config/kitty; recursive = true; };
    "swaync" = { source = ./dotfiles/config/swaync; recursive = true; };
    "walker" = { source = ./dotfiles/config/walker; recursive = true; };
    "wlogout" = { source = ./dotfiles/config/wlogout; recursive = true; };
    "waypaper" = { source = ./dotfiles/config/waypaper; recursive = true; };
    "wofi" = { source = ./dotfiles/config/wofi; recursive = true; };
    "alacritty" = { source = ./dotfiles/config/alacritty; recursive = true; };
    "mako/config".source = ./dotfiles/config/mako/config;
    "sov/config".source = ./dotfiles/config/sov/config;
  };

  home.file."Pictures/walls" = {
    source = ./dotfiles/walls;
    recursive = true;
  };
}