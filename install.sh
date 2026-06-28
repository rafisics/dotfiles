#!/usr/bin/env bash
# Bootstrap dotfiles on a fresh machine.
# Run: bash install.sh
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Dependencies ────────────────────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
    echo "Installing GNU Stow..."
    sudo apt install -y stow
fi

# ── Stow all packages ───────────────────────────────────────────────────────
cd "$DOTFILES_DIR"

PACKAGES=(
    bash
    git
    nvim
    fish
    starship
    kitty
    i3
    polybar
    rofi
    picom
    zathura
    yazi
    btop
)

for pkg in "${PACKAGES[@]}"; do
    echo "Stowing $pkg..."
    stow -v --target="$HOME" "$pkg"
done

# ── Private git identity ────────────────────────────────────────────────────
if [ ! -f "$HOME/.gitconfig-private" ]; then
    echo ""
    echo "⚠  ~/.gitconfig-private not found."
    echo "   Copy git/.gitconfig-private.example → git/.gitconfig-private"
    echo "   and fill in your GitHub no-reply email, then re-run: stow git"
fi

echo ""
echo "✓ Dotfiles installed. Read SETUP.md for manual steps:"
echo "  - Install packages (see system/dpkg/manual-packages.txt)"
echo "  - Restore GNOME settings (see system/gnome/)"
echo "  - Set up Python venvs (~/.venvs/coding-env, ~/.venvs/nvim-env)"
echo "  - Install fish as default shell: chsh -s \$(which fish)"
