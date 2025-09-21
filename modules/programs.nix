{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Development tools
  programs.git.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Editors and IDEs
    vim
    vscode

    # Development tools
    go
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer

    # Containerization
    podman
    distrobox

    # Productivity
    obsidian

    # Gaming
    steam

    # System utilities
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

  # Podman configuration
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Development environment setup
  programs.direnv.enable = true;
  programs.nix-ld.enable = true;

  # Go configuration
  programs.go.enable = true;

  # VSCode extensions and configuration
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Go
      golang.go
      # Rust
      rust-lang.rust-analyzer
      # General
      ms-vscode.theme-dracula
      vscodevim.vim
      # Git
      eamodio.gitlens
      # Nix
      bbenoist.nix
    ];
  };
}
