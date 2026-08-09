# AWS VPC Networking: Complete Study Guide

## 1. Overview

Amazon Virtual Private Cloud (VPC) is a logically isolated section of AWS where you can launch resources in a virtual network that you define. This guide covers VPC fundamentals, subnet design, gateways, routing, and security — including several important concepts not covered in the original lecture but essential for real-world use and certification exams.

---

## 2. VPC Is a Regional Service

- A VPC exists within a single AWS Region and cannot span multiple regions.
- Region choice affects latency, service availability, pricing, and reliability. Political or infrastructure instability in a region can cause service disruptions, so choosing a stable, well-supported region (e.g., Singapore, Frankfurt, N. Virginia) is a practical consideration for labs and production alike.
- A VPC *can* span multiple Availability Zones (AZs) within that region — this is the basis of high availability design.

---

## 3. The Default VPC

- AWS automatically provisions one default VPC per region.
- Default CIDR block: `172.31.0.0/16` — approximately 65,536 IP addresses.
- Comes pre-configured with a default subnet in each AZ, an Internet Gateway, and a main route table, so instances launched into it get internet access automatically.
- Generally not recommended for production; most teams create custom VPCs for proper isolation and control.

---

## 4. IP Addressing and CIDR Rules

| Concept | Detail |
|---|---|
| Allowed VPC CIDR range | `/16` to `/28` |
| Largest VPC | `/16` = 65,536 addresses |
| Smallest VPC | `/28` = 16 addresses |
| Reserved addresses per subnet | 5 |

**Why 5 addresses are reserved in every subnet (example: `10.10.1.0/24`):**

| Address | Purpose |
|---|---|
| `10.10.1.0` | Network address |
| `10.10.1.1` | VPC router |
| `10.10.1.2` | Reserved for DNS |
| `10.10.1.3` | Reserved for future use |
| `10.10.1.255` | Broadcast address (not used in AWS, but still reserved) |

So a `/24` subnet (256 addresses) actually gives you only **251 usable IPs**. This is a common point of confusion and an important detail for capacity planning.

---

## 5. Subnet Design Across Availability Zones

- Best practice: deploy across a minimum of **three AZs** for fault tolerance.
- Typical pattern: one **public subnet** and one **private subnet** per AZ (six subnets total for three AZs).
- Public subnets host internet-facing resources (load balancers, bastion hosts, NAT Gateways).
- Private subnets host internal resources (databases, application servers) that should not be directly reachable from the internet.

**What actually makes a subnet "public" or "private":**
A subnet is public only if its route table sends `0.0.0.0/0` traffic to an Internet Gateway. There is no special "public/private" flag on a subnet itself — it's entirely determined by route table association. This is an important and often misunderstood detail.

---

## 6. Route Tables

- Every VPC gets a **main route table** automatically. Any subnet not explicitly associated with another route table uses the main one by default.
- Best practice: create separate custom route tables for public and private subnets rather than relying on the main table.
- A subnet can only be associated with one route table at a time, but a route table can be associated with multiple subnets.
- Routes are matched using **longest prefix match** — the most specific matching route wins.

**Typical routing setup:**

| Subnet Type | Local traffic | Internet-bound traffic (`0.0.0.0/0`) |
|---|---|---|
| Public | Local VPC route | Internet Gateway |
| Private | Local VPC route | NAT Gateway |

---

## 7. Internet Gateway (IGW) vs NAT Gateway (NGW)

| Feature | Internet Gateway | NAT Gateway |
|---|---|---|
| Direction | Bidirectional (inbound + outbound) | Outbound only |
| Used by | Public subnets | Private subnets |
| Quantity per VPC | Exactly one | One or more, typically one per AZ for high availability |
| Requires Elastic IP | No | Yes |
| Cost | Free | Charged hourly + per GB processed |
| Typical use case | Web servers, load balancers | App/database servers needing OS updates, API calls, package downloads |

**Important addition:** For production, deploy a NAT Gateway **in each AZ** rather than a single shared one. A single NAT Gateway in one AZ becomes a single point of failure — if that AZ goes down, private subnets in other AZs lose outbound internet access too.

There is also a **NAT Instance** (an EC2-based alternative to NAT Gateway) — cheaper but requires manual management, patching, and doesn't scale automatically. Worth knowing for exams even though NAT Gateway is now the standard recommendation.

