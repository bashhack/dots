# ZSH Setup

## Basic Philosophy
Don't keep more than is strictly necessary. Simple over complex. Fast and stable.

## File Load Order
Good to remember: .zshenv → .zprofile → .zshrc → .zlogin → .zlogout

## Installation

0. Requirements: `git`, `brew` (Homebrew)

1. The following steps assume the `dots` repo is cloned to machine and GitHub SSH setup/config has been completed, for more see: [Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh).

2. Install required packages with Homebrew:
   ```shell
   cd <path_to_dots_repo>
   brew bundle install
   ```
   This will install all tools including zsh-completions and zsh-syntax-highlighting.
   
   If you encounter any errors, you can also install just the ZSH-related packages directly:
   ```shell
   brew install zsh-completions zsh-syntax-highlighting
   ```

3. Copy dotfiles using rsync (more reliable than cp):
   ```shell
   # Copy .zprofile to home directory
   rsync -avz <path_to_dots_repo>/.zprofile $HOME/
   
   # Create .config/zsh directory if it doesn't exist
   mkdir -p $HOME/.config/zsh
   
   # Copy all zsh config files, including hidden files
   rsync -avz <path_to_dots_repo>/config/zsh/ $HOME/.config/zsh/
   ```

4. Fix permissions for completion directories to prevent "insecure directories" warnings:
   ```shell
   chmod 755 /opt/homebrew/share
   chmod 755 /opt/homebrew/share/zsh
   chmod 755 /opt/homebrew/share/zsh/site-functions
   chmod 755 /opt/homebrew/share/zsh/site-functions/_*
   ```

5. Source the shell, confirming that:
   - Syntax highlighting works (commands should vary in color)
   - Aliases are working (see `.config/zsh/aliases`) 
   - Auto-completions work (press TAB to generate auto-completion matches)

## Troubleshooting

If you get errors about "insecure directories", you may need to fix permissions with:

```shell
find /opt/homebrew/Cellar -name "zsh" -type d | xargs chmod -R 755
find /opt/homebrew/Cellar -name "site-functions" -type d | xargs chmod -R 755
```

For pyenv errors, make sure it's properly installed:

```shell
brew install pyenv
```