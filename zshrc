[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - )"

# Poetry
export PATH="$HOME/.local/bin:$PATH"

# For auto-completion...
fpath+=~/.zfunc
autoload -Uz compinit && compinit

# For Doom Emacs
export PATH="$HOME/.config/emacs/bin:$PATH"

# Golang
export GOPATH=$(go env GOPATH)
export PATH=$PATH:$(go env GOPATH)/bin

source ~/.zsh_aliases

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
