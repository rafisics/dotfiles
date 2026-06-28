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

# ── Wallpaper — copied, not symlinked (GNOME doesn't follow symlinks) ────────
echo ""
echo "Installing wallpaper..."
mkdir -p "$HOME/.local/share/backgrounds"
cp "$DOTFILES_DIR/wallpaper/.config/background" "$HOME/.config/background"
cp "$DOTFILES_DIR/wallpaper/.local/share/backgrounds/2025-01-05-05-20-03-sajek-2024.jpg" \
   "$HOME/.local/share/backgrounds/2025-01-05-05-20-03-sajek-2024.jpg"
cp "$DOTFILES_DIR/wallpaper/.local/share/backgrounds/sajek-2024-original.jpg" \
   "$HOME/.local/share/backgrounds/sajek-2024-original.jpg"
gsettings set org.gnome.desktop.background picture-uri \
    'file:///'"$HOME"'/.config/background'
gsettings set org.gnome.desktop.background picture-uri-dark \
    'file:///'"$HOME"'/.config/background'
echo "Wallpaper installed."

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
echo "  - Restore GNOME theme: see system/THEME.md"
echo "  - Set up Python venvs: ~/.venvs/coding-env  and  ~/.venvs/nvim-env"
echo "  - Set fish as shell:   chsh -s \$(which fish)"
