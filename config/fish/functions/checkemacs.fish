function checkemacs --description 'Check Emacs daemon status'
    echo "Checking Emacs daemon status..."
    if ps aux | grep -E "emacs.*daemon" | grep -v grep > /dev/null
        echo "✓ Daemon(s) running:"
        ps aux | grep -E "emacs.*daemon" | grep -v grep | awk '{print "  PID " $2 ": " $11 " " $12 " " $13}'
        echo ""
        echo "Try: ec (to open new frame)"
    else
        echo "✗ No daemon running"
        echo "Run: em (to start daemon and open frame)"
    end
end
