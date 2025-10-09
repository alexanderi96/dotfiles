{ config, pkgs, ... }:

{
  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Sessioni Wayland da rendere visibili ai DM
  services.xserver.displayManager.sessionPackages = [ pkgs.uwsm ];

  # Ly display manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      animate = true;
      bigclock = "%c";
      clockfmt = "%c";
      wayland_cmd = "Hyprland";
    };
  };

  # Audio - PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Polkit agent
  security.polkit.enable = true;
  systemd.user.services.hyprpolkitagent = {
    description = "hyprpolkitagent";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  # XDG Portal
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Env vars
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    GTK_THEME = "Adwaita-dark";
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # Pacchetti
  environment.systemPackages = with pkgs; [
    util-linux  # mcookie per ly

    # Hyprland ecosystem
    hyprland hyprpaper hypridle hyprlock hyprsunset hyprpicker

    # Terminal & file manager
    kitty yazi

    # App launcher & logout
    walker wlogout

    # Status bar & notifications
    waybar swaynotificationcenter

    # Wallpaper
    waypaper

    # Screenshot
    grim slurp swappy imagemagick

    # Clipboard & utils
    wl-clipboard brightnessctl playerctl inotify-tools

    # Applets
    networkmanagerapplet blueman

    # Themes & cursori
    bibata-cursors adwaita-icon-theme

    # Qt
    libsForQt5.qt5ct

    # Power mgmt
    tuned
  ];

  # Servizi
  services.blueman.enable = true;
  services.tuned.enable = true;
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts noto-fonts-emoji fira-code fira-code-symbols
  ];
}
