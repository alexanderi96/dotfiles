{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/hardware/amd-7900xtx.nix # Spostato qui
    ../../modules/programs.nix
    ../../modules/services.nix
    ../../modules/docker.nix
    ../../modules/desktop/cosmic.nix
  ];

  networking.hostName = "powertop";
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  # Input config (mantenute anche se headless, utili in TTY)
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Lascia decidere all'host, non forzare nulla di inutile
  powerManagement.cpuFreqGovernor = "schedutil";
  # Disabilita latency-sensitive tuning inutili in una VM
  powerManagement.scsiLinkPolicy = null;

  # Modello llama.cpp a 256k: la KV sborda ~4GB in RAM host (GTT);
  # con swappiness alto si avevano stalli/crash mid-sessione.
  boot.kernel.sysctl."vm.swappiness" = 10;

  # VM integration
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # 1. Oversteer base udev rules
  services.udev.packages = [ pkgs.oversteer ];

  # 2. Force the G923 out of PlayStation mode into PC mode
  services.udev.extraRules = ''
    # Switch Logitech G923 (PS4/PC) from PS mode (c267) to PC mode
    ATTR{idVendor}=="046d", ATTR{idProduct}=="c267", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 046d -p c267 -M 30f8090701010000 -m 03 -r 03"
  '';

  # 3. Load the custom force feedback driver for Logitech wheels
  boot.extraModulePackages = with config.boot.kernelPackages; [ new-lg4ff ];
  boot.kernelModules = [ "new-lg4ff" ];

  # (Keep your users.users.stego block with the "input" group we added earlier!)
  users.users.stego = {
    isNormalUser = true;
    description = "Alessandro Ianne";
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "render" "input" ];
  };

  system.stateVersion = "25.05";
}
