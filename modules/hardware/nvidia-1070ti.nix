{ config, pkgs, lib, ... }:

{
  # === NVIDIA (GTX 1070 Ti / Pascal) ===
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false; # Pascal non supportato dal driver open
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "pci=realloc"
  ];

  # Variabili d'ambiente NVIDIA
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };

  # Abilitiamo il supporto Docker NVIDIA definito nel tuo modulo docker.nix
  docker.enableNvidia = true;
}