# GitHub CLI Start-Coding Alias

A GitHub CLI alias that helps streamline the process of starting work on a new task by automating branch creation and pull request setup.

## What is this?

This tool provides a simple command that:
- Creates a standardized branch name from your ticket (e.g., `feat/PROJ-123`)
- Tracks branch creation in a changes log
- Creates a draft PR automatically
- Supports different work types (feature, fix, refactor, chore)

Perfect for teams that want to:
- Maintain consistent branch naming
- Automate PR creation workflow
- Track work progress through branches
- Reduce manual setup time when starting new tasks

## Prerequisites

Before installing, ensure you have:
- [GitHub CLI](https://cli.github.com/) installed (`gh`)
- GitHub CLI authenticated (`gh auth login`)
- Git installed and configured
- Write access to the repository
- Git repository with an origin remote configured

## Installation

1. Clone this repository
2. Install the alias:

```bash
# Default installation (as "start-coding")
source alias.sh

# Or with a custom alias name
source alias.sh start-feature
```

3. Verify the installation:
```bash
gh alias list | grep start-coding  # or your custom name
```

### Uninstallation

To remove the alias:
```bash
gh alias delete start-coding  # or your custom alias name
```

## Usage

Replace `start-coding` with your custom alias name if you chose a different one during installation:


```bash
gh start-coding <JIRA_TICKET> [ISSUE_TYPE] [PR_TITLE]
```

### Arguments

- `JIRA_TICKET` (Required): The Jira ticket number/ID that this work relates to
- `ISSUE_TYPE` (Optional): Type of issue you're working on. Defaults to "feat"
  - Valid values:
    - `feat`: new feature for the user
    - `fix`: bug fix for the user
    - `refactor`: code refactoring (e.g. renaming a variable)
    - `chore`: anything else (build tasks, documentation, style, etc.)
- `PR_TITLE` (Optional): Additional descriptive text for the PR title
  - Will be appended after the branch name
  - If provided, PR title will be: "<branch_name>: <PR_TITLE>"
  - If omitted, PR title will just be the branch name

### Options

- `--help`: Display help information about the command

### Examples

```bash
# Start work on a feature
gh start-coding PROJ-123

# Start work on a feature with just a PR title (uses default feat type)
gh start-coding PROJ-123 "Add login functionality"

# Start work on a bug fix with a custom PR title
gh start-coding PROJ-456 fix "Fix login button styling"

# Start work on a refactor
gh start-coding PROJ-789 refactor

# Start work on a chore
gh start-coding PROJ-101 chore
```

## What it does

When you run this command, it will:

1. Create a new branch named `<ISSUE_TYPE>/<JIRA_TICKET>`
2. Append a new section to `.changes.md` with the branch name as the title
3. Commit the updated `.changes.md` file
4. Push the branch to the remote repository
5. Create a pull request in DRAFT state with:
   - Title: Branch name (and optional PR title if provided)
   - Body: "Work started on <branch_name>"
   - Base branch: main

## Error Handling

The command will fail with an appropriate error message if:

- No JIRA ticket is provided
- An invalid issue type is specified
- No git origin remote is configured
- GitHub CLI encounters any errors during PR creation

