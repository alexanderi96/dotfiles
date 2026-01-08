{ config, pkgs, ... }:
{
  imports = [
    ./programs/git.nix
    ./programs/shell.nix
    ./programs/vscode.nix
    ./programs/direnv.nix
    ./programs/vicinae.nix
  ];

  # User information
  home.username = "stego";
  home.homeDirectory = "/home/stego";

  # User packages
  home.packages = with pkgs; [
    # Shell enhancements
    mcfly
    thefuck
    
    # Development tools
    neovim
    
    # System utilities
    (btop.override { cudaSupport = true; })
    fd
    ripgrep
    fzf
    bat
    eza
    
    # Media and graphics
    gimp
    vlc
    imagemagick  # Required by shot.sh script
    
    # Communication
    discord
    telegram-desktop
    
    # Wayland/Hyprland utilities (ensure these are available)
    grim
    slurp
    swappy
    wl-clipboard
    hyprpicker
    waypaper
    
    # Monitoring tools
    inotify-tools  # Required by waybar start script
  ];

  # ============================================================================
  #                          DOTFILES INTEGRATION
  # ============================================================================

  # Hyprland configuration (complete directory structure)
  xdg.configFile."hypr" = {
    source = ./dotfiles/config/hypr;
    recursive = true;
  };

  # Waybar configuration (complete directory structure)
  xdg.configFile."waybar" = {
    source = ./dotfiles/config/waybar;
    recursive = true;
  };

  # Kitty terminal configuration
  xdg.configFile."kitty" = {
    source = ./dotfiles/config/kitty;
    recursive = true;
  };

  # SwayNC notification daemon configuration
  xdg.configFile."swaync" = {
    source = ./dotfiles/config/swaync;
    recursive = true;
  };

  # Walker application launcher configuration
  xdg.configFile."walker" = {
    source = ./dotfiles/config/walker;
    recursive = true;
  };

  # Wlogout configuration
  xdg.configFile."wlogout" = {
    source = ./dotfiles/config/wlogout;
    recursive = true;
  };

  # Waypaper wallpaper manager configuration
  xdg.configFile."waypaper" = {
    source = ./dotfiles/config/waypaper;
    recursive = true;
  };

  # Wofi (alternative launcher) configuration
  xdg.configFile."wofi" = {
    source = ./dotfiles/config/wofi;
    recursive = true;
  };

  # Alacritty terminal configuration
  xdg.configFile."alacritty" = {
    source = ./dotfiles/config/alacritty;
    recursive = true;
  };

  # Mako notification daemon configuration (alternative to swaync)
  xdg.configFile."mako/config".source = ./dotfiles/config/mako/config;

  # Sov workspace indicator configuration
  xdg.configFile."sov/config".source = ./dotfiles/config/sov/config;

  # Custom scripts directory
  xdg.configFile."scripts" = {
    source = ./dotfiles/config/scripts;
    recursive = true;
  };

  # Neovim configuration
  xdg.configFile."nvim/init.vim".source = ./dotfiles/config/nvim/init.vim;

  # Vim configuration
  home.file.".vimrc".source = ./dotfiles/vimrc;

  # Wallpapers directory
  home.file."Pictures/walls" = {
    source = ./dotfiles/walls;
    recursive = true;
  };

  # Create screenshots directory
  home.file."Pictures/Screenshots/.keep".text = "";

  # Bashrc (custom configuration)
  home.file.".bashrc".source = ./dotfiles/bashrc;

  # Home Manager state version
  home.stateVersion = "25.05";
}
