# Doom Emacs Setup

[Doom Emacs - Github Link](https://github.com/doomemacs/doomemacs)

## Installation

```shell
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
```

### Core Requirements
* `emacs` 29.1+ (see: `dots/Brewfile` for personal, preferred `emacs-plus` installation)
* `git` 2.23+
* `ripgrep` 11.0+_
* GNU `find`
* `fd` 7.3.0+
* Add `~/.config/emacs/bin` to `PATH`

These can be installed via:

```shell
# required dependencies
brew install git ripgrep

# optional dependencies
brew install coreutils fd

# Installs clang
xcode-select --install
```

## Package Requirements

- vertico: 
  * Installation of PCRE-enabled lookahead:
    ```shell
    brew uninstall ripgrep
    brew install rust
    cargo install --features pcre2 ripgrep
    ```
    
    ```shell
    brew install grep
    ```
 
    Then, in `.zshrc`:
    ```shell
    if [ -d "$(brew --prefix)/opt/grep/libexec/gnubin" ]; then
        PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
    fi 
    ```

- docker:
  * Optional: `dockfmt`:
    ```shell
    go get github.com/jessfraz/dockfmt
    ```

- magit/forge:
  * Add Forge username to your `~/.gitconfig` for your operating system account
    ```shell
    git config --global github.user <github_username>
    ```
  * Generate GitHub personal access [token](https://github.com/settings/tokens)
  * [ ] Create `.authinfo` file entries:
    ```text
    machine api.github.com login yourlogin^code-review password TOKEN
    machine api.github.com login yourlogin^forge password TOKEN
    ```
  * Call `epa-encrypt-file` from Emacs to encrypt `.authinfo` and delete `~/.authinfo` or encrypt/decrypt from CLI using:
    ```shell
    # encrypt
    gpg --output ~/.authinfo.gpg --encrypt --recipient email-name@domain.tld ~/.authinfo
    
    # decrypt
    gpg --output ~/.authinfo --decrypt ~/.authinfo.gpg
    ```

- go:
  * Dependencies:
    gocode (for code completion & eldoc support)
    godoc (for documentation lookup)
    gorename (for extra refactoring commands)
    gore (for the REPL)
    guru (for code navigation & refactoring commands)
    goimports (optional: for auto-formatting code on save & fixing imports)
    gotests (for generate test code)
    gomodifytags (for manipulating tags)
  * These can be installed via:
    ```shell
    go install github.com/x-motemen/gore/cmd/gore@latest
    go install github.com/stamblerre/gocode@latest
    go install golang.org/x/tools/cmd/godoc@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install golang.org/x/tools/cmd/gorename@latest
    go install golang.org/x/tools/cmd/guru@latest
    go install github.com/cweill/gotests/gotests@latest
    go install github.com/fatih/gomodifytags@latest
    ```
  * For golangci-lint:
    ```shell
    # binary will be $(go env GOPATH)/bin/golangci-lint
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.55.2

    golangci-lint --version
    ```

- javascript:
  * `NodeJS` must be in your `$PATH`
  
- org:
  * Depending on config, will generally need:
    ```shell
    brew install pandoc
    brew install pngpaste
    brew install sqlite3
    ```

- python:
  * Loosely dependent on:
    pytest/nose
    black
    pyflakes
    isort
    pyenv
    poetry
    pipenv
  * For LSP support: 
    `npm i -g pyright` or `pip install python-language-server[all]` or `M-x lsp-install-server RET mspyls`

- rest:
  * Requires `jq` utility:
    ```shell
    brew install jq
    ```

- sh:
  * Optional install of `shfmt`, see [here](https://github.com/patrickvane/shfmt) for more info
  * Optional install of `shellcheck`:
    ```shell
    brew install shellcheck
    ```
  * Optional install of `bash-language-server`:
    ```shell
    npm i -g bash-language-server
    ```
