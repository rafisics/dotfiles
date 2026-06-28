#!/usr/bin/env bash
# Bootstrap dotfiles on a fresh machine.
# Run: bash install.sh
#
# Prerequisites (do these before running):
#   1. Set up SSH key: ssh-keygen -t ed25519 && cat ~/.ssh/id_ed25519.pub (add to GitHub)
#   2. Install apt packages: sudo apt install $(cat system/dpkg/manual-packages.txt | tr '\n' ' ')
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Dependencies ────────────────────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
    echo "Installing GNU Stow..."
    sudo apt install -y stow
fi

# FSearch — not in standard Ubuntu repos, needs PPA
if ! command -v fsearch &>/dev/null; then
    echo "Adding FSearch PPA..."
    sudo add-apt-repository -y ppa:christian-boxdoerfer/fsearch-stable
    sudo apt update -qq
    sudo apt install -y fsearch
fi

# Brave Browser — needs GPG key + apt source
if ! command -v brave-browser &>/dev/null; then
    echo "Adding Brave Browser repo..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
        https://brave-browser-apt-release.s3.brave.com/ stable main" \
        | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update -qq
    sudo apt install -y brave-browser
fi

if ! command -v nvim &>/dev/null; then
    echo "Installing Neovim (build from stable source)..."
    # Requires: cmake gcc g++ make gettext (install apt packages first)
    git clone https://github.com/neovim/neovim ~/neovim
    cd ~/neovim && git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd "$DOTFILES_DIR"
    # For future upgrades, use the fish function: upgrade_nvim
fi

if ! command -v starship &>/dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# ── Stow all packages ───────────────────────────────────────────────────────
cd "$DOTFILES_DIR"

# Core packages — stowed on all machines
PACKAGES=(
    bash
    git
    nvim
    nvim-tex
    fish
    starship
    kitty
    rofi
    zathura
    yazi
    btop
    fastfetch
    screenkey
    mimeapps
    flameshot
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

# ── Yazi file manager ───────────────────────────────────────────────────────
if ! command -v yazi &>/dev/null; then
    echo "Installing Yazi..."
    wget -qO yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
    unzip -q yazi.zip -d yazi-temp
    sudo mv yazi-temp/*/yazi yazi-temp/*/ya /usr/local/bin/
    rm -rf yazi-temp yazi.zip
    # Required symlinks for yazi dependencies (Ubuntu uses different binary names)
    [ ! -f /usr/local/bin/fd ]    && sudo ln -s "$(which fdfind)" /usr/local/bin/fd
    [ ! -f /usr/local/bin/magick ] && sudo ln -s "$(which convert)" /usr/local/bin/magick
    [ ! -f /usr/local/bin/7zz ]   && sudo ln -s "$(which 7z)" /usr/local/bin/7zz
    # Catppuccin Mocha theme
    ya pack -a yazi-rs/flavors:catppuccin-mocha
fi

# ── LazyGit ─────────────────────────────────────────────────────────────────
if ! command -v lazygit &>/dev/null; then
    echo "Installing LazyGit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin
    rm /tmp/lazygit.tar.gz /tmp/lazygit
fi

# ── my-scripts ─────────────────────────────────────────────────────────────
if [ ! -d "$HOME/github/my-scripts" ]; then
    echo ""
    echo "Cloning my-scripts..."
    mkdir -p "$HOME/github"
    git clone git@github.com:rafisics/my-scripts.git "$HOME/github/my-scripts"
fi

# ── Private git identity ────────────────────────────────────────────────────
if [ ! -f "$HOME/.gitconfig-private" ]; then
    echo ""
    echo "⚠  ~/.gitconfig-private not found."
    echo "   Copy git/.gitconfig-private.example → git/.gitconfig-private"
    echo "   and fill in your GitHub no-reply email, then re-run: stow git"
fi

echo ""
echo "✓ Dotfiles installed. Next steps:"
echo "  - Install packages:    sudo apt install \$(cat system/dpkg/manual-packages.txt | tr '\n' ' ')"
echo "  - Install GNOME exts:  use Extension Manager app (install BEFORE running dconf restore)"
echo "  - Restore GNOME theme: dconf load / < system/gnome/full-settings.dconf  (see system/THEME.md)"
echo "  - Restore GNOME keys:  see system/KEYBOARD-SHORTCUTS.md (or: load_gnome_settings in fish)"
echo "  - Install fonts:       see system/THEME.md (RobotoMono NF and others not in apt)"
echo "  - Install giph:        https://github.com/phw/giph (gif recorder, shell script)"
echo "  - Install Zotero:      download tarball → sudo mv ~/Downloads/Zotero_linux-x86_64/* /opt/zotero/"
echo "                         sudo /opt/zotero/set_launcher_icon"
echo "                         ln -s /opt/zotero/zotero.desktop ~/.local/share/applications/zotero.desktop"
echo "  - FSearch PPA:         sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-stable && sudo apt install fsearch"
echo "  - Set up Python venvs: python3 -m venv ~/.venvs/nvim-env  (for Neovim Mason LSP)"
echo "  - Set fish as shell:   chsh -s \$(which fish)"
echo "  - Launch nvim once:    nvim  (lazy.nvim auto-installs all plugins on first run)"