---

## 8. Elastic IP Addresses (EIP)

- A static, public IPv4 address you can allocate to your account and attach to resources like NAT Gateways or EC2 instances.
- AWS charges for EIPs that are **allocated but not attached to a running resource**, to discourage hoarding unused addresses.
- When you delete a NAT Gateway, the associated EIP is released back to AWS but may take some time to disappear from the console.

---

## 9. Network ACLs (NACLs)

- Operate at the **subnet level** and are **stateless** — meaning inbound and outbound rules are evaluated independently; a response to allowed inbound traffic is not automatically allowed outbound (unlike Security Groups).
- Rules are evaluated in order of rule number, lowest first; the first match wins.
- The default NACL allows all inbound and outbound traffic by default (rule `*` at the end denies everything not explicitly matched).
- Useful for broad, subnet-wide restrictions such as blocking a specific IP range or an entire country's traffic block.

---

## 10. Security Groups (important addition — not fully covered in the original material)

Since NACLs are only half the security picture, Security Groups deserve equal attention:

| Feature | Security Group | Network ACL |
|---|---|---|
| Level | Instance/resource level | Subnet level |
| State | Stateful (return traffic auto-allowed) | Stateless (must allow both directions explicitly) |
| Rule types | Allow rules only | Allow and Deny rules |
| Evaluation | All rules evaluated together | Rules evaluated in order, first match wins |
| Applies to | Attached resources (e.g., EC2, RDS) | All resources in the subnet |

Both layers work together: NACLs act as a coarse outer wall, Security Groups as fine-grained per-resource control.

---

## 11. Other Important Concepts Worth Knowing

These are commonly needed in real projects and on AWS certification exams but weren't in the original lecture:

- **VPC Peering:** Connects two VPCs privately so resources can communicate using private IPs. Does not support transitive routing (if A peers with B, and B peers with C, A cannot reach C through B).
- **Transit Gateway:** A hub-and-spoke alternative to peering for connecting many VPCs and on-premises networks at scale, and does support transitive routing.
- **VPC Endpoints:** Allow private connectivity to AWS services (like S3 or DynamoDB) without traversing the public internet. Two types: Gateway endpoints (S3, DynamoDB only) and Interface endpoints (most other services, powered by PrivateLink).
- **VPN and Direct Connect:** Ways to connect an on-premises data center to a VPC. Site-to-Site VPN is encrypted and internet-based; Direct Connect is a dedicated private physical connection, faster and more consistent but takes longer to provision.
- **VPC Flow Logs:** Capture information about IP traffic going to and from network interfaces in a VPC — essential for troubleshooting and security auditing.
- **DHCP Option Sets:** Control DNS servers, domain names, and NTP servers handed out to instances in the VPC.
- **DNS settings (`enableDnsSupport` / `enableDnsHostnames`):** Must both be enabled for instances to get resolvable hostnames — a common source of connectivity issues when troubleshooting.
- **Bastion Host / Jump Box:** An EC2 instance in a public subnet used as a secure entry point to reach instances in private subnets via SSH/RDP, avoiding direct public exposure of private resources.
- **IPv6 support:** VPCs can optionally have an IPv6 CIDR block in addition to IPv4; IPv6 addresses in AWS are always globally unique and there's no private/reserved range concept the same way as IPv4.

---

## 12. Quick Reference Summary

- VPC = regional, isolated virtual network.
- CIDR block size: `/16` to `/28`; every subnet loses 5 IPs to AWS reservations.
- Spread subnets across at least 3 AZs for resilience.
- A subnet's "public" or "private" status comes from its route table, not a fixed setting.
- IGW = two-way internet access for public subnets; NAT Gateway = outbound-only access for private subnets, and should be deployed per-AZ in production.
- Elastic IPs are billed when idle, so release what you don't need.
- NACLs (stateless, subnet-level) and Security Groups (stateful, resource-level) work together for defense in depth.
- Beyond the basics: peering, Transit Gateway, VPC endpoints, VPN/Direct Connect, Flow Logs, and DNS settings are all things you'll eventually need in a real deployment.

---

*This guide consolidates and expands on lecture notes for AWS VPC networking fundamentals, intended as a clear reference for both learning and quick review.*