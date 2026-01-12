{ config, pkgs, lib, ... }:

{
  options.docker = {
    enableNvidia = lib.mkEnableOption "Enable NVIDIA CDI support for Docker";
    enableAMD = lib.mkEnableOption "Enable AMD GPU passthrough support for Docker";
  };

  config = {
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      distrobox
      # Utility per testare le GPU
      clinfo       # Per OpenCL
      libva-utils  # Per accelerazione video (vainfo)
      vulkan-tools # Per Vulkan (vulkaninfo)
    ];

    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      
      # Docker >= 25 necessario per CDI (NVIDIA)
      package = pkgs.docker_25;

      autoPrune = {
        enable = true;
        dates = "weekly";
      };

      # Abilita CDI solo se siamo su NVIDIA
      daemon.settings = lib.mkIf config.docker.enableNvidia {
        features.cdi = true;
      };
    };

    # === CONFIGURAZIONE SPECIFICA NVIDIA ===
    hardware.nvidia-container-toolkit.enable = config.docker.enableNvidia;

    systemd.tmpfiles.rules = lib.mkIf config.docker.enableNvidia [
      "d /etc/cdi 0755 root root -"
    ];

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

    # === CONFIGURAZIONE SPECIFICA AMD ===
    # Su AMD non serve un toolkit proprietario, ma l'utente deve 
    # avere i permessi per accedere ai device di rendering
    users.users.stego.extraGroups = lib.mkIf config.docker.enableAMD [ 
      "video" 
      "render" 
    ];

    # Se usiamo AMD, carichiamo i driver ROCm/OpenCL per container AI/Compute
    hardware.graphics.extraPackages = lib.mkIf config.docker.enableAMD [
      pkgs.rocmPackages.clr.icd
    ];

    users.groups.docker = {};
  };
}