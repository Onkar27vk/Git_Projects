1. Git Stash
Definition

git stash temporarily saves your uncommitted changes and restores your working directory to a clean state, allowing you to switch branches or work on another task without committing incomplete work.

Real-time DevOps scenario: You are modifying a deployment script when your lead asks you to fix a production Jenkins issue. You stash your unfinished changes, fix the issue, and return to your original task later.

Basic syntax
git stash
Important commands

Command

	

Purpose




git stash

	

Stash changes to tracked files




git stash push -m "message"

	

Stash changes with a descriptive message




git stash -u

	

Include untracked files




git stash -a

	

Include untracked and ignored files




git stash list

	

List all saved stashes




git stash show -u --stat

	

Show a summary of changes, including untracked files




git stash apply

	

Restore changes but keep the stash entry




git stash pop

	

Restore changes and remove the stash entry if successful




git stash drop stash@{0}

	

Delete a specific stash entry




git stash clear

	

Delete all stash entries

Practical example

Suppose you modified scripts/deploy.sh and created a new file called health-check.sh.

Check the changes:

git status

Save your changes, including the untracked file:

git stash push -u -m "WIP: deployment health check"

Verify:

git status
git stash list

Example stash list:

stash@{0}: On feature/deployment: WIP: deployment health check

Your working directory should now be clean if those were your only changes.

Important: Plain git stash does not normally include untracked files. Use -u when you need to save newly created files too.

2. Git Stash Pop
Definition

git stash pop restores the changes from the most recent stash and removes that stash entry if restoration succeeds.

Simple meaning: Bring your saved work back and remove it from the stash list.

Syntax
git stash pop
Real-time DevOps workflow

Step 1: Save unfinished work

git stash push -u -m "WIP: deployment health check"

Step 2: Switch to another branch

git switch main

Fix the urgent issue and commit it:

git add .
git commit -m "Fix production deployment issue"

Step 3: Return to your feature branch

git switch feature/deployment

Step 4: Restore your saved changes

git stash pop

Step 5: Verify the restored changes

git status
git diff

Your modified files and saved untracked files should be back in your working directory.

Difference between git stash pop and git stash apply

git stash pop

	

git stash apply




Restores the saved changes

	

Restores the saved changes




Removes the stash entry if successful

	

Keeps the stash entry




Useful when you no longer need that saved entry

	

Useful when you want to restore or reuse it again

Working with multiple stashes

Create two stash entries:

git stash push -u -m "WIP: logging changes"
git stash push -u -m "WIP: monitoring changes"

List them:

git stash list

Example:

stash@{0}: On feature/deployment: WIP: monitoring changes
stash@{1}: On feature/deployment: WIP: logging changes

Restore a specific stash without deleting it:

git stash apply 'stash@{1}'
What if a conflict occurs?

If the current branch has conflicting changes, git stash pop may stop and report a conflict.

git status

Resolve the conflicting files, then stage the resolution:

git add <file-name>

Check git stash list before retrying or removing the stash. A conflicted pop normally retains the stash entry.

Interview one-liners

Git stash: Temporarily saves uncommitted changes without creating a regular commit on the current branch.

Git stash pop: Restores the latest stash and removes its entry if successful.

Why use git stash -u? To include untracked files.

Can stash save multiple changes? Yes. Each stash is stored as a separate entry.

Does stash automatically push changes to GitHub? No. Stashes are local to your repository.

Quick revision:

git stash push -u -m "WIP changes"
git stash list
git stash pop
git status
