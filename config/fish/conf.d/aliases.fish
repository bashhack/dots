# ========================================
# Fish Aliases
# ========================================
# This file auto-loads when fish starts
# Converted from your zsh aliases
# ========================================

# +--------+
# | System |
# +--------+

alias restart='sudo shutdown -r now'
alias shutdown='sudo shutdown -h now'
alias sleep='sudo shutdown -s now'
alias c='clear'
alias h='history'

# +------------+
# | Navigation |
# +------------+

alias ..='cd .. && ll'
alias ...='cd ../.. && ll'

# +----+
# | ls |
# +----+

alias ls='eza --color=auto'
alias l='ls -l'
alias ll='ls -lahF'
alias lt='ls -lahFT'

# +-----+
# | top |
# +-----+

alias top='htop'

# +-----+
# | cat |
# +-----+

alias cat='bat'

# +------+
# | wget |
# +------+

alias wget='wget --hsts-file="$HOME/.wget-hsts" -c'

# +----+
# | cp |
# +----+

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# +------+
# | grep |
# +------+

alias grep='grep -P -i --color=auto'

# +------+
# | ping |
# +------+

alias pg='ping 8.8.8.8'

# +------+
# | brew |
# +------+

alias brwi='brew install'
alias brwci='brew install --cask'
alias brwd='brew doctor'
alias brwu='brew update && brew upgrade && brew cleanup'
alias brwr='brew autoremove'
alias brwf='cat Brewfile.* | brew bundle --file=-'

# +--------+
# | Golang |
# +--------+

alias gob='go build'
alias gor='go run'
alias goc='go clean -i'
alias gta='go test ./...'
alias gia='go install ./...'
alias gmt='go mod tidy'

# +------+
# | Hugo |
# +------+

alias hugostart='hugo server -DEF --ignoreCache'

# +-------+
# | Emacs |
# +-------+

alias vim='nvim'
alias vi='nvim'
alias killem="emacsclient -s doom -e '(save-buffers-kill-emacs)'"

# +-----+
# | Git |
# +-----+

alias gs='git status'
alias gss='git status -s'
alias ga='git add'
alias gp='git push'
alias gpraise='git blame'
alias gpo='git push origin'
alias gpof='git push origin --force-with-lease'
alias gpofn='git push origin --force-with-lease --no-verify'
alias gpt='git push --tag'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias grb='git branch -r'
alias gplo='git pull origin'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout'
alias gl='git log --pretty=oneline'
alias gr='git remote'
alias grs='git remote show'
alias glol='git log --graph --abbrev-commit --oneline --decorate'
alias gsub='git submodule update --remote'
alias dif='git diff --no-index'

# +------+
# | tmux |
# +------+

alias tmuxk='tmux kill-session -t'
alias tmuxa='tmux attach -t'
alias tmuxl='tmux list-sessions'

# +-------+
# | tmuxp |
# +-------+

alias mux='tmuxp load'

# +--------+
# | docker |
# +--------+

alias dockls="docker container ls | awk 'NR > 1 {print \$NF}'"
alias dockstats='docker stats (docker ps -q)'
alias dockimg='docker images'
alias dockprune='docker system prune -a --volumes'
alias dockup='docker compose up -d'
alias dockdown='docker compose down'
alias dockstop='docker compose stop'
alias docker-cleanup='docker buildx prune -af && docker image prune -af && echo "Docker cleaned!"'  # clean build cache and dangling images

# +----------+
# | Personal |
# +----------+

alias work="cd $HOME/Development/Work"
alias personal="cd $HOME/Development/Personal"
alias doc="cd $HOME/Documents"
alias dow="cd $HOME/Downloads"

# +--------+
# | Custom |
# +--------+

alias osx_netstat='sudo lsof -i -P'

# +----------+
# | Presence |
# +----------+

# Nebula aliases
set -l NEBULA_DIR "/Users/bashhack/Development/Work/presencelearning/nebula"
set -l NEBULA_PYTHON "$NEBULA_DIR/venv/bin/python"
set -l NEBULA_CMD "$NEBULA_PYTHON $NEBULA_DIR/nebula.py"

alias nb="$NEBULA_CMD"
alias nbl="$NEBULA_CMD list"
alias nbs="$NEBULA_CMD start"
alias nbr="$NEBULA_CMD restart"
alias nbd="$NEBULA_CMD stop"
alias nblogs="$NEBULA_CMD logs"
alias nball="$NEBULA_CMD start all"
alias nba="$NEBULA_CMD start auth"
alias nbant="$NEBULA_CMD start antares"
