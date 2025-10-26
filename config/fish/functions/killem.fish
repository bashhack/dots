function killem --description 'Force kill Emacs daemon (no prompts)'
    emacsclient -s doom -e "(kill-emacs)"
end
