# Lecture 4: Introduction to Unix Shells

This lecture document covers the fundamentals, comparison, and verification of Unix shells based on core command-line architectural concepts.

---

## 1. Definition and Purpose of a Shell

A **shell** is a command-line interpreter that acts as an interface between the user and the operating system kernel. It reads commands typed by the user into a terminal emulator, parses them, and passes them to the operating system for execution.

### Primary Functions:
* **Command Execution:** Launching applications, utilities, and system binaries.
* **File System Navigation:** Providing built-in commands to traverse and manipulate directories and files.
* **Automation:** Executing sequences of commands saved in plain text files, known as shell scripting.

---

## 2. Core Shell Profiles

### A. sh (Bourne Shell)
* **Origin:** Developed by Stephen Bourne at Bell Labs in 1979 for Unix Research Version 7[cite: 1].
* **Core Characteristics:** Minimalist design with a strict, lightweight footprint[cite: 1].
* **Primary Role:** It established the foundational syntax for POSIX-compliant scripting[cite: 1]. It lacks modern interactive features and is primarily utilized today for legacy systems or lightweight container environments[cite: 1].

### B. bash (Bourne Again Shell)
* **Origin:** Created by Brian Fox for the GNU Project in 1989 as a free software replacement for `sh`[cite: 1].
* **Core Characteristics:** Retains backward compatibility with `sh` while adding substantial interactive enhancements[cite: 1].
* **Primary Role:** Incorporates command history navigation, basic tab-completion, and advanced scripting constructs[cite: 1]. It serves as the default shell for the majority of Linux distributions[cite: 1].

### C. zsh (Z Shell)
* **Origin:** Released by Paul Falstad in 1990, designed to extend the capabilities of `bash`, `ksh`, and `tcsh`[cite: 1].
* **Core Characteristics:** Highly programmable with native support for advanced completion systems, spelling correction, and expandable themes or frameworks[cite: 1].
* **Primary Role:** Optimized for developer productivity and interactive usage[cite: 1]. It is the default interactive shell on modern macOS installations[cite: 1].

---

## 3. Comparative Analysis Matrix

| Feature | sh | bash | zsh |
| :--- | :--- | :--- | :--- |
| **Origin** | Original Unix shell[cite: 1] | GNU enhanced shell[cite: 1] | Advanced modern shell[cite: 1] |
| **Compatibility** | Baseline standard (POSIX)[cite: 1] | High (supports `sh` syntax)[cite: 1] | Mostly bash-compatible[cite: 1] |
| **Feature Set** | Minimal[cite: 1] | Moderate[cite: 1] | Highly rich / Extended[cite: 1] |
| **Scripting Use Case** | Maximally portable scripts[cite: 1] | Most common scripting standard[cite: 1] | Less used for shared scripts[cite: 1] |
| **Auto-completion** | Basic to none[cite: 1] | Good standard completion[cite: 1] | Advanced interactive menus[cite: 1] |
| **Customization** | None[cite: 1] | Limited[cite: 1] | Extensive (plugins/themes)[cite: 1] |
| **Default System Status**| Rare as default login shell[cite: 1] | Default on most Linux distros[cite: 1] | Default on macOS (Catalina+)[cite: 1] |

---

## 4. Environment Verification and Commands

To inspect and verify shell environments within a running terminal session, specific environment variables and execution parameters are queried:

### Checking the Default Login Shell
The `$SHELL` environment variable stores the absolute path of the user's default login shell[cite: 1].
```bash
echo $SHELL