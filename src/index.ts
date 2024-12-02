#!/usr/bin/env node
import { program } from 'commander';
import { execSync } from 'child_process';
import fs from 'fs';
import path from 'path';

const VALID_ISSUE_TYPES = ['feature', 'bug', 'maintenance', 'chore'] as const;
type IssueType = typeof VALID_ISSUE_TYPES[number];

function executeCommand(command: string): string {
  try {
    return execSync(command, { encoding: 'utf-8' }).trim();
  } catch (error) {
    console.error(`Failed to execute command: ${command}`);
    throw error;
  }
}

async function startWork(jiraTicket: string, issueType: IssueType = 'feature') {
  // Validate git remote
  try {
    executeCommand('git remote get-url origin');
  } catch (error) {
    console.error('Error: No origin remote found. Please set up your git remote first.');
    console.error('Use: git remote add origin <repository-url>');
    process.exit(1);
  }

  // Get repo info
  const repo = executeCommand('git config --get remote.origin.url')
    .replace(/.*github\.com[:/](.*)\.git/, '$1');

  // Create branch
  const branchName = `${issueType}/${jiraTicket.replace(/\s+/g, '_')}`;
  
  // Create and switch to new branch
  executeCommand(`git checkout -b ${branchName}`);

  // Update .changes.md
  const changesPath = path.join(process.cwd(), '.changes.md');
  fs.appendFileSync(changesPath, `\n# ${branchName}\n`);

  // Commit and push
  executeCommand('git add .changes.md');
  executeCommand(`git commit -m "chore: initialize ${branchName}"`);
  executeCommand(`git push -u origin ${branchName}`);

  // Create PR
  executeCommand(
    `gh pr create --repo "${repo}" --title "${branchName}" --body "Work started on ${branchName}" --base main --draft`
  );
}

program
  .name('gh-start-work')
  .description('Start work on a new feature by creating a branch and PR')
  .argument('<jiraTicket>', 'The Jira ticket number/ID')
  .argument('[issueType]', 'Type of issue', 'feature')
  .action(async (jiraTicket: string, issueType: string) => {
    if (!jiraTicket) {
      console.error('Error: JIRA_TICKET is required');
      process.exit(1);
    }

    if (!VALID_ISSUE_TYPES.includes(issueType as IssueType)) {
      console.error('Error: ISSUE_TYPE must be feature, bug, maintenance, or chore');
      process.exit(1);
    }

    await startWork(jiraTicket, issueType as IssueType);
  });

program.parse(); 