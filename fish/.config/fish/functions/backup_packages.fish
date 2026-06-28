function backup_packages
    set -l dir ~/github/ubuntu-setup/dpkg
    echo "📦 Backing up package selections to $dir"
    mkdir -p $dir

    # Save all dpkg selections (includes installed & deinstalled)
    echo "Saving all dpkg selections..."
    sudo dpkg --get-selections > $dir/all-packages.txt

    # Save installed packages, excluding deinstall packages
    echo "📄 Saving installed packages..."
    # dpkg-query -W -f='${Package}\n' | grep -v deinstall > $dir/installed-packages.txt
    sudo dpkg --get-selections | grep -w 'install' | awk '{print $1}' > $dir/installed-packages.txt

    # Save manually installed packages only (excluding auto-installed dependencies)
    echo "Saving manually installed packages..."
    bash -c "comm -23 \
        <(apt-mark showmanual | sort) \
        <(apt-mark showauto | sort)" > $dir/manual-packages.txt

    echo "✅ Package list backup complete."
end
