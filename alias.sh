#!/bin/bash

# Get alias name from first argument or use default
ALIAS_NAME="${1:-start-coding}"

# Clean up any existing alias with this name
echo "Cleaning up existing alias '$ALIAS_NAME'..."
gh alias delete "$ALIAS_NAME" 2>/dev/null || true

# Set the new alias
gh alias set --clobber "$ALIAS_NAME" '!f() { \
  if [ "$1" = "--help" ]; then \
    echo "Usage: gh '"$ALIAS_NAME"' <JIRA_TICKET> [ISSUE_TYPE] [PR_TITLE]"; \
    echo ""; \
    echo "Start work on a new feature by creating a branch and PR"; \
    echo ""; \
    echo "Arguments:"; \
    echo "  JIRA_TICKET    Required. The Jira ticket number/ID"; \
    echo "  ISSUE_TYPE     Optional. Type of issue (default: feat)"; \
    echo "                 Valid values:"; \
    echo "                   feat     : new feature for the user"; \
    echo "                   fix      : bug fix for the user"; \
    echo "                   refactor : code refactoring"; \
    echo "                   chore    : build tasks, documentation, style, etc."; \
    echo "  PR_TITLE       Optional. Additional text for PR title"; \
    echo ""; \
    echo "Options:"; \
    echo "  --help         Show this help message"; \
    return 0; \
  fi; \
  JIRA_TICKET="$1"; \
  if [[ -z "$JIRA_TICKET" ]]; then echo "Error: JIRA_TICKET_NUMBER is required"; exit 1; fi; \
  shift; \
  ISSUE_TYPE="feat"; \
  PR_TITLE=""; \
  # Check if next argument is an issue type \
  if [[ "$1" =~ ^(feat|fix|refactor|chore)$ ]]; then \
    ISSUE_TYPE="$1"; \
    shift; \
  fi; \
  # Any remaining argument is treated as PR title \
  if [[ -n "$1" ]]; then \
    PR_TITLE=": $1"; \
  fi; \
  if ! git remote get-url origin >/dev/null 2>&1; then \
    echo "Error: No origin remote found. Please set up your git remote first."; \
    echo "Use: git remote add origin <repository-url>"; \
    exit 1; \
  fi; \
  REPO=$(git config --get remote.origin.url | sed "s/.*github.com[:/]\(.*\)\.git/\1/"); \
  BRANCH_NAME="${ISSUE_TYPE}/${JIRA_TICKET// /_}"; \
  git checkout -b "$BRANCH_NAME" && \
  echo "\n# ${BRANCH_NAME}" >> .changes.md && \
  git add .changes.md && \
  git commit -m "chore: initialize ${BRANCH_NAME}" && \
  git push -u origin "$BRANCH_NAME" && \
  gh pr create --repo "$REPO" --title "${BRANCH_NAME}${PR_TITLE}" --body "Work started on $BRANCH_NAME" --base main --draft; \
}; f "$@"'

# Echo usage information after installation
echo "✓ Alias installed successfully as: $ALIAS_NAME"
echo ""
echo "Usage examples:"
echo "  gh $ALIAS_NAME PROJ-123                           # Start a feature"
echo "  gh $ALIAS_NAME PROJ-123 \"Add login\"              # Feature with title"
echo "  gh $ALIAS_NAME PROJ-456 fix \"Fix login button\"    # Bug fix with title"
echo "  gh $ALIAS_NAME --help                            # Show help" 