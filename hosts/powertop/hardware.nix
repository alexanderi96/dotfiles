# Hardware configuration for Desktop (powertop)
# AMD Ryzen 5800X + NVIDIA GTX 1070Ti in Proxmox VM
# This is a template - adjust UUIDs and disk paths based on actual hardware
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # VM-specific kernel modules
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Filesystem configuration
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/36419627-b992-4a5c-abd3-855a3728c6f0";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1C2A-6F6D";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # Using zram for swap instead of disk partition
  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface
  networking.useDHCP = lib.mkDefault true;

  # AMD CPU microcode updates
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Proxmox VM optimizations
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
}