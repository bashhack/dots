# Tmux Setup

## Installation

1. Install tmux and tmuxp (tmux session manager) via Homebrew:
   ```shell
   brew install tmux tmuxp
   ```

2. Copy the tmux configuration file:
   ```shell
   rsync -avz <path_to_dots_repo>/.tmux.conf ~/
   ```

3. Install Tmux Plugin Manager (TPM):
   ```shell
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

4. Install plugins:
   - Start a tmux session:
     ```shell
     tmux
     ```
   - Once in tmux, press `Ctrl+a` followed by `I` (capital i) to install the plugins
   - Wait for the plugins to install (you'll see a message when complete)

## Plugins Used

The configuration includes the following plugins:
- **tpm**: Tmux Plugin Manager
- **vim-tmux-navigator**: Seamless navigation between tmux panes and vim splits
- **tmux-sensible**: Basic tmux settings everyone can agree on
- **tmux-gruvbox**: Gruvbox theme for tmux
- **tmux-resurrect**: Save and restore tmux sessions
- **tmux-continuum**: Automatic saving of tmux environment

## Key Bindings

- **Prefix**: `Ctrl+a` (changed from default `Ctrl+b`)
- **Reload config**: `Prefix + r`
- **Split window horizontally**: `Prefix + |`
- **Split window vertically**: `Prefix + -`
- **Resize panes**: `Prefix + h/j/k/l`
- **Maximize/restore pane**: `Prefix + m`
- **Copy mode**: `Prefix + [`, then use vi keys to navigate
  - `v` to start selection
  - `y` to toggle rectangle mode
  - `Enter` to copy and exit copy mode
- **Paste**: `Prefix + P`

## Working with Sessions

With tmuxp, you can define and restore complex session layouts:

1. Create a YAML configuration (e.g., `~/.config/tmuxp/project.yaml`)
2. Load it with:
   ```shell
   tmuxp load project
   ```

## Common Commands

- **Start new session**: `tmux new -s session_name`
- **Attach to existing session**: `tmux attach -t session_name`
- **List sessions**: `tmux ls`
- **Detach from session**: `Prefix + d`
- **Kill session**: `tmux kill-session -t session_name`

## Font Configuration

Tmux with the Gruvbox theme uses special symbols that require a Nerd Font to display correctly. Otherwise, you'll see boxes or question marks instead of icons.

1. Install a Nerd Font (JetBrains Mono Nerd Font recommended):
   ```shell
   # Option 1: Using Homebrew (recommended)
   brew install --cask font-jetbrains-mono-nerd-font
   
   # Option 2: Manual download
   # Download from https://www.nerdfonts.com/font-downloads and install to ~/Library/Fonts/
   ```

2. Configure your terminal to use the Nerd Font:
   - For Terminal.app:
     - Open Preferences (Cmd+,)
     - Go to the "Profiles" tab
     - Select your profile
     - Click on "Text"
     - Change the font to "JetBrainsMono Nerd Font Mono Regular"
     
   - For iTerm2:
     - Open Preferences (Cmd+,)
     - Go to "Profiles" → "Text"
     - Change font to "JetBrainsMono Nerd Font Mono"

## Troubleshooting

### Copy/Paste Issues

If you get errors related to xclip, modify line 46 in the .tmux.conf:

For macOS, replace:
```
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel 'xclip -se c -i'
```

With:
```
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel 'pbcopy'
```

This uses macOS's pbcopy instead of xclip, which is Linux-specific.

### Missing Icons in Status Bar

If you see boxes or question marks in your status bar:
1. Ensure you've installed a Nerd Font
2. Make sure your terminal is using the Nerd Font
3. Restart tmux completely with `tmux kill-server && tmux`