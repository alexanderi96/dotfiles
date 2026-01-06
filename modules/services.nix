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

    # 2377: Cluster management
    # 7946: Communication among nodes
    allowedTCPPorts = [ 2377 7946 11434 8000 ];
    
    # 7946: Communication among nodes
    # 4789: Overlay Network Traffic (FONDAMENTALE per vedere Ollama)
    allowedUDPPorts = [ 
      config.services.tailscale.port 
      7946 
      4789 
    ];
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

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    
  };
}
