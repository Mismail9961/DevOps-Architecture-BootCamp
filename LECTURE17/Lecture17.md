# Git & GitHub Setup Guide

A practical guide to source code management (SCM) with Git and GitHub — covering why version control matters, how it fits into the software development life cycle (SDLC), and step-by-step instructions for authenticating with SSH.

## Table of Contents

- [Why Version Control](#why-version-control)
- [Git vs. GitHub](#git-vs-github)
- [Git Branching & the SDLC](#git-branching--the-sdlc)
- [SSH Authentication Setup](#ssh-authentication-setup)
- [GitHub Repository Basics](#github-repository-basics)
- [Everyday Git Commands](#everyday-git-commands)

## Why Version Control

When multiple developers work on different parts of the same project — front-end, back-end, database, scripting — manual code sharing (USB drives, email, chat attachments) quickly breaks down. Git solves this by giving a team:

- **Version tracking** — every change is recorded with a timestamp and author
- **Branching** — isolated lines of development that can be merged back together
- **History** — the ability to review, compare, or revert any past change

This matters in practice: if an update introduces a bug, a previous stable commit can be restored instead of trying to manually undo changes.

## Git vs. GitHub

Git and GitHub are not the same thing:

| | What it is |
|---|---|
| **Git** | The version control tool itself — runs locally, tracks changes, manages branches |
| **GitHub** (or GitLab, Bitbucket) | A hosting platform for Git repositories — adds collaboration tools, access control, issue tracking, and a web UI |

Think of it like cloud providers (AWS, Azure, GCP) offering similar core infrastructure with different ecosystems on top — Git is the infrastructure, GitHub is one provider built on it.

## Git Branching & the SDLC

Git branches typically map to stages of the Software Development Life Cycle:

```
dev → test/SIT → QA → UAT → pre-production (beta) → production → disaster recovery (DR)
```

Keeping each stage on its own branch prevents unstable or incomplete code from reaching production, supports structured testing, and makes rollbacks straightforward.

## SSH Authentication Setup

SSH keys let you push and pull from GitHub without typing a password every time, and are more secure than HTTPS with saved credentials.

### 1. Check for an existing SSH key

```bash
ls -al ~/.ssh
```

If you see `id_rsa` and `id_rsa.pub`, you already have a key pair and can skip to step 4.

### 2. Generate a new SSH key (if needed)

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Press Enter to accept the default save location. You can optionally set a passphrase for extra security.

### 3. Start the SSH agent and add your key

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

### 4. Copy your public key to your Git provider

```bash
cat ~/.ssh/id_rsa.pub
```

Copy the output, then add it under:

- **GitHub:** Settings → SSH and GPG keys → New SSH key
- **GitLab:** Settings → SSH Keys → Add new key
- **Bitbucket:** Personal settings → SSH keys → Add key

### 5. Test the connection

```bash
# GitHub
ssh -T git@github.com

# GitLab
ssh -T git@gitlab.com

# Bitbucket
ssh -T git@bitbucket.org
```

A successful connection returns something like:

```
Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.
```

### 6. Configure your Git identity

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

This information is attached to every commit you make.

### 7. Clone a repository using SSH

```bash
git clone git@github.com:your-username/your-repo.git
```

## GitHub Repository Basics

When creating a repository on GitHub:

- **Visibility** — Public (anyone can view) or Private (access limited to owners/collaborators)
- **README** — recommended for every repo; describes what the project does and how to use it
- **License** — defines how others may use, modify, or distribute your code
- **Access control** — repo owners can add collaborators with read or write access

## Everyday Git Commands

```bash
git status                 # see what's changed
git add <file>              # stage a file
git commit -m "message"     # commit staged changes
git push origin <branch>    # push to remote
git pull origin <branch>    # pull latest changes
git branch <name>           # create a new branch
git checkout <branch>       # switch branches
git merge <branch>          # merge a branch into the current one
git log                     # view commit history
```

---

**Tip:** Keep commit messages short and specific (e.g. `fix: correct null check in user auth`), and commit often rather than bundling many unrelated changes into one commit.