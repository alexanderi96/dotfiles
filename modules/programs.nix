{ config, pkgs, ... }:

let
  # huggingface-hub >= 1.0: CLI `hf` (+ shim `huggingface-cli`) e backend Xet.
  # Il canale 25.05 e' fermo a 0.30.2 — pin chirurgico su uno snapshot nixos-unstable.
  nixpkgsHf = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/61b7c44c4073f0b827768aff0049561b5110ea5a.tar.gz";
    sha256 = "1knbr9j7szzlppbp0r9rby06nml7b45vqhmskgycfbcnr1nanqnp";
  }) { system = pkgs.stdenv.hostPlatform.system; };
in
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
    nixpkgsHf.python3Packages.huggingface-hub  # 1.10.2: `hf` + shim `huggingface-cli`
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
