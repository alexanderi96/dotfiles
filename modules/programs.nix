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
    python3Packages.huggingface-hub  # CLI `hf` (lo shim `huggingface-cli` in 1.x è uno stub)
    nfs-utils

    # === Core Editors ===
    neovim
    vim
    
    # === System Utilities (Spostate da Home Manager) ===
    (btop.override { rocmSupport = true; })
    nvtopPackages.amd
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
    screenfetch
    wl-clipboard
    
    # === GPU/Terminal Tools ===
    vulkan-tools
    vulkan-loader
    imagemagick

    oversteer
  ];
}
