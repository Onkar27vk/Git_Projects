PART 17 — NOW THE REBASE LAB

Now we'll recreate a realistic feature workflow.

Create a new feature:

git checkout main
git checkout -b feature/monitoring

Create monitoring configuration:

cat > config/monitoring.properties <<EOF
HEALTH_ENDPOINT=/health
METRICS_ENDPOINT=/metrics
HEALTH_TIMEOUT=5
EOF

Commit:

git add .
git commit -m "Add application monitoring configuration"

Second commit:

cat >> scripts/deploy.sh <<EOF

echo "Registering application with monitoring"
echo "Checking application health endpoint"
EOF

Commit:

git add .
git commit -m "Add monitoring deployment checks"
PART 18 — Main moves forward

Switch:

git checkout main

Another production change:

cat >> scripts/deploy.sh <<EOF

echo "Publishing deployment status"
EOF

Commit:

git add .
git commit -m "Publish production deployment status"

Now:

git log --oneline --graph --all

You have:

* MAIN-2 Publish production deployment status
|
| * FEATURE-2 Add monitoring deployment checks
| * FEATURE-1 Add application monitoring configuration
|/
* BASE
PART 19 — Perform REBASE

Switch to feature:

git checkout feature/monitoring

Now:

git rebase main

If everything is clean, Git will replay your two feature commits.

The history becomes:

BASE
 |
MAIN-1
 |
MAIN-2
 |
FEATURE-1'
 |
FEATURE-2'

Run:

git log --oneline --graph --decorate --all

You'll see a straight line:

* FEATURE-2' Add monitoring deployment checks
* FEATURE-1' Add application monitoring configuration
* MAIN-2 Publish production deployment status
* MAIN-1 ...
* BASE ...
PART 20 — Verify the commit IDs changed

Before rebase, your feature commits had hashes like:

abc1111
abc2222

After rebase:

def1111
def2222

The commit messages remain:

Add application monitoring configuration
Add monitoring deployment checks

but their SHA changes.

Why?

Because the parent changed.

This is the core concept of rebase.

PART 21 — REAL REBASE CONFLICT

Now let's intentionally create one.

Create:

git checkout main
git checkout -b feature/timeout

Change:

sed -i 's/SERVER_PORT=8080/SERVER_PORT=8081/' config/application.properties

Commit:

git add .
git commit -m "Change application server port"

Now switch main:

git checkout main

Change the same line differently:

sed -i 's/SERVER_PORT=8080/SERVER_PORT=9090/' config/application.properties

Commit:

git add .
git commit -m "Update production server port"

Now:

main:

SERVER_PORT=9090

Feature:

SERVER_PORT=8081
PART 22 — Start rebase

Switch:

git checkout feature/timeout

Run:

git rebase main

Git should stop.

You'll see something like:

CONFLICT (content): Merge conflict in config/application.properties
PART 23 — Check status
git status

You'll see:

interactive rebase in progress
You are currently rebasing branch 'feature/timeout'

This is different from merge.

Git is saying:

I'm currently replaying your feature commit and it encountered a conflict.

PART 24 — Inspect the file
cat config/application.properties

You'll see:

<<<<<<< HEAD
SERVER_PORT=9090
=======
SERVER_PORT=8081
>>>>>>> abc1234

Resolve it.

For example, production standard:

SERVER_PORT=9090

Save the file.

PART 25 — Tell Git the conflict is resolved
git add config/application.properties

Then:

git rebase --continue

If Git opens an editor, save the commit message and exit.

If Vim:

Esc
:wq
Enter
PART 26 — Verify the rebase

Run:

git log --oneline --graph --decorate --all

You should now see:

* FEATURE' Change application server port
* MAIN Update production server port
* ...

Linear history.

PART 27 — Abort the rebase

If you wanted to cancel:

git rebase --abort

Git returns to the state before the rebase.

This is one of the commands you should know extremely well.
