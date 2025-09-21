{ config, pkgs, ... }:

{
  # User information
  home.username = "stego";
  home.homeDirectory = "/home/stego";

  # User packages
  home.packages = with pkgs; [
    # Terminal and shell
    kitty
    starship
    
    # Development tools
    neovim
    
    # System utilities
    btop
    fd
    ripgrep
    fzf
    bat
    eza
    
    # Media and graphics
    gimp
    vlc
    
    # Communication
    discord
    telegram-desktop
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Alessandro Ianne";
    userEmail = "alessandro.ianne96@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Shell configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    shellAliases = {
      ll = "eza -la";
      la = "eza -la";
      ls = "eza";
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Direnv for development environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Home Manager state version
  home.stateVersion = "25.05";
}