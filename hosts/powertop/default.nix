{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/hardware/nvidia-1070ti.nix # Spostato qui
    ../../modules/programs.nix
    ../../modules/services.nix
    ../../modules/docker.nix
    # NOTA: GNOME e Hyprland sono commentati/rimossi per risparmiare risorse
    # ../../modules/desktop/gnome.nix
  ];

  networking.hostName = "powertop";
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  # Input config (mantenute anche se headless, utili in TTY)
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  powerManagement.cpuFreqGovernor = "performance";

  # VM integration
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  users.users.stego = {
    isNormalUser = true;
    description = "Alessandro Ianne";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  system.stateVersion = "25.05";
}