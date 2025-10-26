function aliasgrep --description 'Search for aliases by keyword' --argument search_term
    if test -z "$search_term"
        echo "Usage: aliasgrep <search-term>"
        return 1
    end
    cat ~/.config/fish/conf.d/aliases.fish | command grep -i "$search_term" -A 2 -B 1
end
