{ config, pkgs, ... }:
{
  # User information
  home.username = "stego";
  home.homeDirectory = "/home/stego";

  # User packages
  home.packages = with pkgs; [
    mcfly
    thefuck
    # Terminal and shell
    #kitty
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
      init.defaultBranch = "master";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Shell configuration
  programs.bash = {
    enable = false;
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

    # Integrazione bashrc custom
    home.file.".bashrc".source = ./dotfiles/bashrc;

    # Dotfiles: integrazione file di configurazione
    home.file.".vimrc".source = ./dotfiles/vimrc;

    # Neovim
    home.file.".config/nvim/init.vim".source = ./dotfiles/config/nvim/init.vim;

  # Direnv for development environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Visual Studio Code with extensions (updated)
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ];
      userSettings = {
        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = false;
        "terminal.integrated.fontFamily" = "Hack";
      };
    };
  };

  # Home Manager state version
  home.stateVersion = "25.05";
}

