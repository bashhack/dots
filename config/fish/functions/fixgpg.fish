function fixgpg --description "Restart GPG agent"
    echo "🔧 Restarting GPG agent..."
    gpgconf --kill gpg-agent
    sleep 1
    gpg-agent --daemon >/dev/null 2>&1
    echo "✓ GPG agent restarted"
    echo "💡 If Emacs is still broken, run: restartem"
end
