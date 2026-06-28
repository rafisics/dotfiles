# Only run in interactive shells
if status is-interactive
    # Remove <C-t> mapping used to close the terminal in NeoVim
    bind --erase \ct

    # Default editor
    set -gx EDITOR "nvim"

    # Zoxide (lazy-loaded via function)
    if type -q zoxide
        function __init_zoxide
            zoxide init fish --cmd cd | source
            functions -e __init_zoxide
        end
    end

    # Starship (background loaded)
    if not set -q __starship_initialized
        starship init fish | source &
        set -g __starship_initialized 1
    end

    # Bundler/Ruby
    if type -q bundle
        set -x GEM_HOME "$HOME/gems"
        fish_add_path --global "$GEM_HOME/bin"
    end
end

# NeoVim
source ~/.config/nvim.fish
