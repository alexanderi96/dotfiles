#!/usr/bin/env bash
# Bootstrap script for NixOS configuration
# Usage: curl -L https://raw.githubusercontent.com/TUO-USERNAME/dotfiles/main/scripts/bootstrap.sh | bash -s HOSTNAME

set -e

HOSTNAME=${1:-sasfifsos}
REPO_URL="https://github.com/alexanderi96/dotfiles.git"
CONFIG_DIR="/etc/nixos"

echo "🚀 Bootstrapping NixOS configuration for $HOSTNAME"

# Check if we're running as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo "❌ This script needs to be run as root or with sudo"
    exit 1
fi

# Enable flakes temporarily
export NIX_CONFIG="experimental-features = nix-command flakes"

# Install git if not present
if ! command -v git &> /dev/null; then
    echo "📦 Installing git..."
    nix-shell -p git --run "echo Git installed temporarily"
fi

# Backup existing configuration if it exists
if [ -d "$CONFIG_DIR" ] && [ "$(ls -A $CONFIG_DIR)" ]; then
    echo "💾 Backing up existing configuration..."
    mv "$CONFIG_DIR" "${CONFIG_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
fi

# Clone repository
echo "📥 Cloning configuration repository..."
git clone "$REPO_URL" "$CONFIG_DIR"
cd "$CONFIG_DIR"

# Check if hostname configuration exists
if [ ! -d "./hosts/$HOSTNAME" ]; then
    echo "❌ Configuration for hostname '$HOSTNAME' not found!"
    echo "Available configurations:"
    ls -1 ./hosts/
    exit 1
fi

# Generate hardware configuration
echo "📋 Generating hardware configuration..."
nixos-generate-config --dir "./hosts/$HOSTNAME/"

# Move and rename hardware configuration
if [ -f "./hosts/$HOSTNAME/hardware-configuration.nix" ]; then
    mv "./hosts/$HOSTNAME/hardware-configuration.nix" "./hosts/$HOSTNAME/hardware.nix"
    echo "✅ Hardware configuration generated and moved to hardware.nix"
fi

# Apply configuration
echo "⚙️  Applying NixOS configuration..."
nixos-rebuild switch --flake ".#$HOSTNAME"

echo "✅ Bootstrap complete!"
echo "🎉 Your NixOS system is now configured with the modular setup"
echo ""
echo "Next steps:"
echo "- Reboot your system"
echo "- Set user password: sudo passwd stego"
echo "- Configure git: git config --global user.name 'Your Name'"
echo "- Configure git: git config --global user.email 'your.email@example.com'"
echo ""
echo "📚 Documentation: $CONFIG_DIR/README.md"
echo "🔧 Configuration: $CONFIG_DIR/hosts/$HOSTNAME/"