function dump_gnome_settings
    set dir ~/github/ubuntu-setup
    cd $dir
    
    # Dump full GNOME settings
    dconf dump /org/gnome/ > gnome/full-settings.dconf

    # Dump keybinding-related settings
    gsettings list-recursively | grep -i 'keybindings' > gnome/keybindings/full-settings.txt
    dconf dump /org/gnome/desktop/wm/keybindings/ > gnome/keybindings/wm.dconf
    dconf dump /org/gnome/terminal/legacy/keybindings/ > gnome/keybindings/terminal.dconf
    dconf dump /org/gnome/shell/keybindings/ > gnome/keybindings/shell.dconf
    dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > gnome/keybindings/media-keys.dconf

    # Dump GNOME extensions settings
    dconf dump /org/gnome/shell/extensions/ > gnome/gnome-extensions.dconf
end
