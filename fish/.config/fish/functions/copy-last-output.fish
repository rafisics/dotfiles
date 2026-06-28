function copy-last-output
    if not set -l last_cmd (history --max=1 | string collect)
        echo "No command found in history."
        return 1
    end

    echo "⏳ Running: $last_cmd"
    
    set -l tmpfile (mktemp -p /tmp copy-output.XXXXXX)
    function __cleanup -S --on-process %self
        rm -f $tmpfile 2>/dev/null
    end

    echo "❯ $last_cmd" > $tmpfile
    if not eval "$last_cmd" 2>&1 | tee -a $tmpfile >/dev/tty
        echo "⚠️ Command failed (output still copied)"
    end

    if not xclip -selection clipboard < $tmpfile
        echo "❌ Failed to copy to clipboard! (Is xclip installed?)" >&2
        return 1
    end

    echo "✅ Copied command + output to clipboard"
end
