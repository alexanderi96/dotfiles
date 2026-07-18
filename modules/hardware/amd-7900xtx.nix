{ config, pkgs, lib, ... }:
{
  # === 1. KERNEL MODULES & BOOT ===
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    "amdgpu.vm_update_mode=0"
    "pci=realloc"
    "pcie_aspm=off"
    "amdgpu.ppfeaturemask=0xffffffff"
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
      libva
      libva-utils
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  hardware.amdgpu.initrd.enable = true;

  # === 4. COMPUTE ENVIRONMENT ===
  environment.sessionVariables = {
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    AMD_LOG_LEVEL = "3";
  };

  # === 5. POWER MANAGEMENT ===
  # Nota: pp_od_clk_voltage non è disponibile via VFIO passthrough,
  # l'undervolt via sysfs non è possibile in questo setup.
  # Il power cap è limitato dal VBIOS a un range 305W–350W (default 339W).
  systemd.services.amdgpu-powercap = {
    description = "AMD GPU power cap (min VBIOS: 305W)";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      HWMON_PATH=/sys/class/drm/card0/device/hwmon/hwmon0

      # Aspetta che il device sia pronto
      for i in $(seq 1 10); do
        [ -f "$HWMON_PATH/power1_cap" ] && break
        sleep 1
      done

      if [ ! -f "$HWMON_PATH/power1_cap" ]; then
        echo "ERRORE: power1_cap non trovato dopo 10 secondi"
        exit 1
      fi

      MIN=$(cat $HWMON_PATH/power1_cap_min)
      MAX=$(cat $HWMON_PATH/power1_cap_max)
      TARGET=305000000  # 305W — minimo consentito dal VBIOS

      # Sanity check: non scrivere fuori range
      if [ "$TARGET" -lt "$MIN" ] || [ "$TARGET" -gt "$MAX" ]; then
        echo "ERRORE: target $TARGET fuori range [$MIN, $MAX]"
        exit 1
      fi

      echo $TARGET > $HWMON_PATH/power1_cap
      echo "Power cap impostato a $(( TARGET / 1000000 ))W (range: $(( MIN / 1000000 ))W – $(( MAX / 1000000 ))W)"
    '';
  };

  docker.enableAMD = true;
}