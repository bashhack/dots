# ZSH Setup

## Basic Philosophy
Don't keep more than is strictly necessary. Simple over complex. Fast and stable.

## File Load Order
Good to remember: .zshenv → .zprofile → .zshrc → .zlogin → .zlogout

## Installation

0. Requirements: `git`

1. The following steps assume the `dots` repo is cloned to machine and GitHub SSH setup/config has been completed, for more see: [Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh).

2. Copy file contents of the `.zprofile` file:
   ```shell
   cd $HOME
   cp <path_to_dots_repo>/.zprofile .
   ```

3. Copy file contents of the `dots/config/zsh` directory:
   ```shell
   cd $HOME
   mkdir -p .config/zsh
   cp -a <path_to_dots_repo>/config/zsh/* $HOME/.config/zsh
   ```

4. Add submodules for `zsh-completions` + `zsh-syntax-highlighting`
   ```shell
   cd <path_to_dots_repo>
   git add submodule git@github.com:zsh-users/zsh-completions.git plugins/zsh-completions
   git add submodule git@github.com:zsh-users/zsh-syntax-highlighting.git plugins/zsh-syntax-highlighting
   ```

5. Source the shell, confirming that (1) syntax highlighting (e.g., common commands should vary in color), (2) aliases (e.g., see `.config/zsh/aliases`) and (3) auto-completions (e.g., <TAB> + letter should generate auto-completion matches) are working
