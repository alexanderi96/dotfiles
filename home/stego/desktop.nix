{ config, pkgs, ... }: {
  imports = [
    ./programs/vscode.nix   # installa già vscode: non rimetterlo in home.packages
    ./programs/vicinae.nix
  ];

  home.packages = with pkgs; [
    # Productivity & GUI
    firefox
    obsidian
    beeper

    # Communication
    discord
    telegram-desktop

    # Multimedia
    vlc
    gimp
  ];

  home.file."Pictures/Screenshots/.keep".text = "";
}
