# IntelliJ IDEA Setup

## Intellimacs (Spacemacs/Vim bindings for IntelliJ)

1. Clone the Intellimacs repository:
   ```shell
   git clone https://github.com/MarcoIeni/intellimacs ~/.intellimacs
   ```

2. Copy the .ideavimrc file to your home directory:
   ```shell
   rsync -avz <path_to_dots_repo>/.ideavimrc $HOME/
   ```

3. Install the IdeaVim plugin in IntelliJ IDEA:
   - Open IntelliJ IDEA
   - Go to Preferences/Settings
   - Select Plugins
   - Search for "IdeaVim" and install it
   - Restart IntelliJ when prompted

4. Verify that the setup works:
   - Open any file in IntelliJ
   - You should be able to use Vim key bindings
   - Try using Space as your leader key to verify Spacemacs-style commands

## Other IntelliJ Settings

### Recommended Plugins
- IdeaVim (required for Intellimacs)
- Material Theme UI (for better aesthetics)
- Rainbow Brackets
- String Manipulation
- Key Promoter X (learn keyboard shortcuts)

### Color Schemes
For a consistent look with other tools:
- Gruvbox Theme

### Editor Settings
- Font: JetBrains Mono or Fira Code (with ligatures)
- Line height: 1.2
- Enable font ligatures for better readability

### Key Settings
The following key bindings are included in the .ideavimrc:
- `jj` or `fd` in insert mode: Escape
- `Y`: Yank to end of line
- `,`: Alias for major mode commands (`<leader>m`)
- `<leader>gl`: Show Git log