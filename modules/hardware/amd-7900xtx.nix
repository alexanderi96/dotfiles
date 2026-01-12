{ config, pkgs, lib, ... }:

{
  # Driver video AMD
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Supporto grafico e Vulkan
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd # Supporto OpenCL (necessario per calcolo/AI)
      amdvlk                # Driver Vulkan alternativo (opzionale)
    ];
  };

  # Firmware per RDNA 3 (fondamentale per la 7900 XTX)
  hardware.amdgpu.initrd.enable = true;

  # Variabili d'ambiente per forzare l'uso dei driver corretti
  environment.sessionVariables = {
    # Se intendi fare rendering/compute pesante
    ROC_ENABLE_PRE_VEGA = "0"; 
  };

  # Abilitiamo un flag personalizzato per Docker (vedi sezione sotto)
  docker.enableAMD = true;
}