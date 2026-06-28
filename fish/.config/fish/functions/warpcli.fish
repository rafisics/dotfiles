function warpcli
    set options "connect" "disconnect"
    set action (printf "%s\n" $options | fzf --prompt="Cloudflare WARP Client » " --height=~50% --layout=reverse --border --exit-0 --no-info)
    
    if [ -z $action ]
        echo "Nothing selected"
        return 0
    else if [ $action = "connect" ]
        warp-cli connect
    else if [ $action = "disconnect" ]
        warp-cli disconnect
    end
end

