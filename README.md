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

### Opzione 3: Bootstrap script

Creare uno script di bootstrap per automatizzare il processo:

```bash
#!/usr/bin/env bash
# bootstrap.sh

set -e

HOSTNAME=${1:-sasfifsos}
REPO_URL="https://github.com/TUO-USERNAME/dotfiles.git"

echo "🚀 Bootstrapping NixOS configuration for $HOSTNAME"

# Clone repository
if [ ! -d "/etc/nixos" ]; then
    sudo mkdir -p /etc/nixos
fi

sudo git clone $REPO_URL /etc/nixos
cd /etc/nixos/nix

# Generate hardware configuration
echo "📋 Generating hardware configuration..."
sudo nixos-generate-config --dir ./hosts/$HOSTNAME/
sudo mv ./hosts/$HOSTNAME/hardware-configuration.nix ./hosts/$HOSTNAME/hardware.nix

# Apply configuration
echo "⚙️  Applying NixOS configuration..."
sudo nixos-rebuild switch --flake .#$HOSTNAME

echo "✅ Bootstrap complete!"
```

Uso:
```bash
curl -L https://raw.githubusercontent.com/TUO-USERNAME/dotfiles/main/bootstrap.sh | bash -s sasfifsos
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

## Host Configurati

### sasfifsos (Surface Pro)
- **Hardware**: Intel CPU, grafica integrata
- **Layout tastiera**: Italiano (it/it2)
- **Locale**: IT con fallback EN_GB
- **Moduli hardware**: Surface Pro specifici da nixos-hardware
- **Crittografia**: LUKS abilitata

### powertop (Desktop)
- **Hardware**: AMD Ryzen 5800X + NVIDIA GTX 1070Ti
- **Layout tastiera**: US (us/us)
- **Locale**: EN_US
- **VM**: Proxmox con ottimizzazioni guest
- **GPU**: Driver NVIDIA proprietari con supporto gaming

## Programmi Installati

### Sviluppo
- **VSCode** con estensioni Go, Rust, Git, Nix
- **Go** toolchain completo
- **Rust** (rustc, cargo, rustfmt, clippy, rust-analyzer)
- **Git** con configurazione globale
- **Direnv** per ambienti di sviluppo

### Produttività
- **Obsidian** per note
- **Firefox** browser

### Gaming
- **Steam** con supporto Proton e 32-bit

### Containerizzazione
- **Podman** con compatibilità Docker
- **Distrobox** per ambienti isolati

### Sistema
- **Tailscale** VPN
- **OpenSSH** server

## Comandi Utili

### Build e Switch
```bash
# Surface Pro
sudo nixos-rebuild switch --flake .#sasfifsos

# Desktop
sudo nixos-rebuild switch --flake .#powertop
```

### Test senza applicare
```bash
# Surface Pro
sudo nixos-rebuild test --flake .#sasfifsos

# Desktop  
sudo nixos-rebuild test --flake .#powertop
```

### Aggiornare il flake
```bash
nix flake update
```

### Formattare i file Nix
```bash
nix fmt
```

## Aggiungere un Nuovo Host

1. Creare directory in `hosts/nuovo-host/`
2. Creare `default.nix` con configurazione specifica
3. Creare `hardware.nix` (opzionale, generare con `nixos-generate-config`)
4. Aggiungere configurazione in `flake.nix`:

```nix
nixosConfigurations.nuovo-host = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/nuovo-host/default.nix
    # Altri moduli specifici...
    
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.stego = import ./home/stego/default.nix;
    }
  ];
};
```

## Modificare Configurazioni

### Aggiungere programmi di sistema
Modificare [`modules/programs.nix`](modules/programs.nix:1)

### Aggiungere servizi
Modificare [`modules/services.nix`](modules/services.nix:1)

### Modificare configurazione utente
Modificare [`home/stego/default.nix`](home/stego/default.nix:1)

### Configurazioni specifiche per host
Modificare i rispettivi file in `hosts/nome-host/default.nix`