{ config, pkgs, lib, ... }:

{
  # === 1. KERNEL MODULES & BOOT ===
  # Carichiamo amdgpu subito per evitare che altri driver (es. efifb) occupino la scheda
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Parametri del kernel CRITICI per Passthrough e Compute
  boot.kernelParams = [
    # Forza l'uso del driver amdgpu anche se non è la GPU primaria (c'è QXL)
    "amdgpu.sg_display=0" 
    # A volte necessario per gestire la memoria video virtualizzata
    "amdgpu.vm_update_mode=0"
    # Tenta di riallocare le risorse PCI se il BIOS/Proxmox non lo ha fatto bene
    "pci=realloc"
    # Disabilita gestione energetica aggressiva PCIe che rompe il passthrough
    "pcie_aspm=off"
  ];

  # === 2. FIRMWARE & DRIVER ===
  hardware.enableRedistributableFirmware = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # === 3. GRAPHICS & ROCm ===
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.clr.icd
      amdvlk
    ];
  };

  hardware.amdgpu.initrd.enable = true;

  # === 4. COMPUTE ENVIRONMENT ===
  environment.sessionVariables = {
    # Forza RDNA3 (gfx1100) per evitare che ROCm non riconosca la scheda pass-through
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    # Log più verboso se qualcosa fallisce
    AMD_LOG_LEVEL = "3";
  };

  docker.enableAMD = true;
}