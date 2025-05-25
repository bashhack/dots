#!/usr/bin/env zsh

# Brew will through warning without this present :/
export PATH="/opt/homebrew/bin:$PATH"

# Pyenv can't bother being compliant so now we have to do this nonsense, too :/
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# FNM
eval "$(fnm env --use-on-cd)"

fpath=($ZDOTDIR/plugins $fpath)

# +------------+
# | NAVIGATION |
# +------------+

setopt AUTO_CD              # Go to folder path without using cd.

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

source $ZDOTDIR/plugins/bd.zsh

# +---------+
# | HISTORY |
# +---------+

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# +---------+
# | ALIASES |
# +---------+

source $ZDOTDIR/aliases

# +---------+
# | SCRIPTS |
# +---------+

source $ZDOTDIR/scripts

# +--------+
# | PROMPT |
# +--------+
# https://github.com/sindresorhus/pure
# brew install pure
fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure

# +------------+
# | COMPLETION |
# +------------+

# Add brew-installed zsh-completions to fpath
fpath=(/opt/homebrew/share/zsh-completions $fpath)

source $ZDOTDIR/completion.zsh

# +-----+
# | FZF |
# +-----+

if [ $(command -v "fzf") ]; then
    source $ZDOTDIR/fzf.zsh
fi

# +---------------------+
# | SYNTAX HIGHLIGHTING |
# +---------------------+

# Use brew-installed zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# +----------+
# | OrbStack |
# +----------+

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 1>/dev/null || :
