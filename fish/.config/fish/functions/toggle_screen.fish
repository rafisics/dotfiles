function toggle_screen
    set state_file /tmp/extended_screen

    if test -f $state_file
        echo "Resetting screen and killing x11vnc..."
        # Kill any running x11vnc processes
        if pgrep x11vnc > /dev/null
            pkill x11vnc
        end
        # Reset the screen to its default configuration
        xrandr --output eDP-1 --auto --panning 0x0
        rm $state_file
    else
        echo "Expanding screen and starting x11vnc..."
        # Expand the screen: first, set a large framebuffer and full panning
        xrandr --fb 2732x768 --output eDP-1 --panning 2732x768+0+0/2732x768+0+0
        sleep 3
        # Then limit the visible (tracking) area to the left half (laptop) so the right half is extended
        xrandr --fb 2732x768 --output eDP-1 --panning 1366x768+0+0/2732x768+0+0
        # Start x11vnc to share the extended (right half) area
        x11vnc -usepw -clip 1366x768+1366+0 -nocursorshape -nocursorpos -repeat &
        touch $state_file
    end
end
