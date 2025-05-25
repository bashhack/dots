# Dotfiles

My personal configuration files for various tools and applications.

## Setup Guides

- [ZSH Setup](docs/zsh_setup.md)
- [Tmux Setup](docs/tmux_setup.md)
- [Doom Emacs Setup](docs/doom_emacs_setup.md)
- [IntelliJ IDEA Setup](docs/intellij_setup.md)
- [Theme Setup](docs/theme_setup.md)

## Quick Start

For a new machine setup:

1. Clone this repository:
   ```shell
   git clone https://github.com/bashhack/dots.git
   ```

2. Install Homebrew:
   ```shell
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Install packages:
   ```shell
   cd dots
   brew bundle install
   ```

4. Copy dotfiles to their respective locations:
   ```shell
   # Copy shell configuration
   rsync -avz .zprofile ~/
   mkdir -p ~/.config/zsh
   rsync -avz config/zsh/ ~/.config/zsh/
   
   # Copy editor configurations
   rsync -avz .ideavimrc ~/
   rsync -avz .tmux.conf ~/
   rsync -avz .gitconfig ~/
   
   # For Intellimacs (Spacemacs bindings for IntelliJ)
   git clone https://github.com/MarcoIeni/intellimacs ~/.intellimacs
   
   # For Tmux Plugin Manager
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   
   # Install Nerd Font for terminal icons (required for tmux)
   brew install --cask font-jetbrains-mono-nerd-font
   ```

5. Follow the detailed setup guides in the docs directory for specific tools.

## License

See [LICENSE](LICENSE) for details.