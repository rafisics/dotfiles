function fastfetch
    if test -f "$HOME/.config/fastfetch/presets/$argv[1].jsonc"
        command fastfetch -c "$HOME/.config/fastfetch/presets/$argv[1].jsonc"
    else
        command fastfetch $argv
    end
end
