# Lecture 26: Cloud Storage Types and EC2 Setup in AWS

## Overview

This lecture builds on earlier networking concepts and moves into cloud storage fundamentals and hands-on AWS EC2 (Elastic Compute Cloud) configuration. It covers the three primary storage types used in cloud computing, how AWS maps each type to a specific service, how to create and manage EC2 storage volumes, how to securely connect to a Linux virtual machine using SSH, how Amazon Machine Images (AMIs) are used to launch virtual machines, and how AWS Security Groups control network access to instances.

---

## 1. Recap: Networking as the Foundation

Before storage can be discussed meaningfully, networking is treated as the base infrastructure layer that provides connectivity between systems. Storage is the next layer built on top of this, since virtual machines and applications need a place to persist data once they can communicate over a network.

---

## 2. Cloud Storage Types

There are three core storage types used across cloud platforms. Each is suited to a different kind of workload.

### 2.1 Block Storage

**Definition:** Block storage divides data into fixed-size chunks called "blocks," each identified by a unique address (similar to a sector on a physical hard disk). The operating system treats these blocks the way it would treat a raw physical disk.

**Key characteristics:**
- Behaves like a traditional hard drive attached to a machine.
- Supports installing and running an operating system directly on it.
- Provides low-latency, high-performance read/write access.
- Data has no inherent structure or metadata at the storage level; the OS/filesystem imposes structure.

**AWS Service:** Elastic Block Store (EBS) — used to provide persistent, attachable storage volumes for EC2 instances. This is essential for stateful applications and OS boot volumes.

### 2.2 Object Storage

**Definition:** Object storage manages data as discrete "objects," each bundled with metadata (such as creation date, owner, and format) and identified by a unique ID rather than a physical address.

**Key characteristics:**
- Ideal for unstructured data such as images, videos, backups, and logs.
- Highly scalable and typically "eventually consistent" (updates may take a short time to propagate across the system).
- Cannot be used to boot an operating system directly (unlike block storage).
- Comparable to consumer file-sharing services such as Google Drive, but designed for massive scale.

**AWS Service:** Simple Storage Service (S3) — a bucket-based object storage service for storing and retrieving large amounts of unstructured data.

### 2.3 File Storage

**Definition:** File storage organizes data in a traditional hierarchical directory/folder structure familiar to most users, similar to file systems on a personal computer or enterprise file server.

**Key characteristics:**
- Supports network file shares that multiple users or systems can access simultaneously.
- Preserves familiar folder/subfolder organization.
- Commonly used in enterprise environments needing a standard file system interface across multiple servers.

**AWS Services:** Elastic File System (EFS) and FSx — managed file storage systems designed for shared access across multiple EC2 instances or on-premises systems.

### Summary Table

| Storage Type | Data Unit | Structure | Typical Use Case | AWS Service |
|---|---|---|---|---|
| Block Storage | Fixed-size blocks | None (raw, address-based) | OS boot volumes, databases | EBS |
| Object Storage | Objects + metadata | Flat, ID-based | Backups, media, unstructured data | S3 |
| File Storage | Files/folders | Hierarchical directory tree | Shared network drives | EFS / FSx |

---

## 3. EC2 Storage Volumes (Practical Implementation)

Within EC2, volumes (backed by EBS) can be created and attached to virtual machine instances. Important considerations include:

- **Volume Types and Performance Tiers:**
  - **General Purpose SSD (GP3):** Balanced price and performance, suitable for most general workloads.
  - **Provisioned IOPS SSD:** Higher, guaranteed performance for I/O-intensive workloads (e.g., databases), at higher cost.
  - **Magnetic (HDD-based):** Lower cost, lower performance, suitable for infrequent access or archival workloads.

- **Sizing:** Volumes are provisioned with a defined size (in GB) chosen based on the expected workload and storage needs.

- **IOPS and Throughput:** These determine how fast data can be read from or written to the volume. IOPS (Input/Output Operations Per Second) and throughput (data transfer rate) are tunable depending on the volume type and workload requirements.

- **Snapshots (Backups):** A snapshot is a point-in-time backup of an EBS volume. Snapshots can be taken manually or automated on a schedule, allowing quick recovery in case of data loss or corruption. Regular snapshot policies are considered an essential part of enterprise data management and disaster recovery strategy.

---

## 4. Remote Access to Linux EC2 Instances via SSH

**SSH (Secure Shell)** is the standard protocol used to remotely and securely manage Linux-based EC2 instances.

