# GitHub Start Work CLI

A CLI tool that helps streamline the process of starting work on a new task by automating branch creation and pull request setup.

## Installation

```bash
# Install from your private registry
yarn add @your-org/gh-start-work

# Or globally
yarn global add @your-org/gh-start-work
```

## Prerequisites

- Git repository with an origin remote configured
- GitHub CLI installed and authenticated
- Write access to the repository

## Usage

```bash
gh-start-work <JIRA_TICKET> [ISSUE_TYPE]
```

### Arguments

- `JIRA_TICKET` (Required): The Jira ticket number/ID that this work relates to
- `ISSUE_TYPE` (Optional): Type of issue you're working on. Defaults to "feature"
  - Valid values: `feature`, `bug`, `maintenance`, `chore`

### Examples

```bash
# Start work on a feature
gh-start-work PROJ-123

# Start work on a bug fix
gh-start-work PROJ-456 bug

# Start work on a maintenance task
gh-start-work PROJ-789 maintenance

# Start work on a chore
gh-start-work PROJ-101 chore
```

## What it does

When you run this command, it will:

1. Create a new branch named `<ISSUE_TYPE>/<JIRA_TICKET>`
2. Append a new section to `.changes.md` with the branch name as the title
3. Commit the updated `.changes.md` file
4. Push the branch to the remote repository
5. Create a pull request in DRAFT state with:
   - Title: Branch name
   - Body: "Work started on <branch_name>"
   - Base branch: main

## Development

```bash
# Install dependencies
yarn install

# Build
yarn build

# Run locally
yarn dev

# Run tests
yarn test
```

## Publishing

```bash
# Bump version in package.json, then:
yarn publish
```