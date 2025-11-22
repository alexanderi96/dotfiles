# Configuration for Desktop (powertop)
{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware.nix
    
    # Shared modules
    ../../modules/desktop/gnome.nix
    ../../modules/programs.nix
    ../../modules/services.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "powertop";

  # Cachix for vicinae (avoid rebuilding)
  nix.settings = {
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
  };

  # Time zone
  time.timeZone = "Europe/Rome";

  # Locale settings (English US)
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Keyboard layout (US)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  console.keyMap = "us";

  # === NVIDIA Configuration (GTX 1070 Ti Passthrough) ===
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    # Required for Wayland/Hyprland
    modesetting.enable = true;

    # Power management (disabled for VM stability)
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # Use proprietary driver (open-source not supported for GTX 1070 Ti)
    # Open driver requires Turing architecture or newer
    open = false;

    # Enable NVIDIA settings GUI
    nvidiaSettings = true;

    # Use stable driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia-container-toolkit.enable = true;

  # Hardware acceleration (OpenGL/Vulkan)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # === Kernel Parameters ===
  boot.kernelParams = [
    # NVIDIA DRM modesetting (required for Wayland)
    "nvidia-drm.modeset=1"
    # Preserve video memory allocations (helps with suspend/resume)
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    # PCI resource reallocation (improves passthrough stability)
    "pci=realloc"
    # Performance optimizations
    "mitigations=off"
    "split_lock_detect=off"
  ];

  # CPU governor for maximum performance
  powerManagement.cpuFreqGovernor = "performance";

  # === Proxmox VM Integration ===
  # QEMU guest agent for VM management
  services.qemuGuest.enable = true;
  
  # SPICE agent for display auto-resize and clipboard sharing
  services.spice-vdagentd.enable = true;

  # === NVIDIA-specific Environment Variables ===
  environment.sessionVariables = {
    # GLX vendor library for NVIDIA
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # GBM backend for NVIDIA
    # GBM_BACKEND = "nvidia-drm";
  };

  # User account
  users.users.stego = {
    isNormalUser = true;
    description = "Alessandro Ianne";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # System state version
  system.stateVersion = "25.05";
}
