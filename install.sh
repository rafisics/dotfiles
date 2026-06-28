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

# Core packages — stowed on all machines
PACKAGES=(
    bash
    git
    nvim
    nvim-bak
    fish
    starship
    kitty
    rofi
    zathura
    yazi
    btop
)

# WM packages — only stow on i3 machines, skip on GNOME
# Uncomment to stow: stow i3 polybar picom
WM_PACKAGES=(i3 polybar picom)

for pkg in "${PACKAGES[@]}"; do
    echo "Stowing $pkg..."
    stow -v --target="$HOME" "$pkg"
done

echo ""
echo "Note: i3/polybar/picom are NOT stowed by default (GNOME machine)."
echo "      To enable: stow -d $DOTFILES_DIR -t \$HOME i3 polybar picom"

# ── Private git identity ────────────────────────────────────────────────────
if [ ! -f "$HOME/.gitconfig-private" ]; then
    echo ""
    echo "⚠  ~/.gitconfig-private not found."
    echo "   Copy git/.gitconfig-private.example → git/.gitconfig-private"
    echo "   and fill in your GitHub no-reply email, then re-run: stow git"
fi

echo ""
echo "✓ Dotfiles installed. Next steps:"
echo "  - Install packages:    see system/dpkg/manual-packages.txt"
echo "  - Restore GNOME keys:  see system/KEYBOARD-SHORTCUTS.md"
echo "  - Restore GNOME theme: dconf load /org/gnome/ < system/gnome/full-settings.dconf"
echo "  - Set up Python venvs: ~/.venvs/coding-env  and  ~/.venvs/nvim-env"
echo "  - Set fish as shell:   chsh -s \$(which fish)"
