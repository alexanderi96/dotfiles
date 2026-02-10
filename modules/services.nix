{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable experimental features for Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Services System
  services = {
    # SSH daemon
    openssh.enable = true;

    # Tailscale VPN
    tailscale.enable = true;

    ### MONITORING 1: Node Exporter (Hardware VM) ###
    prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [ "systemd" "filesystem" "cpu" "meminfo" "loadavg" "diskstats" "netdev" ];
    };
    
    # Sunshine Game Streaming
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    # Abilita i servizi necessari per il mount NFS (rpcbind, ecc.)
    rpcbind.enable = true;
  };

  # Firewall configuration
  networking.firewall = {
    enable = true;
    # Allow Tailscale
    trustedInterfaces = [ "tailscale0" ];

    # TCP Ports
    allowedTCPPorts = [ 
      2377 
      7946 
      11434 # Ollama
      8000 
      ### MONITORING PORTS ###
      9100  # Node Exporter
      9080  # Radeon Exporter (AMD GPU Light)
      8080  # cAdvisor
    ];
    
    # UDP Ports
    allowedUDPPorts = [ 
      config.services.tailscale.port 
      7946 
      4789 # Overlay Network
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

  # Enable locate database
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
  };
}
