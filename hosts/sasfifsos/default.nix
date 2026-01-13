# Configuration for Surface Pro (sasfifsos)
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

  # LUKS encryption
  boot.initrd.luks.devices."luks-685ff433-65be-43d2-bdde-2574bf6eca62".device = "/dev/disk/by-uuid/685ff433-65be-43d2-bdde-2574bf6eca62";

  # Hostname
  networking.hostName = "sasfifsos";

  # Time zone
  time.timeZone = "Europe/Rome";

  # Locale settings (Italian)
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Keyboard layout (Italian)
  services.xserver.xkb = {
    layout = "it";
    variant = "";
  };
  console.keyMap = "it2";

  # User account
  users.users.stego = {
    isNormalUser = true;
    description = "Alessandro Ianne";
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "render" ];
  };

  # System state version
  system.stateVersion = "25.05";
}