{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    package = pkgs.greetd.tuigreet;
    settings = {
      default_session = {
        command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
        user = "stego"; # cambia col tuo username
      };
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

  # Environment variables for Wayland
  environment.sessionVariables = {
    # Wayland compatibility
    # WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    
    # Cursor configuration
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    
    # GTK/GDK
    GTK_THEME = "Adwaita-dark";
    GDK_BACKEND = "wayland,x11,*";
    
    # Qt
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    
    # Browser/Electron
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # Pacchetti
  environment.systemPackages = with pkgs; [

    # Hyprland ecosystem
    hyprland hyprpaper hypridle hyprlock hyprsunset hyprpicker

    # Terminal & file manager
    kitty yazi

    # App launcher & logout
    wofi wlogout

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
