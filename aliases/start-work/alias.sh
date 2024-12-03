#!/bin/bash

gh alias set --clobber start-work '!f() { \
  if [ "$1" = "--help" ]; then \
    echo "Usage: gh start-work <JIRA_TICKET> [ISSUE_TYPE] [PR_TITLE]"; \
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
    echo "  PR_TITLE       Optional. Additional title text for the PR"; \
    echo "                 Will be appended after the branch name"; \
    echo ""; \
    echo "Options:"; \
    echo "  --help         Show this help message"; \
    return 0; \
  fi; \
  JIRA_TICKET="$1"; \
  ISSUE_TYPE=${2:-feat}; \
  PR_TITLE="$3"; \
  if [[ -z "$JIRA_TICKET" ]]; then echo "Error: JIRA_TICKET_NUMBER is required"; exit 1; fi; \
  if [[ ! "$ISSUE_TYPE" =~ ^(feat|fix|refactor|chore)$ ]]; then \
    echo "Error: ISSUE_TYPE must be one of: feat, fix, refactor, chore"; \
    echo ""; \
    echo "Valid types:"; \
    echo "  feat     : new feature for the user"; \
    echo "  fix      : bug fix for the user"; \
    echo "  refactor : code refactoring"; \
    echo "  chore    : build tasks, documentation, style, etc."; \
    exit 1; \
  fi; \
  if ! git remote get-url origin >/dev/null 2>&1; then \
    echo "Error: No origin remote found. Please set up your git remote first."; \
    echo "Use: git remote add origin <repository-url>"; \
    exit 1; \
  fi; \
  REPO=$(git config --get remote.origin.url | sed "s/.*github.com[:/]\(.*\)\.git/\1/"); \
  BRANCH_NAME="${ISSUE_TYPE}/${JIRA_TICKET// /_}"; \
  FULL_PR_TITLE="$BRANCH_NAME"; \
  if [[ -n "$PR_TITLE" ]]; then \
    FULL_PR_TITLE="$BRANCH_NAME: $PR_TITLE"; \
  fi; \
  git checkout -b "$BRANCH_NAME" && \
  echo -e "\n# ${BRANCH_NAME}" >> .changes.md && \
  git add .changes.md && \
  git commit -m "chore: initialize ${BRANCH_NAME}" && \
  git push -u origin "$BRANCH_NAME" && \
  gh pr create --repo "$REPO" --title "$FULL_PR_TITLE" --body "Work started on $BRANCH_NAME" --base main --draft; \
}; f "$@"' 