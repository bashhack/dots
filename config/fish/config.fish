#!/usr/bin/env fish

# ========================================
# Fish Shell Configuration
# ========================================
# This is your main fish config file
# Fish equivalent of .zshrc
# ========================================

# +--------------+
# | ENVIRONMENT  |
# +--------------+

# Homebrew
set -x PATH /opt/homebrew/bin $PATH

# Pyenv
set -x PYENV_ROOT $HOME/.pyenv
if test -d $PYENV_ROOT/bin
    set -x PATH $PYENV_ROOT/bin $PATH
end
if command -v pyenv 1>/dev/null 2>&1
    pyenv init - | source
end

# FNM (Fast Node Manager)
if command -v fnm 1>/dev/null 2>&1
    fnm env --use-on-cd | source
end

# Rust
set -x PATH $HOME/.cargo/bin $PATH

# Doom Emacs
set -x PATH $HOME/.config/emacs/bin $PATH

# Go
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

# Go Private
set -x GOPRIVATE github.com/presencelearning/*

# OrbStack
if test -f ~/.orbstack/shell/init.fish
    source ~/.orbstack/shell/init.fish 2>/dev/null
end

# +----------+
# | SETTINGS |
# +----------+

# Fish already has great defaults for:
# - Syntax highlighting (built-in)
# - Autosuggestions (built-in)
# - Smart completions (built-in)

# Disable greeting
set -U fish_greeting ""

# +---------+
# | ALIASES |
# +---------+

# Source aliases from conf.d/aliases.fish

# +--------+
# | PROMPT |
# +--------+

# Fish has a built-in prompt
# You can customize it or install a framework like starship, tide, or pure
# For now, using fish's default which is quite nice

# +-----------+
# | FUNCTIONS |
# +-----------+

# Functions are auto-loaded from ~/.config/fish/functions/
# Each function should be in its own file: functionname.fish

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
