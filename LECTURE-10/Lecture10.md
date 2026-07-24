# Linux User & Group Management — Study Notes

Notes from: *Comprehensive Guide to Linux User and Group Management with File Permissions and Automation*
Video: https://www.youtube.com/watch?v=PbB2Sh5YSUg

## Overview

This video covers Linux user/group administration — from the config files that store user data, to the commands used to manage users and groups, to real-world practices like permission management and log file lifecycle automation.

---

## 1. Key System Files

| File | Purpose |
|---|---|
| `/etc/passwd` | Stores username, UID, GID, home directory, default shell (plain text, **no passwords**) |
| `/etc/shadow` | Stores **encrypted** passwords, restricted access |
| `/etc/group` | Stores group names and membership |

---

## 2. System Users vs. Regular Users

- **System/service users**: UID/GID typically `1–999`, usually no interactive login shell (e.g., accounts for nginx, databases)
- **Regular users**: UID starts at `1000+`, have home directories and real shell access
- This separation prevents unauthorized/accidental interactive access to service accounts

---

## 3. Core Commands

### User Management
```bash
useradd -m -s /bin/bash username   # create user with home dir + shell
usermod -aG groupname username     # ADD user to a group (keeps existing groups)
userdel -r username                # delete user + home directory
passwd username                    # set/reset password
```

> ⚠️ **Gotcha:** Always use `-a` with `-G` in `usermod`. Without it, the user's existing group memberships get overwritten instead of appended to.

### Group Management
```bash
groupadd groupname
groupmod -n newname oldname
groupdel groupname
```

---

## 4. File Permissions & Shared Directories

- Don't store shared application files inside individual users' home directories — causes clutter and permission conflicts.
- Instead: create a centralized directory, owned by `root`, assigned to a project group.

```bash
mkdir /opt/project
chgrp devs /opt/project
chmod 775 /opt/project
```

This gives group members (`devs`) full read/write/execute access while restricting others.

---

## 5. Log File Management & Storage Optimization

- Services like Nginx generate logs that grow over time and can exhaust disk space.
- **Best practice:** archive, don't delete — preserves data for audits/compliance.
- Move older logs from expensive block storage (e.g., AWS EBS) to cheap long-term object storage (e.g., AWS S3 Glacier) — cited savings of roughly ~80%.
- Automate this via scripts or cron jobs rather than doing it manually.

---

## 6. Automation Mindset

Recurring theme throughout: routine admin tasks (user creation, permission setup, log rotation/archiving) should be **scripted**, not done manually — reduces human error and improves consistency at scale.

---

## Next in Series

The course moves on to **Linux networking** topics next.

---

## Practice Checklist

- [ ] Create a new user with a home directory and bash shell
- [ ] Set a password for that user
- [ ] Create a group and add the user to it using `-aG`
- [ ] Create a shared directory owned by root, grouped to your new group, with `chmod 775`
- [ ] Write a simple bash/cron script that archives log files older than N days
- [ ] (Optional/cloud) Simulate moving archived logs to "cold storage" by moving them to a separate folder representing S3 Glacier