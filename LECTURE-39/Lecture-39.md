# Lecture 39: AWS RDS Database Setup & Management

## 1. IaaS vs PaaS for Databases

| | Database on EC2 (IaaS) | AWS RDS (PaaS) |
|---|---|---|
| OS and runtime | You manage | AWS manages |
| Patching and updates | You do it | AWS does it |
| Backups | You set them up | Built in, automated |
| Your focus | Infrastructure and app | Mainly the app |

**RDS = managed relational database.** Less work, better security, less operational overhead.

## 2. Setup Order (Big Picture)

1. Networking: **VPC and subnets**
2. Create a **DB subnet group**
3. Create a **security group**
4. Create the **database** (engine, size, settings)
5. Connect using the **endpoint**

## 3. Networking: Subnet Groups

- A **DB subnet group** tells RDS which VPC subnets it can use.
- Pick subnets in **multiple Availability Zones (AZs)** for redundancy.
- Subnets can be:
  - **Public:** reachable from the internet (via route table and internet gateway)
  - **Private:** isolated, safer for databases
- Route tables control the traffic flow.
- Public vs private access depends on the use case.

## 4. Security Groups

- Act as a **firewall** for the database.
- Create a **dedicated security group for RDS**.
- Allow inbound traffic only from what needs it (e.g. your EC2 app server) on the DB port.
- Attach it correctly, or EC2 and RDS won't be able to talk to each other.

## 5. Database Engines

| Engine | Notes |
|---|---|
| **MySQL** | Popular, huge community |
| **PostgreSQL** | Advanced features |
| **Aurora** | AWS-built, fast; compatible with MySQL or PostgreSQL |
| **Microsoft SQL Server** | Microsoft ecosystem |
| **Oracle** | Enterprise use |

Choose based on your app and tools (e.g. MySQL Workbench vs pgAdmin).

## 6. Deployment Models

| Model | How it works | Use for |
|---|---|---|
| **Single instance** | One DB handles all reads and writes | Dev/testing (free tier) |
| **Multi-AZ standby** | Synchronous standby copy in another AZ, with **automatic failover** | Production availability |
| **Cluster** | Primary handles writes, **read replicas** handle reads | High traffic, scaling |

## 7. Key Configuration Options

- **DB identifier** (follow AWS naming rules)
- **Master username and password** (can be auto-generated)
- **Authentication:** password-based or **IAM-based**
- **Instance class** (CPU/RAM) and **storage size**
- **Availability zone**
- **Public access:** yes or no
- **Automated backups**
- **Maintenance window:** schedule during **low-usage hours**

## 8. Troubleshooting Tips

| Issue | Fix |
|---|---|
| Error on DB identifier | Follow AWS naming rules |
| Security group problems | Make sure the correct group is attached |
| Creation fails | Enable **DNS hostnames** in the VPC settings |
| General errors | **Read the AWS error message** carefully and retry |

Free tier has limits, so check them before choosing options.

## 9. After Creation

- Get the **endpoint** and use it to connect your app or client.
- AWS handles **patching, updates and security fixes**.
- Built-in **monitoring** for performance and alerts.

## Quick Summary

1. RDS is a managed (PaaS) database, so AWS handles the OS and patching.
2. Order: VPC/subnets → subnet group → security group → create DB.
3. Use multiple AZs for fault tolerance.
4. Engines: MySQL, PostgreSQL, Aurora, SQL Server, Oracle.
5. Single instance for dev, **Multi-AZ** for failover, **cluster** for scaling reads.
6. Set backups, schedule maintenance in off-hours, and choose public access carefully.
7. Read AWS error messages and enable DNS hostnames if creation fails.