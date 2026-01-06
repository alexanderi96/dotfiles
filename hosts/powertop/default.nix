{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/desktop/gnome.nix
    ../../modules/programs.nix
    ../../modules/services.nix
    ../../modules/docker.nix
  ];

  networking.hostName = "powertop";

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb.layout = "us";
  console.keyMap = "us";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # === NVIDIA (GTX 1070 Ti / Pascal) ===
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false; # REQUIRED: Pascal not supported by open driver
    modesetting.enable = true;
    nvidiaSettings = true;

    powerManagement.enable = false; # more stable in VMs
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

  # Environment variables for NVIDIA
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Add Vulkan ICD path for containers
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };

  powerManagement.cpuFreqGovernor = "performance";

  # === Docker + NVIDIA CDI ===
  docker.enableNvidia = true;

  # === VM integration (Proxmox-friendly) ===
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  users.users.stego = {
    isNormalUser = true;
    description = "Alessandro Ianne";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  system.stateVersion = "25.05";
}
