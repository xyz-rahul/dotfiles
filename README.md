# Chezmoi 

```
    New Machine
        │
        │ run
        ▼
    chezmoi init --apply git@xyz-rahul:xyz-rahul/dotfiles.git
        │
        │
        ├── Clone repository
        │       git@xyz-rahul:xyz-rahul/dotfiles.git
        │
        ▼
    ~/.local/share/chezmoi
        │
        │  (chezmoi source directory)
        │
        ├── dot_zshrc
        ├── dot_gitconfig.tmpl
        ├── dot_tmux.conf
        ├── dot_config/
        └── scripts
        │
        │
        ▼
    chezmoi apply
        │
        ▼
    $HOME directory
        │
        ├── ~/.zshrc
        ├── ~/.gitconfig
        ├── ~/.tmux.conf
        ├── ~/.config/
        └── other dotfiles
```


# Multiple Github Setup

```
MULTIPLE GITHUB ACCOUNTS (SSH)

Accounts
-------------------------------------------------
Work       -> ~/.ssh/id_ed25519
Personal   -> ~/.ssh/id_ed25519_personal
-------------------------------------------------


1. Generate Keys
-------------------------------------------------
ssh-keygen -t ed25519 -C "work-email"
save as:
~/.ssh/id_ed25519

ssh-keygen -t ed25519 -C "xyz-rahul"
save as:
~/.ssh/id_ed25519_personal
-------------------------------------------------


2. Add Keys to SSH Agent
-------------------------------------------------
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

IMPORTANT:
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_personal
-------------------------------------------------

Verify:
ssh-add -l



3. Add Public Keys to GitHub
-------------------------------------------------
cat ~/.ssh/id_ed25519.pub
→ add to Work GitHub account

cat ~/.ssh/id_ed25519_personal.pub
→ add to Personal GitHub account
-------------------------------------------------



4. SSH Config
-------------------------------------------------
~/.ssh/config

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes

Host xyz-rahul
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal
  IdentitiesOnly yes
-------------------------------------------------



5. Test SSH
-------------------------------------------------
ssh -T git@github.com
→ should authenticate Work account

ssh -T git@xyz-rahul
→ should authenticate Personal account
-------------------------------------------------



6. Repo URLs
-------------------------------------------------
Work repo:
git@github.com:WORK_USERNAME/repo.git

Personal repo:
git@xyz-rahul:xyz-rahul/repo.git
-------------------------------------------------



7. Why some repos need git@xyz-rahul
-------------------------------------------------
git@github.com:xyz-rahul/repo.git

SSH connects to github.com
→ first key used (work)
→ wrong account
→ permission denied


git@xyz-rahul:xyz-rahul/repo.git

SSH host = xyz-rahul
→ ssh config forces personal key
→ correct account used
-------------------------------------------------
```