- **Port:** SSH operates by default over **port 22**.
- **Model:** SSH follows a client-server model — the client (the user's machine) initiates a connection request, and the server (the EC2 instance) accepts or rejects it based on configured rules and authentication.

### 4.1 Authentication: Public-Private Key Pairs

Rather than relying on password-based login (which is vulnerable to brute-force attacks), SSH access to EC2 instances uses **public-private key pair authentication**:

- **Public Key:** Uploaded to and stored on the server (the EC2 instance). It is safe to share.
- **Private Key:** Kept securely by the client (the user) and never shared. It is used to prove identity when connecting.

**Key management notes:**
- In AWS, a key pair can be generated directly from the EC2 dashboard when launching an instance.
- The private key file is downloadable **only once** at creation time — if lost, it cannot be re-downloaded.
- It is strongly recommended to back up the private key securely (e.g., in a password manager or secure cloud storage such as Google Drive).
- Losing the private key can lock a user out of their instance; exposing it can allow unauthorized access.

---

## 5. Amazon Machine Images (AMIs)

**Definition:** An AMI (Amazon Machine Image) is a pre-configured template that includes an operating system and, optionally, pre-installed software, used to launch new EC2 instances quickly.

**Available AMI categories include:**
- **Amazon Linux:** AWS's own customized Linux distribution, optimized for use on EC2.
- **Ubuntu:** Regular Long-Term Support (LTS) releases available as standard images.
- **Microsoft Windows Server:** Various supported versions for Windows-based workloads.
- **Community AMIs:** Images shared publicly by other users or organizations.
- **AWS Marketplace AMIs:** Verified, often vendor-supported images, sometimes bundled with licensed software.
- **Custom/Legacy AMIs:** Organizations can build custom images to support legacy systems (for example, older operating systems still required for specific government or enterprise applications).

AMIs allow rapid, repeatable deployment of virtual machines with a known, consistent starting configuration.

---

## 6. AWS Security Groups

**Definition:** A Security Group acts as a virtual firewall that controls inbound and outbound network traffic for one or more EC2 instances.

**Key points:**
- **Outbound rules** are generally left at their default (allow all) setting to avoid unintentionally breaking normal application network flows.
- **Inbound rules** must be explicitly configured to allow only the necessary traffic — for example, allowing SSH (port 22) access only from specific, trusted IP addresses (IP whitelisting) rather than the entire internet.
- Rules are typically defined by:
  - **Protocol** (e.g., TCP)
  - **Port range** (e.g., 22 for SSH, 80/443 for web traffic)
  - **Source** (a specific IP address, IP range, or another security group)

Properly configuring inbound rules is critical to securing an EC2 instance while still keeping it accessible to legitimate users.

---

## 7. Additional Key Takeaways

- **Performance vs. Cost Trade-offs:** Choosing between GP3, Provisioned IOPS, and Magnetic volumes requires balancing speed, durability, and cost against actual workload needs.
- **Backup and Recovery:** Snapshots are a core part of any reliable cloud data protection strategy.
- **Regional and Availability Zone Considerations:** Where resources are deployed (region/availability zone) affects latency, redundancy, and compliance requirements, and should be chosen deliberately.
- **Legacy System Support:** Custom AMIs allow cloud environments to still support older, legacy operating systems (e.g., Windows NT) when required by specific real-world use cases.

---

## 8. Glossary of Key Terms

| Term | Definition |
|---|---|
| **EC2** | Elastic Compute Cloud — AWS service for provisioning virtual machines (instances) |
| **EBS** | Elastic Block Store — AWS block storage service attachable to EC2 instances |
| **S3** | Simple Storage Service — AWS object storage service |
| **EFS/FSx** | AWS managed file storage services |
| **IOPS** | Input/Output Operations Per Second — a measure of storage performance |
| **Snapshot** | A point-in-time backup of a storage volume |
| **SSH** | Secure Shell — protocol for secure remote access to a server |
| **AMI** | Amazon Machine Image — a template used to launch EC2 instances |
| **Security Group** | A virtual firewall controlling inbound/outbound traffic to EC2 instances |
| **Public/Private Key Pair** | An asymmetric cryptographic key pair used for secure authentication (public key on server, private key kept by client) |

---

## Summary

This lecture connects the conceptual understanding of the three cloud storage types (block, object, and file) to their real AWS implementations (EBS, S3, EFS/FSx), then applies this knowledge practically by covering EC2 volume creation and snapshots, secure SSH access using key pairs, AMI-based instance provisioning, and Security Group configuration for network access control. Together, these form the foundational skill set needed to provision, secure, and manage compute resources in AWS.