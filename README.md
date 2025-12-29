# Git Worktree Helpers

Simple bash functions to make [git worktrees](https://git-scm.com/docs/git-worktree) easier to manage.

## What are git worktrees?

Git worktrees let you have multiple branches checked out at the same time in different directories. Perfect for:
- Working on a feature while quickly switching to fix a bug
- Comparing branches side-by-side
- Running tests on one branch while developing on another
- Code review without stashing or committing WIP changes

## Features

- **`gwt <base> <name>`** - Create a new worktree with a new branch
- **`gwt checkout <branch> <name>`** - Create a worktree from an existing branch
- **`gwt rm <name>`** - Remove a worktree
- **`gwt ls`** - List all worktrees

All worktrees are created in a `<repo>-worktrees/` directory next to your main repo.

## Installation

### Recommended: Using the install script

```bash
# Clone or download the repo
git clone https://github.com/magidandrew/gwt.git
cd gwt

# Run the install script
./install.sh
```

The script will copy `git-worktree-helpers.sh` to `~/.config/gwt/` and show you the exact line to add to your `~/.zshrc`:

```bash
source "$HOME/.config/gwt/git-worktree-helpers.sh"
```

Quick one-liner to add it:
```bash
echo 'source "$HOME/.config/gwt/git-worktree-helpers.sh"' >> ~/.zshrc && source ~/.zshrc
```

**Benefits:**
- Easy to update (just run `./install.sh` again)
- Keeps your `.zshrc` clean
- No duplicate code issues

### Alternative: Direct install

```bash
curl -o- https://raw.githubusercontent.com/magidandrew/gwt/main/install.sh | bash
```

Then add the source line shown in the output to your `~/.zshrc`.

## Usage

### Create a new worktree with a new branch

```bash
gwt <base-branch> <name> [branch-name]
```

**Examples:**

```bash
# Create worktree named "feature-auth" with branch "wt/feature-auth" based on main
gwt main feature-auth

# Create worktree with custom branch name
gwt main feature-auth feature/user-authentication

# Work from develop branch
gwt develop bugfix-123
```

**What it does:**
- Creates a new branch from `<base-branch>`
- Creates worktree in `<repo>-worktrees/<name>/`
- Automatically `cd`s into the new worktree
- Default branch name is `wt/<name>` if not specified

### Checkout existing branch into worktree

```bash
gwt checkout <branch> <name>
# or shorter:
gwt co <branch> <name>
```

**Example:**

```bash
# Checkout existing branch into a worktree
gwt checkout hotfix/urgent-bug hotfix
gwt co hotfix/urgent-bug hotfix  # shorter alias
```

**What it does:**
- Checks out an existing branch
- Creates worktree in `<repo>-worktrees/<name>/`
- Automatically `cd`s into the worktree

### Remove a worktree

```bash
gwt rm <name>
# or:
gwt remove <name>
```

**Example:**

```bash
gwt rm feature-auth
```

**What it does:**
- Removes the worktree at `<repo>-worktrees/<name>/`
- Cleans up git's worktree tracking

### List all worktrees

```bash
gwt ls
# or:
gwt list
```

Shows all worktrees and their branches

## Example Workflow

```bash
# You're in ~/projects/my-app working on main
cd ~/projects/my-app

# Create a feature branch worktree
gwt main new-feature
# Now in ~/projects/my-app-worktrees/new-feature/

# Make changes, commit, etc.
git add .
git commit -m "Add new feature"

# Need to quickly fix a bug? Create another worktree
gwt main urgent-fix
# Now in ~/projects/my-app-worktrees/urgent-fix/

# Fix the bug, commit, push
git add .
git commit -m "Fix urgent bug"
git push

# Go back to your feature
cd ~/projects/my-app-worktrees/new-feature/

# When done with the urgent fix
gwt rm urgent-fix

# List all your worktrees
gwt ls
# /Users/you/projects/my-app              abc123 [main]
# /Users/you/projects/my-app-worktrees/new-feature  def456 [wt/new-feature]
```

## Directory Structure

If your main repo is at `~/projects/my-app`, worktrees are created at:

```
~/projects/
├── my-app/                    # Main repo
└── my-app-worktrees/          # Worktrees directory
    ├── feature-auth/          # Worktree 1
    ├── bugfix-123/            # Worktree 2
    └── hotfix/                # Worktree 3
```

## Why These Helpers?

Native git worktree commands are verbose and require remembering paths:

```bash
# Without helpers
git worktree add ../my-app-worktrees/feature-auth -b wt/feature-auth main
cd ../my-app-worktrees/feature-auth

# With helpers
gwt main feature-auth
```

## All Commands

```bash
gwt <base> <name> [branch]      # Create new worktree with new branch
gwt checkout <branch> <name>    # Checkout existing branch (alias: co)
gwt rm <name>                   # Remove worktree (alias: remove)
gwt ls                          # List worktrees (alias: list)
gwt help                        # Show help
```

## Troubleshooting

### "defining function based on alias" error

If you see an error like:
```
/Users/you/.zshrc:XXX: defining function based on alias `gwt'
/Users/you/.zshrc:XXX: parse error near `()'
```

This means you already have a `gwt` alias defined in your shell config. The script now automatically removes any conflicting aliases, so:

1. Remove the duplicate code from your `.zshrc` (the section you just appended)
2. Source the script again:
   ```bash
   source ~/.zshrc
   ```

Or manually check for existing aliases:
```bash
alias | grep gwt
```

## Requirements

- Git 2.5+ (worktrees were added in Git 2.5)
- Bash or Zsh

## Contributing

Issues and pull requests welcome! This is a simple utility script, so let's keep it focused and dependency-free.
