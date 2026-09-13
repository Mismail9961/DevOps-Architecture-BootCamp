# Secure Multi-Layer AWS Infrastructure

A production-style AWS architecture that separates **public-facing** components (VPN, forward proxy, reverse proxy) from **private backend** resources (frontend/backend app servers), with tightly scoped security groups, network mapping, and automation via Terraform / AWS CLI / Boto3.

---

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Components](#components)
3. [Network & Port Map](#network--port-map)
4. [Security Groups](#security-groups)
5. [Build Guide — Step by Step](#build-guide--step-by-step)
6. [Automation](#automation)
7. [Best Practices](#best-practices)
8. [Repo Structure (suggested)](#repo-structure-suggested)

---

## Architecture Overview

The infrastructure is split into two layers inside one VPC:

- **Public Subnet** — internet-facing entry points only:
  - OpenVPN server (secure admin/employee access)
  - Forward Proxy (Squid) — controls *outbound* traffic from private machines
  - Reverse Proxy (Nginx/Apache) — controls *inbound* traffic to private machines
- **Private Subnet** — no direct internet exposure:
  - Frontend servers
  - Backend servers

All external access to private resources is mediated — either through the reverse proxy (inbound HTTP/HTTPS) or the VPN (inbound SSH/admin). All outbound internet access from private machines is routed through the forward proxy. This minimizes the attack surface and enforces least-privilege networking.

```
Internet
   │
   ▼
┌─────────────── Public Subnet ───────────────┐
│  OpenVPN   Forward Proxy   Reverse Proxy      │
│  (UDP 1194 /        (Squid,        (Nginx/    │
│   TCP 443/943)     custom port)    Apache 80/443)│
└───────────────────┬──────────────────────────┘
                     │ controlled traffic only
                     ▼
┌─────────────── Private Subnet ──────────────┐
│         Frontend server(s)                    │
│         Backend server(s)                     │
│  (SSH 22 via VPN, HTTP via reverse proxy only) │
└────────────────────────────────────────────────┘
```

---

## Components

| Component | Tool | Role |
|---|---|---|
| VPN | OpenVPN | Secure remote/employee access to private resources |
| Forward Proxy | Squid | Controls and audits outbound traffic from private machines |
| Reverse Proxy | Nginx or Apache | Routes and filters inbound traffic to private machines |
| App Layer | EC2 (frontend/backend) | Private, no public IP |
| IaC | Terraform / CloudFormation | Repeatable, version-controlled deployments |
| Scripting | AWS CLI / Python (Boto3) | Automation glue, ad-hoc provisioning |

---

## Network & Port Map

| Machine | Direction | Port / Protocol | Purpose |
|---|---|---|---|
| OpenVPN server | Inbound | UDP 1194, TCP 443/943 | Client VPN connections |
| Forward Proxy (Squid) | Inbound | Custom (e.g. not default 3128) | Outbound traffic relay from private subnet |
| Reverse Proxy (Nginx/Apache) | Inbound | TCP 80/443 | Public HTTP/HTTPS entry point |
| Private Frontend | Inbound | TCP 22 (via VPN only), TCP 80 (via reverse proxy only) | SSH admin, app traffic |
| Private Backend | Inbound | Restricted to frontend/app tier only | Internal service calls |
| All private machines | Outbound | Via forward proxy only | Egress control/auditing |
| Admin/employee IPs | Inbound (SSH) | TCP 22, restricted by source IP | Management access |

> **Rule of thumb:** Outbound traffic is generally permitted; the real security work is in restricting *inbound* access to only what's required, from only the sources that need it.

---

## Security Groups

Use a **separate security group per role** — never one shared group for everything.

- `sg-vpn` — OpenVPN ports only
- `sg-forward-proxy` — Squid custom port, source-restricted to private subnet
- `sg-reverse-proxy` — 80/443 open to internet, forwards to private subnet
- `sg-private-frontend` — 22 from VPN SG only, 80 from reverse-proxy SG only
- `sg-private-backend` — access limited to frontend SG only

Tag every security group and instance clearly (e.g. `Role=vpn`, `Env=prod`, `Layer=public`) — this pays off enormously during audits or troubleshooting months later.

---

## Build Guide — Step by Step

### 1. Plan the network
- Decide VPC CIDR, public subnet CIDR, private subnet CIDR.
- Draw the machine communication map (who talks to whom, on what port) **before** touching the console or code.

### 2. Create the VPC and subnets
```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24   # public
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.2.0/24   # private
```
- Attach an Internet Gateway to the VPC and route it only from the **public** subnet's route table.
- Give the private subnet a route to a NAT Gateway (for OS patching etc.) if needed — not a direct IGW route.

### 3. Create per-role security groups
Create `sg-vpn`, `sg-forward-proxy`, `sg-reverse-proxy`, `sg-private-frontend`, `sg-private-backend` as described above, each with only the inbound rules it needs. Reference other security groups as sources (instead of raw IP ranges) so rules stay valid even if IPs change.

### 4. Deploy the public layer
- Launch the OpenVPN instance in the public subnet with an Elastic IP; install and configure OpenVPN, generate/distribute client certs.
- Launch the Squid forward-proxy instance; change the listening port from the 3128 default; restrict `acl` rules to only the private subnet CIDR.
- Launch the Nginx/Apache reverse-proxy instance; configure it to forward requests to the private frontend's internal IP/DNS.

### 5. Deploy the private layer
- Launch frontend/backend instances in the private subnet with **no public IP**.
- Confirm they are only reachable via the reverse proxy (HTTP) and VPN (SSH) — test from an outside network that direct access fails.

### 6. Validate the map
- From a VPN-connected client: confirm SSH works to private machines.
- From the public internet: confirm only the reverse proxy responds on 80/443, and that hitting the frontend's private IP directly is impossible.
- From a private instance: confirm outbound web requests only succeed through the forward proxy.

### 7. Standardize with Launch Templates
Create a Launch Template per role (public vs private) capturing AMI, instance type, subnet, security group(s), and IP assignment behavior — so you never have to remember to uncheck/check "auto-assign public IP" again.
```bash
aws ec2 create-launch-template \
  --launch-template-name private-frontend-template \
  --launch-template-data file://frontend-launch-template.json
```

### 8. Automate the whole thing
Move from manual console clicks → CLI scripts → Terraform (recommended) so the entire environment is reproducible, diff-able, and safe to tear down/recreate.

---

## Automation

Three levels, roughly in order of maturity:

1. **AWS CLI scripts** — good for quick, repeatable one-off tasks; no state tracking.
2. **Python / Boto3** — adds logic, conditionals, and integration with other systems; still no built-in state management.
3. **Terraform (recommended) / CloudFormation** — full Infrastructure as Code: declarative, version-controlled, with state tracking and `plan`/`apply`/`destroy` workflows. Terraform's syntax is lightweight and a good entry point; CloudFormation is the native AWS option if you're fully invested in the AWS ecosystem.

Minimal Terraform skeleton:
```hcl
resource "aws_vpc" "main" { cidr_block = "10.0.0.0/16" }

resource "aws_subnet" "public"  { vpc_id = aws_vpc.main.id, cidr_block = "10.0.1.0/24" }
resource "aws_subnet" "private" { vpc_id = aws_vpc.main.id, cidr_block = "10.0.2.0/24" }

resource "aws_security_group" "vpn" { /* UDP 1194, TCP 443/943 */ }
resource "aws_security_group" "forward_proxy" { /* custom port, source = private subnet */ }
resource "aws_security_group" "reverse_proxy" { /* 80/443 from 0.0.0.0/0 */ }
resource "aws_security_group" "private_frontend" { /* 22 from vpn sg, 80 from reverse_proxy sg */ }

resource "aws_launch_template" "private" { /* AMI, instance type, sg, no public IP */ }
```

---

## Best Practices

- ✅ One security group per role — never one big shared group.
- ✅ Tag everything (`Role`, `Env`, `Layer`) for fast troubleshooting.
- ✅ Restrict inbound SSH to known/management IPs only.
- ✅ Never assign public IPs to private-layer instances.
- ✅ Use Launch Templates + Auto Scaling Groups instead of manual instance creation.
- ✅ Prefer Terraform (or CloudFormation) over ad-hoc scripts for anything long-lived.
- ✅ Automate subnet-level IP assignment to avoid manual misconfiguration/drift.
- ✅ Validate VPN client credentials/compatibility before rollout.

---