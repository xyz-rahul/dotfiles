# Git Cheat Sheet

## Initialization and Cloning
```bash
git clone <url>                 # Clone a repository
git clone <url> <new-name>      # Clone with a new name

# Example:
git clone https://github.com/libgit2/libgit2 mylibgit
```

## Configuration
- **.gitconfig Locations:**
  - System: `/usr/local/git/etc/gitconfig`
  - Global: `$HOME/.gitconfig`
  - Local: `.git/config`
```bash
      ----------------------------------------------
      |  system /usr/local/git/etc/gitconfig       |
      |   --------------------------------------   |
      |   |  global $home/.gitconfig           |   |
      |   | ---------------------------------- |   |
      |   | |                                | |   | 
      |   | |  local .git/config             | |   |
      |   | |                                | |   |
      |   | ---------------------------------- |   |
      |   --------------------------------------   |
      ----------------------------------------------

```


```bash
git config --list                # List all configs
git config --list --local         # List local configs
git config --local edit           # Edit local config
git config --global edit          # Edit global config
```

## Multiple GitHub Accounts (personal + work)

Three independent layers — they solve different problems:

| Layer | Controls | Mechanism |
|-------|----------|-----------|
| Commit identity | `name` / `email` on commits | conditional `includeIf` |
| Push/clone auth | which GitHub account you act as | SSH host aliases + keys |
| `gh` CLI | `gh pr`, `gh repo`, etc. | `gh auth switch` |

### 1. Commit identity — conditional include (auto by directory)
Identity is split into per-profile files and chosen by repo location:
```ini
# ~/.gitconfig
[include]
    path = ~/.gitconfig-personal          ; default everywhere

[includeIf "gitdir:~/workspace/cashify/"] ; trailing / = recursive
    path = ~/.gitconfig-work              ; overrides inside work dir
```
```ini
# ~/.gitconfig-personal
[user]
    name  = Rahul Kumar
    email = xyz.rahulkumar2002@gmail.com

# ~/.gitconfig-work
[user]
    name  = Rahul Kumar
    email = rahul.kumar2@cashify.in
```
Verify the active identity / connection:
```bash
# In any repository
git config user.name
git config user.email

# Test SSH connection
ssh -T git@github.com-personal
ssh -T git@github.com-work
```

### 2. Push/clone auth — one SSH key per account
```bash
ssh-keygen -t ed25519 -C "personal" -f ~/.ssh/id_ed25519_p   # personal
ssh-keygen -t ed25519 -C "work"     -f ~/.ssh/id_ed25519     # work
# add each .pub to the matching GitHub account: Settings > SSH keys
```
```ini
# ~/.ssh/config — alias per account (both point at github.com)
Host xyz-rahul
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_p

Host rahul-kumar-cashify
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
```
Use the alias in the remote so the right key is picked:
```bash
git clone git@rahul-kumar-cashify:reglobe/repo.git     # work
git clone git@xyz-rahul:xyz-rahul/repo.git             # personal
git remote set-url origin git@xyz-rahul:xyz-rahul/repo.git   # fix an existing remote
```
Test which account a key authenticates as:
```bash
ssh -T git@xyz-rahul                 # > Hi xyz-rahul!
ssh -T git@rahul-kumar-cashify       # > Hi rahul-kumar-cashify!
```
> Note: a plain `git@github.com:` remote ignores these aliases and falls back
> to the default key. Use the alias host for per-account auth to actually work.

### 3. gh CLI — multiple accounts
```bash
# Add multiple accounts
gh auth login --hostname github-work
gh auth login --hostname github-personal

# Switch between accounts
gh auth switch

# Check current account
gh auth status
```

