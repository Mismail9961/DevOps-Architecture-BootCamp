# Lecture 4: Introduction to Unix Shells and Basic Scripting

This lecture document covers the fundamentals of Unix shells, architectural concepts, command-line verification, and complete, beginner-friendly Bash scripting implementations.

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
* **Origin:** Developed by Stephen Bourne at Bell Labs in 1979 for Unix Research Version 7.
* **Core Characteristics:** Minimalist design with a strict, lightweight footprint.
* **Primary Role:** It established the foundational syntax for POSIX-compliant scripting. It lacks modern interactive features and is primarily utilized today for legacy systems or lightweight container environments.

### B. bash (Bourne Again Shell)
* **Origin:** Created by Brian Fox for the GNU Project in 1989 as a free software replacement for `sh`.
* **Core Characteristics:** Retains backward compatibility with `sh` while adding substantial interactive enhancements.
* **Primary Role:** Incorporates command history navigation, basic tab-completion, and advanced scripting constructs. It serves as the default shell for the majority of Linux distributions.

### C. zsh (Z Shell)
* **Origin:** Released by Paul Falstad in 1990, designed to extend the capabilities of `bash`, `ksh`, and `tcsh`.
* **Core Characteristics:** Highly programmable with native support for advanced completion systems, spelling correction, and expandable themes or frameworks.
* **Primary Role:** Optimized for developer productivity and interactive usage. It is the default interactive shell on modern macOS installations.

---

## 3. Comparative Analysis Matrix

| Feature | sh | bash | zsh |
| :--- | :--- | :--- | :--- |
| **Origin** | Original Unix shell | GNU enhanced shell | Advanced modern shell |
| **Compatibility** | Baseline standard (POSIX) | High (supports `sh` syntax) | Mostly bash-compatible |
| **Feature Set** | Minimal | Moderate | Highly rich / Extended |
| **Scripting Use Case** | Maximally portable scripts | Most common scripting standard | Less used for shared scripts |
| **Auto-completion** | Basic to none | Good standard completion | Advanced interactive menus |
| **Customization** | None | Limited | Extensive (plugins/themes) |
| **Default System Status**| Rare as default login shell | Default on most Linux distros | Default on macOS (Catalina+) |

---

## 4. Environment Verification and Commands

To inspect and verify shell environments within a running terminal session, specific environment variables and execution parameters are queried:

### Checking the Default Login Shell
The `$SHELL` environment variable stores the absolute path of the user's default login shell.
```bash
echo $SHELL
```
* **Output Example (macOS):** `/bin/zsh`
* **Output Example (Linux):** `/bin/bash`

### Checking the Actively Running Shell Process
To determine the precise shell instance currently executing commands in the active foreground process, query the positional parameter `0`:
```bash
echo $0
```

---

## 5. Understanding the "$" Operator in Shell Scripting

In shell scripting, the `$` symbol is a special character used for **Variable Expansion** or **Evaluation**. It instructs the shell interpreter to retrieve the value stored inside a variable rather than treating the variable name as literal text.

* **Variable Assignment (No `$`)**: Variables are defined by setting a name equal to a value without spaces or symbols.
  ```bash
  welcome="Welcome to SMIT"
  ```
* **Variable Reference (Requires `$`)**: To read or print that data, the variable name must be prefixed with the `$` symbol.
  ```bash
  echo $welcome
  ```
* **Positional Parameters (`$1`, `$2`, etc.)**: When a number follows the `$`, it represents arguments passed into the script directly from the terminal. `$1` reads the first parameter, `$2` reads the second parameter, and so on.

---

## 6. Full plain-text script templates from source materials

### Script template 1: Parameter-driven greeting application
```bash
# Shell for executing script
#!/bin/bash

welcome="Welcome to SMIT"
std_name=$1

# echo "Please enter your name."
# read std_name

echo "Hello $std_name! $welcome"
```

### Script template 2: Interactive answer extraction with syntax errors fixed
```bash
std_ans=""

echo "Q1: When was pakistan founded?"
echo "A) 1941"
echo "B) 1947"
echo "C) 1957"
echo "D) 1937"
read std_ans

echo "Your ans: $std_ans"
```

### Script template 3: Conditional response checking with static evaluation values
```bash
echo "C) 1957"
echo "D) 1937"
read std_ans

if [[ "$std_ans" == "$crt_ans" ]]; then
    echo "Your ans is correct"
    echo "Your ans: $std_ans"
else
    echo "Your ans is incorrect"
    echo "Correct ans is $crt_ans"
fi
```

### Script template 4: Integrated script incorporating uppercase serialization mechanisms
```bash
echo "A) 1941"
echo "B) 1947"
echo "C) 1957"
echo "D) 1937"
read std_ans

std_ans=${std_ans^^}

if [[ "$std_ans" == "$crt_ans" ]]; then
    echo "Your ans is correct"
    echo "Your ans: $std_ans"
else
    echo "Your ans is incorrect"
    echo "Correct ans is $crt_ans"
fi
```