function aliases --description 'Show all aliases nicely formatted'
    cat ~/.config/fish/conf.d/aliases.fish | command grep -E "^alias|^# \+|^function" | bat --style=plain --language=fish
end