**Reference:** [One Machine, Many Identities — switch between multiple Git profiles](https://medium.com/@leroyleowdev/one-machine-many-identities-adding-effortlessly-switch-between-multiple-git-profiles-fd56a20bc181)

## Status and Tracking
```bash
git status                       # Show the working tree status
```
- **Status Codes:**
  - `??` untracked files
  - `M` modified files
  - `A` new files added in staging area

## Ignoring Files
### .gitignore Examples
```gitignore
*.a                             # Ignore all .a files
!lib.a                          # Track lib.a
/TODO                           # Ignore only TODO in the root
build/                          # Ignore all files in build/
doc/*.txt                       # Ignore txt files in doc/
doc/**/*.pdf                    # Ignore all pdf files in doc/ and subdirs
```

## Staging Changes
```bash
git add <path>                  # Stage changes
git add --patch                 # Interactively choose hunks
git add --update                # Update tracked files
```

## Viewing Changes
```bash
git diff                                   # Show diff of modified files
git diff --staged                          # Show diff staged from last commit
git diff <oldHash>..<newHash>              # Show diff between two commits
git diff --no-index <file-one> <file-two>  # Show diff between two files
```

## Unstaging and Cleaning
```bash
git restore                     # Restore to last commit state
git restore --staged <path>     # Unstage files
git clean                       # Remove untracked files
```

## Commit History
```bash
git log                         # Show commit history
```
### Log Options:
- `--graph`: Show graph in logs
- `--patch`: Show diffs in logs
- `--oneline`: One-line commit messages
- Date filters: `--before`, `--after`
  ```
    --before="2020-09-29"
    --after="2020-09-29"
    --after="yesterday"
    --after="one week ago"
    --after="one month ago"
  ```
- Range log: `<oldHash>..<newHash>`
- File-specific log(if git cannot detec file): `-- <filename>`



**Note:** To show all commits if HEAD is detached:
```bash
git log --graph --oneline --all
```

## Branching
```bash
git branch                      # List all branches
git branch -m <oldname> <newname>  # Rename a branch

git switch <branch-name>        # Switch to another branch
git switch -C <branch-name>        # create new branch and switch to it 
```

## Merging
**Type**
  - fast forward
  - 3 way merge

```bash
git merge <branchname>          # Merge a branch
git merge --no-ff <branchname>  # Merge without fast-forward
```
```bash
--no-ff           --ff (default)
                           
* Merge 1           * Head 
| \                 |
|  @                @
|  |                |
|  @                @ 
|  |                | 
|  @ feature        @ feature 
| /                / 
*                  *
|                  |
*                  *
|                  |
* main             * main


```
- **Configure fast-forward behavior:**
```bash
git config ff no                # Disable fast-forward by default
git config --global ff no

git branch --merged              # Show merged branches
git branch --no-merged           # Show unmerged branches
git merge --abort                # Abort the merge
```

## Rebasing
**Video:** [Git Rebase](https://www.youtube.com/watch?v=qsTthZi23VE&t=1840s)

## Stashing Changes
```bash
git stash push -m "message"     # Stash changes with a message
git stash apply <index>         # Apply a stashed change
git stash list                  # List stashed changes
git stash drop <index>          # Drop a stashed change
git stash clear                 # Clear all stashes
```

## Cherry-Picking
```bash
git cherry-pick <hash>          # Apply a commit from another branch
```

## Tagging
```bash
git tag <hashcode>              # Create a lightweight tag
git tag <hashcode> -m "message" # Create an annotated tag

git tag -l <wildcard>           # List tags

git push origin <tag>           # Push a specific tag
git push origin --tags          # Push all tags

git tag -d <tag-name>           # Delete a local tag

git push origin --delete <tag-name> # Delete a remote tag
```

## Blame 
```bash
git blame <file-name>           # Show who changed each line in a file
git blame -L <line_No>,<line_No> <file-name>
git blame -L 11,22 main.js
```

## Bisect
```bash
git bisect                       # Use for binary search in commits
```
**Video:** [Git Bisect](https://youtu.be/z-AkSXDqodc?si=sLx0elyCX08g7KGm)

## Reflog
```bash
git reflog                      # View commit history for recovery
```

## Submodules
```bash
git submodule add <url>        # Add a submodule
git add .                      # Stage changes in the super project
git commit                     # Commit changes
```
**Video:** [Git Submodules](https://www.youtube.com/watch?v=gSlXo2iLBro&t=12s)

## Additional History Management
**Video:** [Git History Management](https://www.youtube.com/watch?v=ElRzTuYln0M&t=425s)

## Resetting Changes
```bash
git bash reset <filename/path>
```
- `--soft`: Reset HEAD but keep changes staged
- `--mixed`: Reset HEAD and keep changes unstaged
- `--hard`: Reset HEAD and discard all changes
