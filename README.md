# Configurazione NixOS Modulare

Questa è la configurazione NixOS ristrutturata per supportare multiple macchine con moduli condivisi.

## Installazione da Git

### Opzione 1: Installazione dal sistema live NixOS

1. **Preparare il sistema live**:
```bash
# Abilitare flakes temporaneamente
export NIX_CONFIG="experimental-features = nix-command flakes"

# Installare git se non presente
nix-shell -p git
```

2. **Clonare la configurazione**:
```bash
git clone https://github.com/TUO-USERNAME/dotfiles.git /mnt/etc/nixos
cd /mnt/etc/nixos/nix
```

3. **Generare hardware-configuration.nix**:
```bash
# Per Surface Pro (sasfifsos)
nixos-generate-config --root /mnt --dir /mnt/etc/nixos/nix/hosts/sasfifsos/
mv /mnt/etc/nixos/nix/hosts/sasfifsos/hardware-configuration.nix /mnt/etc/nixos/nix/hosts/sasfifsos/hardware.nix

# Per Desktop (powertop)
nixos-generate-config --root /mnt --dir /mnt/etc/nixos/nix/hosts/powertop/
mv /mnt/etc/nixos/nix/hosts/powertop/hardware-configuration.nix /mnt/etc/nixos/nix/hosts/powertop/hardware.nix
```

4. **Installare il sistema**:
```bash
# Per Surface Pro
nixos-install --flake /mnt/etc/nixos/nix#sasfifsos

# Per Desktop
nixos-install --flake /mnt/etc/nixos/nix#powertop
```

### Opzione 2: Su sistema NixOS esistente

1. **Clonare la configurazione**:
```bash
git clone https://github.com/TUO-USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles/nix
```

2. **Generare hardware.nix se necessario**:
```bash
sudo nixos-generate-config --dir ./hosts/HOSTNAME/
mv ./hosts/HOSTNAME/hardware-configuration.nix ./hosts/HOSTNAME/hardware.nix
```

3. **Applicare la configurazione**:
```bash
sudo nixos-rebuild switch --flake .#HOSTNAME
```

## Struttura

```
nix/
├── flake.nix                    # Entry point principale
├── hosts/                      # Configurazioni specifiche per host
│   ├── sasfifsos/              # Surface Pro
│   │   ├── default.nix         # Configurazione host
│   │   └── hardware.nix        # Hardware Surface Pro
│   └── powertop/               # Desktop fisso
│       ├── default.nix         # Configurazione host
│       └── hardware.nix        # Hardware desktop (template)
├── modules/                    # Moduli condivisi
│   ├── desktop/
│   │   └── gnome.nix          # Configurazione GNOME
│   ├── programs.nix           # Programmi di sistema
│   └── services.nix           # Servizi di sistema
└── home/                      # Configurazioni Home Manager
    └── stego/
        └── default.nix        # Configurazione utente
```

## Comandi Utili

### Build e Switch
```bash
# Surface Pro
sudo nixos-rebuild switch --flake .#sasfifsos

# Desktop
sudo nixos-rebuild switch --flake .#powertop
```

### Aggiornare il flake (sistema)
```bash
nix flake update
```

### Formattare i file Nix
```bash
nix fmt
```
