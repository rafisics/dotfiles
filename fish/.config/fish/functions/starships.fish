function starships
    set config_dir "$HOME/.config/starship"
    set configs (ls $config_dir | grep -oE 'starship_[0-9]+' | sort -V)

    set selected (printf "%s\n" $configs | fzf --prompt="Starship Config » " --height=~50% --layout=reverse --border --exit-0)

    if [ -z "$selected" ]
        echo "Nothing selected"
        return 0
    end

    set target_config "$config_dir/$selected.toml"

    if test -f "$target_config"
        set -Ux STARSHIP_CONFIG "$target_config"
        echo "Switched Starship config to $selected"
        starship init fish | source  # Reload Starship
    else
        echo "Config '$selected' not found."
    end
end
