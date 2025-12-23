{ config, pkgs, lib, ... }:

{
  options.docker.enableNvidiaRuntime = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable NVIDIA support for Docker containers on this host.";
  };

  config = {
    # System packages
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      distrobox
    ];

    # Docker configuration
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      
      # Auto-prune configuration
      autoPrune = {
        enable = true;
        dates = "weekly";
      };

      # Daemon settings
      daemon.settings = {
        # Enable CDI (Container Device Interface) for NVIDIA GPU support
        # This is required on NixOS 25.05+ as the old nvidia runtime is deprecated
        features = lib.mkIf config.docker.enableNvidiaRuntime {
          cdi = true;
        };
      };
    };

    # Enable NVIDIA Container Toolkit when GPU support is requested
    # This generates the CDI specifications in /var/run/cdi/
    hardware.nvidia-container-toolkit.enable = config.docker.enableNvidiaRuntime;

    # Docker group
    users.groups.docker = {};
  };
}
