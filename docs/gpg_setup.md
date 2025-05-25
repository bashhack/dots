# GPG Setup for Git Commit Signing

## Initial Setup

1. Generate a GPG key (if you don't have one):
   ```bash
   gpg --full-generate-key
   ```

2. List your keys and get the key ID:
   ```bash
   gpg --list-secret-keys --keyid-format=long
   ```

3. Configure Git to use your key:
   ```bash
   git config --global user.signingkey YOUR_KEY_ID
   git config --global commit.gpgsign true
   ```

## macOS Configuration

1. Install pinentry-mac (included in Brewfile):
   ```bash
   brew install pinentry-mac
   ```

2. Configure GPG agent (`~/.gnupg/gpg-agent.conf`):
   ```
   pinentry-program /opt/homebrew/bin/pinentry-mac
   default-cache-ttl 28800
   max-cache-ttl 86400
   ```

3. Restart GPG agent:
   ```bash
   gpgconf --kill gpg-agent
   ```

## Troubleshooting

If you get "Inappropriate ioctl for device" errors:
- Make sure pinentry-mac is installed
- Check that gpg-agent.conf points to the correct pinentry
- Try signing something manually: `echo "test" | gpg --clearsign`

## Alternative: SSH Signing

For a simpler setup, consider using SSH signing instead:
```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
```