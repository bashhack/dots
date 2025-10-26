function restartem --description 'Restart Emacs daemon cleanly'
    echo "Killing Emacs daemon..."
    emacsclient -s doom -e "(kill-emacs)" 2>/dev/null; or killall Emacs
    sleep 1
    echo "Starting fresh daemon..."
    emacs --init-directory=~/.config/emacs --daemon=doom
    echo "Done! Use 'ec' or 'em' to open a new frame"
end
