#!/bin/bash
# git-worktree-helpers.sh
# Simple bash functions to make git worktrees easier to manage

# Create a worktree with a new branch
# Usage: gwt <base-branch> <name> [branch-name]
gwt() {
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "Usage: gwt <base-branch> <name> [branch-name]"
    echo "  base-branch:  Branch to base worktree on (e.g., main, develop)"
    echo "  name:         Worktree folder name"
    echo "  branch-name:  Optional new branch name (default: wt/<name>)"
    echo ""
    echo "Examples:"
    echo "  gwt main feature-auth"
    echo "  gwt main feature-auth feature/user-authentication"
    return 1
  fi

  local base_branch="$1"
  local name="$2"
  local new_branch="${3:-wt/${name}}"
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$repo_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local worktree_dir="${repo_root}-worktrees/${name}"

  echo "Creating worktree:"
  echo "  📁 ${worktree_dir}"
  echo "  🌿 ${new_branch} (from ${base_branch})"

  git worktree add -b "${new_branch}" "${worktree_dir}" "${base_branch}" && cd "${worktree_dir}"
}

# Checkout existing branch into worktree
# Usage: gwt-checkout <branch> <name>
gwt-checkout() {
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "Usage: gwt-checkout <branch> <name>"
    echo "  branch:  Existing branch to checkout"
    echo "  name:    Worktree folder name"
    echo ""
    echo "Example:"
    echo "  gwt-checkout hotfix/urgent-bug hotfix"
    return 1
  fi

  local branch="$1"
  local name="$2"
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$repo_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local worktree_dir="${repo_root}-worktrees/${name}"

  echo "Checking out worktree:"
  echo "  📁 ${worktree_dir}"
  echo "  🌿 ${branch}"

  git worktree add "${worktree_dir}" "${branch}" && cd "${worktree_dir}"
}

# Remove a worktree
# Usage: gwt-rm <name>
gwt-rm() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwt-rm <name>"
    echo "  name:  Worktree folder name to remove"
    echo ""
    echo "Example:"
    echo "  gwt-rm feature-auth"
    return 1
  fi

  local name="$1"
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$repo_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local worktree_dir="${repo_root}-worktrees/${name}"

  git worktree remove "${worktree_dir}" && echo "✅ Removed ${worktree_dir}"
}

# List all worktrees
alias gwt-ls="git worktree list"
