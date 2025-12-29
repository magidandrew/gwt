# Remove any existing aliases/functions to prevent conflicts
unalias gwt 2>/dev/null || true
unfunction gwt 2>/dev/null || true

# Main gwt function with subcommands
function gwt {
  local cmd="$1"

  # Handle subcommands
  case "$cmd" in
    ls|list)
      git worktree list
      ;;

    rm|remove)
      if [[ -z "$2" ]]; then
        echo "Usage: gwt rm <name>"
        echo "  name:  Worktree folder name to remove"
        echo ""
        echo "Example:"
        echo "  gwt rm feature-auth"
        return 1
      fi

      local name="$2"
      local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

      if [[ -z "$repo_root" ]]; then
        echo "Error: Not in a git repository"
        return 1
      fi

      local worktree_dir="${repo_root}-worktrees/${name}"
      git worktree remove "${worktree_dir}" && echo "✅ Removed ${worktree_dir}"
      ;;

    checkout|co)
      if [[ -z "$2" ]] || [[ -z "$3" ]]; then
        echo "Usage: gwt checkout <branch> <name>"
        echo "  branch:  Existing branch to checkout"
        echo "  name:    Worktree folder name"
        echo ""
        echo "Example:"
        echo "  gwt checkout hotfix/urgent-bug hotfix"
        return 1
      fi

      local branch="$2"
      local name="$3"
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
      ;;

    help|--help|-h)
      echo "Git Worktree Helpers"
      echo ""
      echo "Usage: gwt <base-branch> <name> [branch-name]"
      echo "       gwt <command> [options]"
      echo ""
      echo "Commands:"
      echo "  gwt <base> <name> [branch]  Create new worktree with new branch"
      echo "  gwt checkout <branch> <name> Checkout existing branch into worktree"
      echo "  gwt rm <name>                Remove a worktree"
      echo "  gwt ls                       List all worktrees"
      echo ""
      echo "Examples:"
      echo "  gwt main feature-auth"
      echo "  gwt main feature-auth feature/user-authentication"
      echo "  gwt checkout hotfix/urgent-bug hotfix"
      echo "  gwt rm feature-auth"
      echo "  gwt ls"
      ;;

    *)
      # Default: create new worktree with new branch
      if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "Usage: gwt <base-branch> <name> [branch-name]"
        echo "  base-branch:  Branch to base worktree on (e.g., main, develop)"
        echo "  name:         Worktree folder name"
        echo "  branch-name:  Optional new branch name (default: wt/<name>)"
        echo ""
        echo "Examples:"
        echo "  gwt main feature-auth"
        echo "  gwt main feature-auth feature/user-authentication"
        echo ""
        echo "Other commands:"
        echo "  gwt checkout <branch> <name>  Checkout existing branch into worktree"
        echo "  gwt rm <name>                  Remove a worktree"
        echo "  gwt ls                         List all worktrees"
        echo "  gwt help                       Show detailed help"
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
      ;;
  esac
}
