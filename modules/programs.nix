{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Development tools
  programs = {
    git.enable = true;
    direnv.enable = true;
    nix-ld.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Editors and IDEs
    neovim
    vscode

    # Productivity
    obsidian
    firefox
    beeper

    # Gaming
    steam

    # Essential GPU support
    vulkan-tools
    vulkan-loader

    # System utilities
    tmux
    wget
    curl
    htop
    tree
    unzip
    zip
  ];

  # Steam configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
