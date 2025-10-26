function emt --description 'Start Emacs client (terminal)'
    emacsclient -s doom -t $argv 2>/dev/null
    or begin
        emacs --init-directory=~/.config/emacs --daemon=doom
        and emacsclient -s doom -t $argv
    end
end
