# Configuration for Desktop (powertop)
{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
    
    # Shared modules
    ../../modules/desktop/hyprland.nix
    ../../modules/programs.nix
    ../../modules/services.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "powertop";

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

  # NVIDIA Configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver)
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # OpenGL and Vulkan
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # NVIDIA Vulkan drivers
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Gaming optimizations for VM
  boot.kernelParams = [
    # GPU passthrough optimizations
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    # VM performance
    "mitigations=off"
    "split_lock_detect=off"
  ];

  # Performance governor for gaming
  powerManagement.cpuFreqGovernor = "performance";

  # Proxmox VM optimizations
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # User account
  users.users.stego = {
    isNormalUser = true;
    description = "Alessandro Ianne";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # System state version
  system.stateVersion = "25.05";
}
