# Lecture 2: Linux Basics (Beginner Friendly Notes)

## Overview

This lecture introduces fundamental Linux commands used for file management, text editing, navigation, and basic networking. It focuses on practical usage for beginners.

---

## 1. Linux Commands and Nano Editor (00:00:36 - 00:10:14)

In this section, basic Linux commands and the Nano text editor are introduced.

### Key Commands Covered

* `ls` → Lists files and folders in the current directory
* `chmod` → Changes file permissions
* `mkdir` → Creates a new directory
* `touch` → Creates a new empty file

### Nano Editor

* Nano is a simple terminal-based text editor (similar to Notepad in Windows)
* Used to create and edit files directly in the terminal

### Saving in Nano

* Press `Ctrl + X` to exit
* Press `Y` to confirm saving changes
* Press `Enter` to save the file

### Viewing Files

* `cat filename` → Displays file content directly in the terminal without opening an editor

---

## 2. echo, clear, and history (00:10:14 - 00:18:11)

### echo Command

* Prints text in the terminal
* Example: `echo Hello`

### Writing to Files

* `>` → Writes content to a file (overwrites existing content)
* `>>` → Appends content to a file (keeps existing content)

### clear Command

* Clears the terminal screen for better readability

---

## 3. Nano vs VI Editor + File Viewing (00:18:11 - 00:34:30)

### Nano vs VI

* Nano: Simple and beginner-friendly
* VI: Advanced editor with more features but harder to use

### VI Basics

* Press `i` → Enter insert mode
* Press `Esc` → Exit insert mode
* `:wq` → Save and exit
* `:q!` → Exit without saving

### File Viewing Commands

* `head filename` → Shows top lines of a file
* `tail filename` → Shows bottom lines of a file
* You can specify number of lines to display

### Copy/Paste in Linux Terminal

* Copy: `Ctrl + Shift + C`
* Paste: `Ctrl + Shift + V`

---

## 4. Copying and Moving Files (00:34:30 - 00:46:13)

### touch in folders

* Files can be created inside folders without navigating into them

### cp Command

* Used to copy files
* Format: `cp source destination`

### Folder Management

* You can copy files into folders directly
* Useful when organizing multiple files

---

## 5. Copying Directories (Recursive Copy) (00:46:13 - 00:55:54)

### Recursive Copy

* Use `cp -r` or `cp -R` to copy folders
* Copies everything inside the folder including subfolders

### File Path Symbols

* `.` → Current directory
* `..` → Parent directory
* `~` → Home directory

### Moving Directories

* Use `mv` command
* Also requires `-r` for full directory handling in some cases

---

## 6. File and Folder Management (00:55:54 - 01:09:04)

### man Command

* Shows manual/help for any command
* Example: `man ls`

### rm Command

* Deletes files: `rm filename`
* Deletes folders: `rm -r foldername`

### find Command

* Searches for files or folders
* Example: `find /path -name filename`
* To search only files: `find /path -type f`

---

## 7. IP Address and Networking Basics (01:09:04 - 01:17:43)

### File Copy Example

* Demonstrates copying files between folders using `cp`

### IP Address Commands

* `ip a` → Shows network interfaces and IP addresses
* `ip addr` → Same output in a more detailed format

### Example IP

* Local system IP shown: `192.168.49.221`

---

## Summary

This lecture covered essential Linux commands for beginners:

* File creation, editing, and viewing
* Text editors (Nano vs VI)
* File copying and moving
* Directory management
* Searching files
* Network/IP basics

These are foundational skills for Linux and DevOps workflows.
