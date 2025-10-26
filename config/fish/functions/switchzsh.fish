function switchzsh --description 'Switch default shell to zsh'
    set -l zsh_path (command -v zsh)

    if test -z "$zsh_path"
        echo "❌ zsh not found!"
        return 1
    end

    # Check if zsh is in /etc/shells (it should be, but just in case)
    if not grep -q "^$zsh_path\$" /etc/shells
        echo "⚠️  zsh is not in /etc/shells yet"
        echo "   Adding it now (requires sudo)..."
        echo ""
        echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null

        if test $status -ne 0
            echo "❌ Failed to add zsh to /etc/shells"
            return 1
        end
        echo "✅ Added zsh to /etc/shells"
        echo ""
    end

    echo "🔄 Switching default shell to zsh..."
    echo "   Path: $zsh_path"
    echo ""
    echo "⚠️  You may be prompted for your password"

    chsh -s $zsh_path

    if test $status -eq 0
        echo "✅ Default shell changed to zsh"
        echo "   Restart your terminal or open a new window to use zsh"
        echo ""
        echo "💡 To switch back to fish, run: switchfish"
    else
        echo "❌ Failed to change shell"
        return 1
    end
end
