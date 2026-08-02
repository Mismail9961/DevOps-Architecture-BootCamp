# Git Version Control & Branch Management — Complete Guide

A beginner-friendly README covering everything from this Git lecture: SSH setup, cloning, `.gitignore`, core commands, and branching — with simple explanations for each command.

---

## 📌 Table of Contents

1. [SSH Key Setup for GitHub](#1-ssh-key-setup-for-github)
2. [Cloning a Repository](#2-cloning-a-repository)
3. [Using .gitignore](#3-using-gitignore)
4. [Core Git Workflow (Add, Commit, Push)](#4-core-git-workflow-add-commit-push)
5. [Branching (Create, Switch, Merge)](#5-branching-create-switch-merge)
6. [Syncing with Remote](#6-syncing-with-remote)
7. [Best Practices](#7-best-practices)
8. [Building a Git Portfolio](#8-building-a-git-portfolio)
9. [Quick Command Cheat Sheet](#9-quick-command-cheat-sheet)

---

## 1. SSH Key Setup for GitHub

**Why:** Instead of typing your GitHub username/password every time, an SSH key lets your computer and GitHub "trust" each other automatically.

**Step 1 — Generate a key pair:**
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
- This creates two files: a **private key** (keep secret, never share) and a **public key** (`.pub` file — safe to share).
- When asked for a passphrase, you can press `Enter` to skip it (simpler, but slightly less secure).

**Step 2 — Check the SSH agent is running and add your key:**
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**Step 3 — Copy your public key:**
```bash
cat ~/.ssh/id_ed25519.pub
```
Copy the output.

**Step 4 — Add it to GitHub:**
Go to **GitHub → Settings → SSH and GPG keys → New SSH key**, paste it, and save.

**Step 5 — Test the connection:**
```bash
ssh -T git@github.com
```
If it says *"You've successfully authenticated"* — you're done. ✅

---

## 2. Cloning a Repository

**Why:** Cloning downloads a copy of a remote repository (e.g., from GitHub) onto your computer, inside a **new folder**.

```bash
git clone git@github.com:username/repo-name.git
```

**Important:** After cloning, you must move **into** that new folder before running any Git commands:
```bash
cd repo-name
```

If you forget this step and run `git status` from the wrong folder, Git will say:
```
fatal: not a git repository
```
This simply means you're not standing inside a folder that Git is tracking.

---

## 3. Using `.gitignore`

**Why:** Some files shouldn't be uploaded to GitHub — like temporary cache files, dependency folders, or environment secrets. `.gitignore` tells Git to skip them.

**Step 1 — Create the file** in your project's root folder:
```bash
touch .gitignore
```

**Step 2 — Add patterns inside it**, for example:
```
# Python cache
__pycache__/
**/__pycache__/

# Node.js dependencies
node_modules/
**/node_modules/

# Environment files
.env
```

- `**/foldername/` means "ignore this folder no matter where it appears" (even in subfolders).
- This keeps your repository clean and avoids uploading huge, unnecessary files.

---

## 4. Core Git Workflow (Add, Commit, Push)

This is the everyday cycle you'll repeat constantly.

### Step 1 — Check what's changed
```bash
git status
```
Shows which files were modified, added, or deleted.

### Step 2 — Stage your changes
```bash
git add .
```
- `git add .` stages **all** changed files (prepares them to be saved).
- You can also stage a single file: `git add filename.txt`

### Step 3 — Commit your changes
```bash
git commit -m "Add login page functionality"
```
- A commit is like a "save point" in your project's history.
- The `-m` flag lets you add a message describing what you changed.
- **Best practice:** write clear, descriptive messages (not "fixed stuff") so you and others can understand the history later.

### Step 4 — Push to GitHub
```bash
git push
```
Uploads your committed changes to the remote repository (GitHub).

---

## 5. Branching (Create, Switch, Merge)

**Why:** Branches let you work on new features or fixes **without touching** the main, stable version of your project.

### Create a new branch
```bash
git branch dev
```

### Switch to that branch
```bash
git switch dev
```
> Note: `git switch` is the newer, recommended replacement for the older `git checkout` command.

### Do your work, then commit as usual
```bash
git add .
git commit -m "Add new feature"
```

### Merge your branch back into main
First switch back to main:
```bash
git switch main
```
Then merge:
```bash
git merge dev
```
This brings all the changes from `dev` into `main`.

**Why this matters:** This mirrors real-world software development (the SDLC — Software Development Life Cycle): you develop in a separate branch, test/review it, and only merge into `main` (production-ready code) once it's confirmed to work.

---

## 6. Syncing with Remote

Keeping your local project updated with the remote (GitHub) version:

```bash
git fetch
```
Downloads the latest information about remote branches **without** merging anything into your local files yet.

```bash
git pull
```
Fetches **and** merges the latest remote changes into your current branch.

```bash
git push
```
Uploads your local commits to the remote repository.

---

## 7. Best Practices

✅ Use **descriptive commit messages** — future you (and teammates) will thank you.
✅ Commit often, in small logical chunks, rather than one giant commit.
✅ Always work in a **feature branch**, not directly on `main`.
✅ Keep `.gitignore` updated so junk files never get pushed.
✅ Run `git status` frequently to stay aware of your current changes.
✅ Pull the latest changes (`git pull`) before starting new work, to avoid conflicts.

---

## 8. Building a Git Portfolio

- Push **every project and class assignment** to your own GitHub, even small ones.
- A well-maintained GitHub profile with regular commits shows employers you're comfortable with real-world version control.
- It doubles as a **live resume** — recruiters and hiring managers often check GitHub activity.

---

## 9. Quick Command Cheat Sheet

| Command | What it does |
|---|---|
| `ssh-keygen -t ed25519 -C "email"` | Generate a new SSH key |
| `ssh -T git@github.com` | Test SSH connection to GitHub |
| `git clone <url>` | Download a copy of a remote repo |
| `git status` | Show current changes |
| `git add .` | Stage all changes |
| `git add <file>` | Stage a specific file |
| `git commit -m "message"` | Save staged changes with a message |
| `git push` | Upload commits to remote |
| `git pull` | Download + merge remote changes |
| `git fetch` | Download remote info only (no merge) |
| `git branch <name>` | Create a new branch |
| `git switch <name>` | Switch to a branch |
| `git merge <name>` | Merge a branch into the current one |

---

*Guide compiled from lecture notes on Git version control and branch management workflow.*