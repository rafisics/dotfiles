function load_gnome_settings
    set dir ~/github/ubuntu-setup
    cd $dir

    # Load keybinding-related settings
    dconf load /org/gnome/desktop/wm/keybindings/ < gnome/keybindings/wm.dconf
    dconf load /org/gnome/terminal/legacy/keybindings/ < gnome/keybindings/terminal.dconf
    dconf load /org/gnome/shell/keybindings/ < gnome/keybindings/shell.dconf
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome/keybindings/media-keys.dconf

    # Load GNOME extensions settings
    dconf load /org/gnome/shell/extensions/ < gnome/gnome-extensions.dconf
end
