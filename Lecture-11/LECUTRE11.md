# Automating Python Installation & Python Scripting Basics for DevOps

## Overview

This session covers two main areas:

1. Automating Python installation across multiple systems using Bash scripting.
2. Introducing core Python scripting concepts as a foundation for DevOps automation work.

Automating environment setup is important in DevOps because it ensures consistency across machines, reduces manual errors, and saves time — especially in teams with frequent hardware changes or many systems to provision.

---

## Part 1: Automating Python Installation

### Goal
Write a Bash script that installs Python 3 and pip, and configures the system so `python` can be used instead of `python3`.

### Script Steps
1. **Update system packages**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```
2. **Install Python 3 and pip**
   ```bash
   sudo apt install python3 python3-pip -y
   ```
3. **Configure `update-alternatives`**
   Creates a symlink/alias so `python` points to `python3`:
   ```bash
   sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
   ```
   - Avoids version conflicts and shortens the command from `python3` to `python`.
   - Priority levels allow multiple versions to be managed cleanly.

### Why It Matters
- Removes manual, repetitive setup steps.
- Ensures every machine has an identical, predictable environment.
- Speeds up onboarding and keeps builds consistent across the team.

---

## Part 2: Python Scripting Basics

### Topics Covered
- File creation and running `.py` scripts
- Variable declarations
- Handling user input (with type casting, e.g. `int(input(...))`, to ensure data integrity)
- Conditionals (`if` / `else`)
- Loops
- Data structures:
  - **Lists (arrays)** — simple collections, e.g. attendance counts per day
  - **Dictionaries (objects)** — key-value pairs for richer, structured data, e.g. pairing an attendance date with its count

### Python vs. Bash
- Python offers more readable, less verbose syntax for control flow than Bash.
- Python is lightweight by design: functionality comes from **explicitly imported libraries** rather than being bundled in by default.
  - Example: `import sys` then `sys.exit()` to exit a script programmatically based on a condition.

### Example Use Case: Attendance Tracking
Used to demonstrate the practical difference between lists and dictionaries:
- A **list** works for a simple sequence of values (e.g., daily counts).
- A **dictionary** is needed once you must associate extra context with each value (e.g., date + count together).

---

## Part 3: JSON & YAML for Cloud/DevOps

- **JSON** — commonly used for logs and data interchange.
- **YAML** — commonly used for configuration files.
- Both formats are foundational because tools like **Kubernetes**, **Ansible**, and **Terraform** rely heavily on them for configuration and infrastructure definitions.

---

## Suggested Learning Roadmap

1. Python scripting fundamentals (this session)
2. Git / version control
3. Cloud deployment basics
4. CI/CD pipelines
5. Terraform (Infrastructure as Code)
6. Ansible (Configuration management/automation)

The roadmap is designed to build skills incrementally, moving from scripting fundamentals to full DevOps tooling, with an emphasis on hands-on practice at each stage.

---

## Key Takeaways
- Automate repetitive setup tasks wherever possible — it pays off at scale.
- `update-alternatives` is a clean way to manage command aliases and multiple tool versions.
- Python's readability and modular import system make it well suited for DevOps scripting.
- Understanding data structures (lists vs. dictionaries) is essential before working with JSON/YAML configs.
- JSON/YAML literacy is a prerequisite for most modern cloud-native and IaC tooling.