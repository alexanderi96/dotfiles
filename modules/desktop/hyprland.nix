{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Use ly as display manager
  services.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      bigclock = "%c";
      clockfmt = "%c";
    };
  };

  # Alternative: greetd with regreet
  # services.greetd = {
  #   enable = true;
  #   settings = rec {
  #     initial_session = {
  #       command = "${pkgs.hyprland}/bin/Hyprland";
  #       user = "stego";
  #     };
  #     default_session = initial_session;
  #   };
  # };

  # programs.regreet = {
  #   enable = true;
  #   cageArgs = [ "-s" "-m" "last" ];
  # };

  # Audio - PipeWire (required by your config)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Polkit agent (required by your autostart)
  security.polkit.enable = true;
  systemd.user.services.hyprpolkitagent = {
    description = "hyprpolkitagent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
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

  # Environment variables
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
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # Essential packages for your Hyprland config
  environment.systemPackages = with pkgs; [
    # Core Hyprland ecosystem
    hyprland
    hyprpaper
    hypridle
    hyprlock
    hyprsunset
    hyprpicker
    
    # Terminal & File Manager (from your config)
    kitty
    yazi  # Modern TUI file manager
    
    # Application launcher & logout
    walker
    # elephant  # Walker dependency for app indexing (not available in nixpkgs)
    wlogout
    
    # Status bar & notifications
    waybar
    swaynotificationcenter  # or mako if you prefer
    
    # Wallpaper management
    waypaper
    
    # Screenshot tools
    grim
    slurp
    swappy
    imagemagick  # Required by shot.sh script for blur effects
    
    # Clipboard & utilities
    wl-clipboard
    brightnessctl
    playerctl
    inotify-tools  # Required by waybar start script
    
    # System applets
    networkmanagerapplet  # nm-applet
    blueman               # blueman-applet
    
    # Cursors & themes
    bibata-cursors
    adwaita-icon-theme
    
    # Qt5 configuration
    libsForQt5.qt5ct
    
    # Power management
    tuned
  ];

  # Enable required services
  services.blueman.enable = true;
  services.tuned.enable = true;
  
  # Network manager
  networking.networkmanager.enable = true;
  
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Fonts (basic set)
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols
  ];
}
