{ config, pkgs, ... }:
{
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable experimental features for Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Services
  services = {
    # SSH daemon
    openssh.enable = true;

    # Tailscale VPN
    tailscale.enable = true;
  };

  # Firewall configuration
  networking.firewall = {
    enable = true;
    # Allow Tailscale
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Enable automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimize nix store
  nix.settings.auto-optimise-store = true;

  # Enable locate database (updated)
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
  };
}

