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

- common-lisp:
  * Install SBCL (already included in `Brewfile`)
    ```shell
    brew install sbcl
    ```
  * Install [Quicklisp](https://www.quicklisp.org/beta/)
    ```shell
    $ curl -o /tmp/ql.lisp http://beta.quicklisp.org/quicklisp.lisp
    $ sbcl --no-sysinit --no-userinit --load /tmp/ql.lisp \
        --eval '(quicklisp-quickstart:install :path "~/.quicklisp")' \
        --eval '(ql:add-to-init-file)' \
        --quit
    ```
  * Optional: Install SLIME - currently NOT using in favor of Sly
    ```shell
    $ sbcl --eval '(ql:quickload :quicklisp-slime-helper)' --quit
    ```

    Then edit `~/.config/doom/config.el`
    ```lisp
    (load (expand-file-name "~/.quicklisp/slime-helper.el"))
    (setq inferior-lisp-program "sbcl")
    ```

- cc:
  * Confirm presence of `clang --version` + `clangd` v9+ + `gcc` + `cmake`
  * Install `llvm` + `ccls` (already present in `Brewfile`)
  * Optional: If using `clangd` as primary over `ccls`
    ```lisp
    (after! lsp-clangd
    (setq lsp-clients-clangd-args
            '("-j=3"
            "--background-index"
            "--clang-tidy"
            "--completion-style=detailed"
            "--header-insertion=never"
            "--header-insertion-decorators=0"))
    (set-lsp-priority! 'clangd 2))
    ```
  * Optional: If using `ccls` as primary over `clangd`:
    ```lisp
    (after! ccls
        (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
        (set-lsp-priority! 'ccls 2)) ; optional as ccls is the default in Doom
    ```

- docker:
  * Optional: `dockfmt`:
    ```shell
    go get github.com/jessfraz/dockfmt
    ```

- magit/forge (see [Forge manual](https://magit.vc/manual/forge.html#Create-and-Store-an-Access-Token-1)):
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
    gopls (Go language server for LSP support)
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
    go install golang.org/x/tools/gopls@latest
    go install github.com/cweill/gotests/gotests@latest
    go install github.com/fatih/gomodifytags@latest
    ```
  * For golangci-lint (see [installation docs](https://golangci-lint.run/welcome/install/#local-installation)):
    ```shell
    # binary will be $(go env GOPATH)/bin/golangci-lint
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.1.6

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
