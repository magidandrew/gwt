# Git Worktree Helpers

Simple bash functions to make [git worktrees](https://git-scm.com/docs/git-worktree) easier to manage.

## What are git worktrees?

Git worktrees let you have multiple branches checked out at the same time in different directories. Perfect for:
- Working on a feature while quickly switching to fix a bug
- Comparing branches side-by-side
- Running tests on one branch while developing on another
- Code review without stashing or committing WIP changes

## Features

- **`gwt`** - Create a new worktree with a new branch
- **`gwt-checkout`** - Create a worktree from an existing branch
- **`gwt-rm`** - Remove a worktree
- **`gwt-ls`** - List all worktrees

All worktrees are created in a `<repo>-worktrees/` directory next to your main repo.

## Installation
```bash
curl -fsSL https://raw.githubusercontent.com/magidandrew/gwt/main/git-worktree-helpers.sh >> ~/.zshrc && source ~/.zshrc
```

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
gwt-checkout <branch> <name>
```

**Example:**

```bash
# Checkout existing branch into a worktree
gwt-checkout hotfix/urgent-bug hotfix
```

**What it does:**
- Checks out an existing branch
- Creates worktree in `<repo>-worktrees/<name>/`
- Automatically `cd`s into the worktree

### Remove a worktree

```bash
gwt-rm <name>
```

**Example:**

```bash
gwt-rm feature-auth
```

**What it does:**
- Removes the worktree at `<repo>-worktrees/<name>/`
- Cleans up git's worktree tracking

### List all worktrees

```bash
gwt-ls
```

Shows all worktrees and their branches (alias for `git worktree list`)

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
gwt-rm urgent-fix

# List all your worktrees
gwt-ls
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

## Requirements

- Git 2.5+ (worktrees were added in Git 2.5)
- Bash or Zsh

## Contributing

Issues and pull requests welcome! This is a simple utility script, so let's keep it focused and dependency-free.
