PART 1 — Create the project

Since you're using Windows/MobaXterm, open your terminal.

mkdir payment-api
cd payment-api

Initialize Git:

git init
git branch -M main

Verify:

git status

PART 2 — Create realistic project files

Create directories:

mkdir app scripts config

Create README:

cat > README.md <<EOF
# Payment API

Production payment service.

Environment:
- Development
- QA
- Production
EOF

Create application configuration:

cat > config/application.properties <<EOF
APP_NAME=payment-api
ENVIRONMENT=production
LOG_LEVEL=INFO
SERVER_PORT=8080
EOF

Create deployment script:

cat > scripts/deploy.sh <<EOF
#!/bin/bash

echo "Starting payment-api deployment"

echo "Deploying application..."

echo "Deployment completed"
EOF

Create application configuration:

cat > app/application.conf <<EOF
application:
  name: payment-api
  version: 1.0
  replicas: 2
EOF


PART 3 — First production commit

Check:

git status

Add everything:

git add .

Commit:

git commit -m "Initial payment API project setup"

Check:

git log --oneline

You should have:

abc1234 Initial payment API project setup

PART 4 — Add production deployment configuration

Modify:

cat >> scripts/deploy.sh <<EOF

echo "Checking deployment prerequisites"
echo "Checking available disk space"
echo "Checking application health"
EOF

Commit:

git add scripts/deploy.sh
git commit -m "Add production deployment checks"

Now:

git log --oneline

Expected:

b2c3d4e Add production deployment checks
a1b2c3d Initial payment API project setup

Your production branch is now:

A
|
B
|
main

PART 5 — Developer starts payment feature

Now pretend you're Developer 1.

Create feature branch:

git checkout -b feature/payment-deployment

Verify:

git branch

You should see:

* feature/payment-deployment
  main
  
PART 6 — Implement payment deployment

Create:

cat > config/payment.properties <<EOF
PAYMENT_PROVIDER=stripe
PAYMENT_TIMEOUT=30
PAYMENT_RETRY_COUNT=3
EOF

Commit:

git add config/payment.properties
git commit -m "Add payment deployment configuration"

Now modify deployment script:

cat >> scripts/deploy.sh <<EOF

echo "Loading payment configuration"
echo "Validating payment provider configuration"
EOF

Commit:

git add scripts/deploy.sh
git commit -m "Add payment deployment validation"

Check history:

git log --oneline --graph --all

You should see:

* 2222222 Add payment deployment validation
* 1111111 Add payment deployment configuration
* b2c3d4e Add production deployment checks
* a1b2c3d Initial payment API project setup

PART 7 — Simulate another developer changing main

Now we need to create a real-world situation.

Imagine another DevOps engineer has been asked to improve production deployment.

Switch to main:

git checkout main

Another developer modifies:

cat >> scripts/deploy.sh <<EOF

echo "Checking production environment"
echo "Validating production secrets"
EOF

Commit:

git add scripts/deploy.sh
git commit -m "Add production environment validation"

Now check:

git log --oneline --graph --all

You should have:

* 3333333 Add production environment validation
|\
| * 2222222 Add payment deployment validation
| * 1111111 Add payment deployment configuration
|/
* b2c3d4e Add production deployment checks
* a1b2c3d Initial payment API project setup

Now you have branch divergence.

PART 8 — Understand the real situation

Your repository now looks like:

                    feature/payment-deployment
                           |
                           C
                           |
                           B
                          /
A ----------------------/
                         \
                          D
                           |
                          main

More accurately:

                  C
                 /
A---B----------- 
     \
      D

Where:

A = Initial setup
B = Production deployment checks
C = Payment feature work
D = Production validation

The important point is:

feature/payment-deployment → C
main                      → D

They have diverged.

PART 9 — REAL MERGE LAB

Now let's first solve this using merge.

Switch to main:

git checkout main

Run:

git merge feature/payment-deployment

Git may automatically merge the changes.

If successful:

Merge made by the 'ort' strategy.

Check:

git log --oneline --graph --decorate --all

You'll see:

*   M Merge branch 'feature/payment-deployment'
|\
| * C Add payment deployment validation
| * B Add payment deployment configuration
* | D Add production environment validation
|/
* A Production deployment checks
What happened?

Git created:

M

The merge commit has two parents:

       C
      / \
     /   \
    D     M
     \   /
      \ /
       B

Conceptually:

M
├── parent 1 → D
└── parent 2 → C

PART 10 — Inspect the merge commit

Run:

git show --no-patch --pretty=raw HEAD

Look for:

parent <hash>
parent <hash>

That's how you prove that the merge commit has two parents.

This is an excellent interview demonstration.

PART 11 — Now let's do a REAL merge conflict

The previous merge may have been clean because we modified different portions of the file.

Now let's intentionally create a conflict.

We'll use:

config/application.properties
Step 1 — Create another feature branch

Switch to main:

git checkout main

Create:

git checkout -b feature/logging

Change:

sed -i 's/LOG_LEVEL=INFO/LOG_LEVEL=DEBUG/' config/application.properties

Commit:

git add .
git commit -m "Enable debug logging for payment troubleshooting"

PART 12 — Change the SAME line in main

Switch:

git checkout main

Now change the same line:

sed -i 's/LOG_LEVEL=INFO/LOG_LEVEL=WARN/' config/application.properties

Commit:

git add .
git commit -m "Reduce production logging level"

Now:

main:

LOG_LEVEL=WARN

while:

feature/logging:

LOG_LEVEL=DEBUG

PART 13 — Trigger the merge conflict

Run:

git merge feature/logging

Git should report:

CONFLICT (content): Merge conflict in config/application.properties
Automatic merge failed; fix conflicts and then commit the result.

Excellent.

You have created a real conflict.

PART 14 — Inspect conflict

Run:

git status

You'll see something like:

Unmerged paths:

both modified:
    config/application.properties

Open:

cat config/application.properties

You'll see:

APP_NAME=payment-api
ENVIRONMENT=production
<<<<<<< HEAD
LOG_LEVEL=WARN
=======
LOG_LEVEL=DEBUG
>>>>>>> feature/logging
SERVER_PORT=8080

Understand these markers.

<<<<<<< HEAD

means:

Current branch (main)

=======

means:

Separator

>>>>>>> feature/logging

means:

Incoming branch

PART 15 — Resolve the conflict like a DevOps engineer

Production should normally have:

LOG_LEVEL=WARN

So edit:

vi config/application.properties

Make it:

APP_NAME=payment-api
ENVIRONMENT=production
LOG_LEVEL=WARN
SERVER_PORT=8080

Remove:

<<<<<<<
=======
>>>>>>>

Save.

Check:

git diff

Then:

git add config/application.properties

Check:

git status

Now commit:

git commit -m "Merge feature/logging into main"

PART 16 — Important merge recovery commands

If you realize:

"I don't want to continue this merge."

Use:

git merge --abort

This returns you to the state before the merge.

Very important interview command.
