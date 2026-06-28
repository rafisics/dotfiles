function load-astro
    set -l astro_script ~/github/my-scripts/astro/astro.fish

    # Prevent double loading
    if set -q _astro_loaded
        echo "✅ Astrophysics environment already loaded at $_astro_loaded"
        return
    end

    if not test -f "$astro_script"
        echo "❌ Error: astro.fish not found at $astro_script" >&2
        return 1
    end

    source "$astro_script"

    # Store a human-readable timestamp
    set -g _astro_loaded (date "+%Y-%m-%d %H:%M:%S")
    echo "✅ Astrophysics environment loaded at $_astro_loaded"
end
