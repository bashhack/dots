#!/usr/bin/env zsh

# +------------------------------------------------------------------------+
# | INFO: https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2 |
# +------------------------------------------------------------------------+

#
# editor
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR opens in terminal
export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI mode


# zsh
export ZDOTDIR="$HOME/.config/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"  # History filepath
export HISTSIZE=10000                 # Max events for internal history
export SAVEHIST=10000                 # Max events in history file

# Go
export GOPATH=$(go env GOPATH)

# Python
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# FNM
eval "$(fnm env --use-on-cd)"

# PATH
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"      # Go
export PATH="$HOME/.config/emacs/bin:$PATH"   # Doom Emacs

if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"  # fzf
fi

if [ -d "$(brew --prefix)/opt/grep/libexec/gnubin" ]; then
  PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"  # GREP w/PCRE
fi

export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"  # JetBrains Toolbox App
