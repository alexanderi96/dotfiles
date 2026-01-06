{ config, pkgs, lib, ... }:

{
  options.docker.enableNvidia = lib.mkEnableOption "Enable NVIDIA CDI support for Docker";

  config = {
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      distrobox
    ];

    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;

      # Docker >= 25 is REQUIRED for proper CDI support
      package = pkgs.docker_25;

      autoPrune = {
        enable = true;
        dates = "weekly";
      };

      # CRITICAL: Enable CDI for GPU passthrough
      daemon.settings = lib.mkIf config.docker.enableNvidia {
        features.cdi = true;
      };
    };

    # Enable NVIDIA Container Toolkit
    hardware.nvidia-container-toolkit.enable = config.docker.enableNvidia;

    # Ensure CDI directory exists
    systemd.tmpfiles.rules = lib.mkIf config.docker.enableNvidia [
      "d /etc/cdi 0755 root root -"
    ];

    # Service to generate CDI specs (REQUIRED!)
    systemd.services.nvidia-cdi-generator = lib.mkIf config.docker.enableNvidia {
      description = "Generate NVIDIA CDI specifications";
      wantedBy = [ "multi-user.target" ];
      after = [ "nvidia-persistenced.service" ];
      
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml";
      };
    };

    users.groups.docker = {};
  };
}
