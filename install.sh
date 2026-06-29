#!/usr/bin/env bash
# Bootstrap dotfiles on a fresh machine.
# Run: bash install.sh
#
# Prerequisite: set up SSH key first:
#   ssh-keygen -t ed25519 && cat ~/.ssh/id_ed25519.pub  (add to GitHub)
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── External apt repos ──────────────────────────────────────────────────────
# All third-party repos added here so apt-get update picks them up in one pass

# FSearch
if ! command -v fsearch &>/dev/null; then
    echo "Adding FSearch PPA..."
    sudo add-apt-repository -y ppa:christian-boxdoerfer/fsearch-stable
fi

# Brave Browser
if ! command -v brave-browser &>/dev/null; then
    echo "Adding Brave Browser repo..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
        https://brave-browser-apt-release.s3.brave.com/ stable main" \
        | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
fi

# VSCodium
if ! command -v codium &>/dev/null; then
    echo "Adding VSCodium repo..."
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
        | gpg --dearmor \
        | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
        | sudo tee /etc/apt/sources.list.d/vscodium.list
fi

# ── Apt packages ────────────────────────────────────────────────────────────
# Includes build deps (cmake, gcc, make, gettext for Neovim) and
# runtime deps (fd-find, p7zip, imagemagick for Yazi) — must run before those.
echo ""
echo "Updating package lists..."
sudo apt-get update -qq

echo "Installing packages from system/dpkg/manual-packages.txt..."
PKGS=$(grep -v '^#\|^[[:space:]]*$' "$DOTFILES_DIR/system/dpkg/manual-packages.txt" | tr '\n' ' ')

# Try bulk install first; fall back to per-package to skip unavailable ones
# (packages needing unlisted repos — cloudflare-warp, google-chrome, dropbox, etc. — are skipped)
if ! sudo apt-get install -y $PKGS 2>/dev/null; then
    echo "  Retrying individually to skip unavailable packages..."
    while IFS= read -r pkg; do
        [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
        sudo apt-get install -y "$pkg" >/dev/null 2>&1 \
            || echo "  ⚠  skipped (repo not set up or unavailable): $pkg"
    done < "$DOTFILES_DIR/system/dpkg/manual-packages.txt"
fi

# ── Non-apt tools ───────────────────────────────────────────────────────────
# Neovim and Starship come after apt so cmake/gcc/curl are guaranteed available

if ! command -v nvim &>/dev/null; then
    echo ""
    echo "Installing Neovim (build from stable source)..."
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
if [ -n "$DBUS_SESSION_BUS_ADDRESS" ] && command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.background picture-uri \
        'file:///'"$HOME"'/.config/background'
    gsettings set org.gnome.desktop.background picture-uri-dark \
        'file:///'"$HOME"'/.config/background'
    echo "Wallpaper installed and applied."
else
    echo "Wallpaper files copied. Apply manually: gsettings set org.gnome.desktop.background picture-uri 'file://$HOME/.config/background'"
fi

# ── Yazi file manager ───────────────────────────────────────────────────────
# fd-find, imagemagick, 7zip installed via apt above — create expected binary names
if ! command -v yazi &>/dev/null; then
    echo ""
    echo "Installing Yazi..."
    wget -qO yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
    unzip -q yazi.zip -d yazi-temp
    sudo mv yazi-temp/*/yazi yazi-temp/*/ya /usr/local/bin/
    rm -rf yazi-temp yazi.zip
fi
# Symlinks for Ubuntu's differently-named binaries (idempotent)
[ ! -f /usr/local/bin/fd ]     && command -v fdfind  &>/dev/null && sudo ln -s "$(which fdfind)"  /usr/local/bin/fd
[ ! -f /usr/local/bin/magick ] && command -v convert &>/dev/null && sudo ln -s "$(which convert)" /usr/local/bin/magick
[ ! -f /usr/local/bin/7zz ]    && command -v 7z      &>/dev/null && sudo ln -s "$(which 7z)"      /usr/local/bin/7zz
# Catppuccin Mocha flavor is already tracked in dotfiles and stowed above

# ── LazyGit ─────────────────────────────────────────────────────────────────
if ! command -v lazygit &>/dev/null; then
    echo ""
    echo "Installing LazyGit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin
    rm /tmp/lazygit.tar.gz /tmp/lazygit
fi

# ── VSCodium extensions ─────────────────────────────────────────────────────
# Some ms-* / github.* extensions are Microsoft-marketplace-only and may not
# be available on Open VSX — those will print a warning and be skipped.
if command -v codium &>/dev/null; then
    echo ""
    echo "Installing VSCodium extensions..."
    CODIUM_EXTENSIONS=(
        adam-bender.commit-message-editor
        alefragnani.project-manager
        anthropic.claude-code
        asvetliakov.vscode-neovim
        ban.spellright
        codezombiech.gitignore
        donjayamanne.git-extension-pack
        donjayamanne.githistory
        eamodio.gitlens
        efoerster.texlab
        felipecaputo.git-project-manager
        formulahendry.code-runner
        github.vscode-pull-request-github
        james-yu.latex-workshop
        jdinhlife.gruvbox
        magicstack.magicpython
        mblode.zotero
        mhutchie.git-graph
        mjpvs.latex-previewer
        ms-python.debugpy
        ms-python.isort
        ms-python.python
        ms-python.vscode-python-envs
        ms-toolsai.jupyter
        ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-vscode.cpptools-themes
        ms-vscode.makefile-tools
        naumovs.color-highlight
        nd2204.gruvbox-material-mix
        patbenatar.advanced-new-file
        piotrpalarz.vscode-gitignore-generator
        redhat.vscode-yaml
        rickaym.manim-sideview
        ritwickdey.liveserver
        ryuta46.multi-command
        streetsidesoftware.code-spell-checker
        tecosaur.latex-utilities
        wesbos.theme-cobalt2
        zokugun.cron-tasks
        zokugun.sync-settings
    )
    for ext in "${CODIUM_EXTENSIONS[@]}"; do
        codium --install-extension "$ext" --force 2>/dev/null \
            || echo "  ⚠  skipped (not on Open VSX): $ext"
    done
fi

# ── my-scripts ──────────────────────────────────────────────────────────────
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
echo "  - Install GNOME exts:  use Extension Manager app (install BEFORE running dconf restore)"
echo "  - Restore GNOME theme: dconf load / < system/gnome/full-settings.dconf  (see system/THEME.md)"
echo "  - Restore GNOME keys:  see system/KEYBOARD-SHORTCUTS.md (or: load_gnome_settings in fish)"
echo "  - Install fonts:       see system/THEME.md (RobotoMono NF and others not in apt)"
echo "  - Install giph:        https://github.com/phw/giph (gif recorder, shell script)"
echo "  - Install Zotero:      download tarball → sudo mv ~/Downloads/Zotero_linux-x86_64/* /opt/zotero/"
echo "                         sudo /opt/zotero/set_launcher_icon"
echo "                         ln -s /opt/zotero/zotero.desktop ~/.local/share/applications/zotero.desktop"
echo "  - Manual installs:     cloudflare-warp, google-chrome, dropbox, zoom, deskreen, rustdesk"
echo "                         (these need separate repos/downloads — see their official sites)"
echo "  - Set up Python venvs: python3 -m venv ~/.venvs/nvim-env && python3 -m venv ~/.venvs/coding-env"
echo "  - Set fish as shell:   chsh -s \$(which fish)"
echo "  - Launch nvim once:    nvim  (lazy.nvim auto-installs all plugins on first run)"
