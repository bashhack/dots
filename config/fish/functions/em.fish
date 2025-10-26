function em --description 'Start Emacs client (GUI)'
    emacsclient -s doom -c $argv 2>/dev/null
    or begin
        emacs --init-directory=~/.config/emacs --daemon=doom
        and emacsclient -s doom -c $argv
    end
end
