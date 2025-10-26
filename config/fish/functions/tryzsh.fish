function tryzsh --description 'Try zsh in a tmux session (safe way to go back)'
    if not command -v zsh &>/dev/null
        echo "❌ zsh not found!"
        return 1
    end

    echo "🔄 Starting new tmux session with zsh..."
    tmux new-session -s zsh-trial zsh
end
