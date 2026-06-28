# Command to upgrade Neovim stable version
function upgrade_nvim
    # Save the current directory
    set original_dir (pwd)

    # Path to the Neovim source directory
    set nvim_src_dir ~/neovim
    set nvim_repo "https://github.com/neovim/neovim"

    # Check if the Neovim source directory exists
    if not test -d $nvim_src_dir
        echo "Neovim source directory not found. Cloning from $nvim_repo..."
        git clone $nvim_repo $nvim_src_dir
        set clone_flag true
    else
        set clone_flag false
    end

    # Navigate to the Neovim source directory
    echo "Navigating to Neovim source directory..."
    cd $nvim_src_dir

    # Fetch the latest changes from the remote repository
    echo "Fetching latest changes from the Neovim repository..."
    git fetch origin

    # Checkout the stable branch
    echo "Checking out the stable branch..."
    git checkout stable

    # Pull the latest stable updates
    echo "Pulling latest stable updates..."
    git pull origin stable

    # Build Neovim
    echo "Building Neovim with CMAKE_BUILD_TYPE=RelWithDebInfo..."
    make CMAKE_BUILD_TYPE=RelWithDebInfo

    # Install the new build
    echo "Installing the new build of Neovim..."
    sudo make install

    # Return to the original directory
    cd $original_dir
    echo "Returned to the original directory: $original_dir"

    # Clean up if the directory was cloned by the script
    if test $clone_flag = true
        echo "Removing the Neovim source directory as it was cloned for this upgrade..."
        rm -rf $nvim_src_dir
    else
        echo "Neovim source directory retained for future use."
    end

    # Verify the new version
    echo "Neovim upgrade completed. Verifying version..."
    nvim --version
end

# Command to delete nvim local cache
function delete_nvim_local_cache
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim
end

# Neovim config switch - https://youtu.be/LkHjJlSgKZY - https://gist.github.com/elijahmanor/b279553c0132bfad7eae23e34ceb593b?permalink_comment_id=5312460#gistcomment-5312460

function nvim-tex
    env NVIM_APPNAME=nvim.bak nvim
end

function nvims
    set items NvChad NeoTeX
    set config (printf "%s\n" $items | fzf --prompt=" Neovim Config » " --height=~50% --layout=reverse --border --exit-0)
    if [ -z $config ]
        echo "Nothing selected"
        return 0
    else if [ $config = "NvChad" ]
        set config ""
    else if [ $config = "NeoTeX" ]
        set config "nvim.bak"
    end
    env NVIM_APPNAME=$config nvim $argv
end

bind \ca 'commandline -r "nvims"; commandline -f execute'
