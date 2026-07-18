{ config, pkgs, ... }:

{
  # 1. Abilitazione COSMIC (il modulo si occupa di quasi tutto)
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # 2. Printing & Audio (Mantieni i tuoi)
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # 3. Pacchetti di sistema
  # Ho corretto i nomi basandomi sui repository correnti.
  # 'cosmic-applets' contiene già la maggior parte degli indicatori (batteria, rete, ecc.)
  environment.systemPackages = with pkgs; [
    cosmic-screenshot
    cosmic-applets
    cosmic-term       # Terminale Rust
    cosmic-files      # File Manager Rust
  ];

  # Rimosso il blocco excludePackages che causava l'errore precedente
}