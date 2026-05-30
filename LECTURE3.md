# Lecture 3 - Linux Commands and System Directories

## Overview

In this lecture, we explore important Linux directories, package management commands, process monitoring tools, and system information utilities. These commands are essential for understanding how Linux systems are structured and managed.

---

## 1. `ls -l /etc`

### Command

```bash
ls -l /etc
```

### Meaning

Displays a detailed (long format) listing of all files and directories inside `/etc`.

### What is `/etc`?

* `/etc` stores **system configuration files**.
* These files control system-wide settings and services.

### Examples of contents

* `hosts` → hostname/IP mappings
* `passwd` → user account information
* `ssh/` → SSH configuration files

### Output Explanation

Each line contains:

* File permissions
* Number of links
* Owner
* Group
* File size
* Last modified date
* File name

---

## 2. `ls -l /opt`

### Command

```bash
ls -l /opt
```

### Meaning

Shows detailed contents of `/opt` directory.

### What is `/opt`?

* Used for **optional or third-party software**.
* Applications installed manually or outside package manager often go here.

### Example contents

* `google/`
* `vscode/`
* `tomcat/`

### Purpose

Keeps external software separate from system-managed files.

---

## 3. `ls -l /var`

### Command

```bash
ls -l /var
```

### Meaning

Lists variable data files in long format.

### What is `/var`?

* Contains files that **change frequently** during system operation.

### Important subdirectories

* `/var/log` → system logs
* `/var/cache` → cached data
* `/var/tmp` → temporary files
* `/var/lib` → application data
* `/var/www` → web server files

### Purpose

Stores runtime data like logs, caches, and queues.

---

## 4. `ls /usr`

### Command

```bash
ls /usr
```

### Meaning

Lists directories inside `/usr`.

### What is `/usr`?

* Contains **user-level programs and libraries**.
* Not user home directories.

### Common subdirectories

* `/usr/bin` → user commands (ls, cp, mv)
* `/usr/sbin` → system admin commands
* `/usr/lib` → libraries
* `/usr/share` → shared resources
* `/usr/local` → locally installed software

---

## 5. `ls /bin`

### Command

```bash
ls /bin
```

### Meaning

Lists essential system binaries.

### What is `/bin`?

* Contains **basic system commands required for boot and recovery**.

### Examples

* `ls`
* `cp`
* `mv`
* `rm`
* `cat`

### Difference from `/usr/bin`

* `/bin` → essential commands
* `/usr/bin` → additional user applications

---

## 6. `ls /proc`

### Command

```bash
ls /proc
```

### Meaning

Lists virtual system and process information.

### What is `/proc`?

* A **virtual filesystem created by the kernel**.
* Exists in memory, not on disk.

### Contents

1. Process directories (PID-based)

   * `/proc/1`, `/proc/2345`
2. System information files

   * `/proc/cpuinfo`
   * `/proc/meminfo`
   * `/proc/uptime`

### Purpose

Provides real-time system information.

---

## 7. `systemctl status docker`

### Command

```bash
systemctl status docker
```

### Meaning

Checks the status of Docker service.

### What is `systemctl`?

* A tool to manage Linux services using `systemd`.

### Common Docker service commands

```bash
systemctl start docker
systemctl stop docker
systemctl restart docker
systemctl enable docker
systemctl status docker
```

### Purpose

Manage background services like Docker.

---

## 8. `sudo apt upgrade`

### Command

```bash
sudo apt upgrade
```

### Meaning

Upgrades all installed packages to latest versions.

### Steps involved

1. Checks available updates
2. Downloads updated packages
3. Installs them

### Important note

* Does NOT remove or install new dependencies automatically.

### Recommended flow

```bash
sudo apt update
sudo apt upgrade
```

---

## 9. `sudo apt autoremove`

### Command

```bash
sudo apt autoremove
```

### Meaning

Removes unused dependencies from the system.

### Why needed?

When software is removed, leftover dependencies may remain.

### Example

* Install VLC → installs dependencies
* Remove VLC → dependencies may remain
* `autoremove` cleans them

### Safe usage

APT ensures system-critical packages are not removed.

---

## 10. `apt list`

### Command

```bash
apt list
```

### Meaning

Lists available packages in repository.

### Useful variations

```bash
apt list --installed
apt list --upgradable
```

### Purpose

* Check installed packages
* Check updates
* Explore package names

---

## 11. `cat /proc/uptime`

### Command

```bash
cat /proc/uptime
```

### Meaning

Displays system uptime and idle time.

### Output example

```
12345.67 54321.89
```

### Explanation

* First value → system uptime in seconds
* Second value → total CPU idle time

### Alternative command

```bash
uptime
```

---

## 12. `top`

### Command

```bash
top
```

### Meaning

Displays real-time system process monitoring.

### Information shown

* Running processes
* CPU usage
* Memory usage
* System load

### Key fields

* PID → process ID
* USER → process owner
* %CPU → CPU usage
* %MEM → memory usage
* COMMAND → process name

### Useful keys inside top

* q → quit
* k → kill process
* P → sort by CPU
* M → sort by memory

### Purpose

Acts as a Linux task manager.

---

## Conclusion

These commands provide a strong foundation for Linux system understanding:

* `/etc`, `/var`, `/opt`, `/usr`, `/bin` → system structure
* `/proc` → live system information
* `systemctl` → service management
* `apt` → package management
* `top` → process monitoring
* `uptime` → system status

Mastering these commands helps in system administration, debugging, and backend development environments.
