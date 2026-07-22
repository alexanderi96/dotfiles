{ config, pkgs, lib, ... }: {
  # Home Manager STANDALONE su thickpad (Fedora, non-NixOS).
  # Applicato con: home-manager switch --flake .#thickpad
  imports = [
    ./core.nix   # CLI, shell, git, opencode — tutto ciò che serve ovunque
  ];

  home.username = "stego";
  home.homeDirectory = "/home/stego";
  home.stateVersion = "25.05";

  # Compositor + terminale di thickpad: niri (+ dankshell) e kitty.
  # Solo i dotfile come symlink: i binari niri/kitty restano forniti da Fedora
  # per ora — nessun pacchetto qui = nessun duplicato con dnf.
  # Per promuoverli a nix in futuro: aggiungili a home.packages.
  xdg.configFile = {
    "niri"  = { source = ./dotfiles/config/niri;  recursive = true; };
    "kitty" = { source = ./dotfiles/config/kitty; recursive = true; };
  };
}
