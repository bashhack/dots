function aliasfzf --description 'Interactively search aliases with fzf'
    alias | fzf --preview "echo {}" --preview-window=up:3:wrap --height 40%
end
