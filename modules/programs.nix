{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs = {
    git.enable = true;
    direnv.enable = true;
    nix-ld.enable = true;
    tmux.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # === Core Editors ===
    neovim
    vim
    
    # === System Utilities (Spostate da Home Manager) ===
    (btop.override { rocmSupport = true; })
    
    rocmPackages.rocm-smi

    htop
    fd
    ripgrep
    fzf
    bat
    eza
    pciutils
    usbutils
    parted
    wget
    curl
    tree
    unzip
    zip
    aria2
    
    # === GPU/Terminal Tools ===
    vulkan-tools
    vulkan-loader
    imagemagick

    # opencode
  ];
}