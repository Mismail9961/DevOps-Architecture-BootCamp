# Lecture 23 — IPv4 Networking & Subnetting Fundamentals

> **Topic:** IPv4 Addressing, Subnetting, and Network Design for Cloud Infrastructure (AWS-relevant)

---

## 📌 Overview

This lecture builds the foundation of networking knowledge required for cloud infrastructure work. It covers how IPv4 addresses are structured, why subnetting exists, how organizations design their IP address space, and how these concepts map directly onto real cloud environments like AWS.

---

## 🗂️ Table of Contents

1. [What is Networking?](#what-is-networking)
2. [IPv4 Address Structure](#ipv4-address-structure)
3. [Public vs Private IPs & NAT](#public-vs-private-ips--nat)
4. [Subnetting Basics](#subnetting-basics)
5. [CIDR Notation & Usable IP Calculation](#cidr-notation--usable-ip-calculation)
6. [Organizational Network Design](#organizational-network-design)
7. [Network & Broadcast Addresses](#network--broadcast-addresses)
8. [⭐ Important Points to Remember](#-important-points-to-remember)
9. [Key Formulas Cheat Sheet](#key-formulas-cheat-sheet)
10. [Conclusion](#conclusion)

---

## What is Networking?

- Networking is any **medium that enables communication between devices**.
- It is the **backbone of all IT infrastructure** — cloud services are built on top of networking fundamentals.
- Understanding networking is essential before diving into cloud infrastructure (e.g., AWS VPCs, subnets, routing).

---

## IPv4 Address Structure

- An IPv4 address is a **32-bit number**, divided into **4 octets** (8 bits each).
- Each octet ranges from **0 to 255**.
  - Why 255? Because $2^8 = 256$ possible values, but counting starts from **0**, so the range is 0–255.
- Total address space: $2^{32}$ ≈ **4.3 billion addresses**.

**Example:** `192.168.1.1` → four octets separated by dots, each representing 8 bits.

---

## Public vs Private IPs & NAT

| Type | Assigned By | Scope |
|------|-------------|-------|
| **Public IP** | ISP | Unique across the entire internet |
| **Private IP** | Router (local network) | Reusable across different local networks (e.g., `192.168.x.x`) |

- **NAT (Network Address Translation)** allows multiple devices with private IPs to share **one public IP** to access the internet.
- Benefits of NAT:
  - Conserves scarce public IPv4 addresses.
  - Adds a layer of **security** by hiding internal device IPs from the public internet.

---

## Subnetting Basics

- **Subnetting** = dividing a large IP address block into smaller, manageable sub-networks.
- Purpose: efficient IP allocation, better organization, and controlled broadcast domains.
- Achieved using **subnet masks** or **CIDR (slash) notation**.

---

## CIDR Notation & Usable IP Calculation

- CIDR notation (e.g., `/24`) indicates how many bits are reserved for the **network portion** of the address; remaining bits are for **hosts**.
- **Total IPs in a subnet:** $2^{32-n}$
- **Usable IPs in a subnet:** $2^{32-n} - 2$ (subtracting the network address and broadcast address)

**Example (/24 subnet):**
- Total IPs = $2^{32-24} = 2^8 = 256$
- Usable IPs = $256 - 2 = 254$

---

## Organizational Network Design

Large organizations divide their IP address space hierarchically across environments:

- 🛠️ **Management**
- 💻 **Development**
- 🧪 **Testing / UAT**
- 🚀 **Production**
- 🆘 **Disaster Recovery (DR)**

**Best practices covered:**
- Reserve **gaps/blocks** between environment subnets for **future expansion**.
- Avoid over-allocating or under-allocating IP ranges — size subnets based on actual/projected need.
- Plan proactively to avoid re-architecting the network later.

---

## Network & Broadcast Addresses

Every subnet reserves **2 addresses** that cannot be assigned to hosts:

| Reserved Address | Purpose |
|-------------------|---------|
| **First IP** | Network address (identifies the subnet itself) |
| **Last IP** | Broadcast address (used to communicate with all hosts in the subnet) |

➡️ This is why a `/24` subnet with 256 total addresses only provides **254 usable host IPs**.

---

## ⭐ Important Points to Remember

- ✅ IPv4 = 32 bits = 4 octets × 8 bits, each octet ranges **0–255**.
- ✅ Total IPv4 address space ≈ **4.3 billion**, but exhaustion is a real problem due to device proliferation.
- ✅ **Private IP ranges are reused globally** — they only need to be unique *within* a local network.
- ✅ **NAT** is the mechanism that lets private IPs share a public IP for internet access.
- ✅ **Subnetting formula:** Usable Hosts = $2^{32-n} - 2$
- ✅ Always reserve the **first (network)** and **last (broadcast)** address of every subnet.
- ✅ Organizations subnet by **environment** (Mgmt, Dev, Test, Prod, DR) for security and manageability.
- ✅ **Leave room for future growth** when planning subnet ranges — don't allocate every last IP immediately.
- ✅ These concepts directly translate into **AWS VPC/subnet design** (and other cloud providers).

---

## Key Formulas Cheat Sheet

| Concept | Formula |
|---------|---------|
| Total IPv4 addresses | $2^{32}$ |
| Values per octet | $2^8 = 256$ (range: 0–255) |
| Total IPs in a subnet (`/n`) | $2^{32-n}$ |
| Usable IPs in a subnet | $2^{32-n} - 2$ |
| `/24` subnet usable hosts | $254$ |

---

## Conclusion

This lecture ties together the theory of IPv4 addressing with practical subnetting and organizational network design — skills that are directly applicable when designing and managing **cloud network topologies** such as AWS VPCs. A solid grasp of binary structure, NAT, CIDR notation, and reserved addresses is essential for any cloud/infrastructure engineer.

---

*README generated from Lecture 23 notes — IPv4 Networking Fundamentals and Subnetting in Cloud Infrastructure.*