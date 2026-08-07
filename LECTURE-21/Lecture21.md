# Lecture 21 — AWS Infrastructure & Identity and Access Management (IAM)

---

## Part 1: AWS Infrastructure — Regions, Availability Zones & Services

### Overview
AWS offers around **300 services**, split into two categories:

- **Global services** — consistent configuration everywhere, accessible from any region (e.g., IAM).
- **Regional services** — tied to a specific geographic region; resources must be created/managed within that region.

### Regions & Availability Zones
- A **region** is a geographic area (a city or a country) containing **at least 3 availability zones**.
- An **availability zone (AZ)** is a physically distinct data center within a region.
- Multiple AZs per region exist for **fault tolerance and high availability** — if one AZ fails, workloads can fail over to another.
- AZs are kept physically separated to protect against localized failures (natural disasters, hardware issues, geopolitical events) while staying close enough for low-latency replication.

### Real-World Risk Example
- A physical attack on a data center in **Bahrain** damaged an AWS AZ.
- Customers who deployed only in that **single AZ** lost data.
- Lesson: AWS guarantees durability only if the customer architects for **multi-zone / multi-region** deployment — single-AZ deployments carry real risk.

### Shared Responsibility Model
| AWS Responsibility | Customer Responsibility |
|---|---|
| Physical security of data centers | Configuring VMs, applications, and network access |
| Security "of" the cloud (infrastructure) | Security "in" the cloud (passwords, access control, app-level config) |

A breach caused by weak application-level security or misconfiguration is **not** AWS's fault.

### Latency Considerations
- Latency depends on the physical distance between the user and the chosen AWS region.
- Tools like **cloudping.info** measure round-trip latency to different regions.
- Tests typically use small packets (4–8KB) as a baseline; large data transfers will naturally have higher throughput.
- Example use case: comparing latency for European clients vs. developers based in Pakistan to pick the optimal region.

### Regional Pricing
- Costs for the same service (e.g., a VM instance) **vary by region** — e.g., North Virginia vs. UAE vs. Mumbai.
- Cost, performance, and compliance requirements should all be weighed together when choosing a region.

### Region Management
- Not all AWS regions are enabled by default on an account.
- Regions can be **enabled/disabled** via the AWS Console based on business needs, geographic reach, or regulatory restrictions — helps control both deployment footprint and billing.

### Growth Areas
- New regions are actively being added, notably in the **Middle East** (Saudi Arabia, Israel, UAE) and **Asia-Pacific** (Mumbai, Hyderabad).

---

## Part 2: AWS IAM — Identity and Access Management

### What is IAM?
- IAM is a **global AWS service** that manages **authentication** (who can log in) and **authorization** (what they can do).
- Because it's global, an IAM user created in one region can manage resources in any other region — no region-specific credentials needed.

### Root Account vs. IAM Users
- **Root account**: created at sign-up, has **unrestricted access** (including billing and account deletion). Extremely high risk if compromised.
  - Best practice: use root **only for initial setup**, then lock it down.
- **IAM users**: created with **fine-grained, tailored permissions** for day-to-day operations — reduces exposure and enforces least privilege.

### Role-Based Access Control (RBAC)
IAM separates access control into two steps:
1. **Authentication** — verifying identity (login).
2. **Authorization** — defining what an authenticated user can actually do (via policies).

Core IAM components:
- **Users** — individual identities
- **Groups** — collections of users sharing permissions
- **Policies** — documents defining allowed/denied actions
- **Roles** — temporary permission sets, often assumed by services or federated users

### Multi-Factor Authentication (MFA)
- MFA should be enforced on **all accounts, especially root**.
- Recommended tool: **Google Authenticator** (supports backup codes).
- Backup codes matter — losing/breaking the MFA device without a backup can lock you out, and recovery through AWS support is difficult.

### Access Methods
| Method | Use Case | Auth Method |
|---|---|---|
| **Console (UI)** | Manual/interactive management | Email/username + password |
| **CLI** | Scripted/terminal-based operations | Access keys |
| **SDKs** | Programmatic automation (Python, JavaScript, Go, Ruby, etc.) | Access keys |

### Access Key Best Practices
- **Never generate access keys for the root account.**
- Generate access keys only for **IAM users**, so CLI/SDK access stays aligned with least-privilege policies.

### Design Triad: Performance, Security, Cost
- Any AWS architecture decision involves balancing these three factors.
- Overemphasizing one (e.g., minimizing cost) typically degrades another (e.g., performance or security).

---

## Summary Takeaways
- Use **multiple AZs/regions** for any production workload — single-AZ deployment is a real, demonstrated risk.
- Understand the **shared responsibility model**: AWS secures the infrastructure, you secure your configuration.
- **Never use the root account** for daily operations — create IAM users with scoped policies instead.
- Always enable **MFA**, especially on root, with backup codes stored safely.
- Generate **access keys only on IAM users**, never on root.
- Factor in **latency and regional pricing** when choosing where to deploy.