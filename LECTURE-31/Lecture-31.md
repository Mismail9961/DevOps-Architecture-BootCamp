# Lecture 31: Automating Cloud Infrastructure Setup Using EC2 User Data Scripts

## Overview
This lecture provides a comprehensive live demonstration of creating and configuring multiple Amazon EC2 virtual machines (VMs) using automated shell scripting via EC2 user data. The session focuses on infrastructure-as-code principles to streamline the deployment of a secure, functional cloud environment containing a VPN server, forward proxy, reverse proxy, and a private frontend instance within a Virtual Private Cloud (VPC).

---

## Architecture and Infrastructure Setup

### Security and Networking
* **Security Groups:** Created dedicated security groups to isolate traffic and enforce least-privilege access.
* **Subnet Configurations:** Segregated resources into public and private subnets to control network exposure.
* **Elastic IPs:** Allocated and attached Elastic IPs to the VPN instance to ensure static IP addressing for reliable client connections.
* **Access Minimization:** Eliminated default open SSH rules by leveraging automated user data scripts and exposing only required ports (such as port 943 for OpenVPN).

### Virtual Machine Roles
1. **VPN Server:** Deployed on an instance type with public subnet placement, auto-assigned public IP, attached security groups, and automated OpenVPN installation.
2. **Forward Proxy:** Configured using Squid to handle outgoing traffic, manage proxy environment variables ($HTTP\_PROXY$, $HTTPS\_PROXY$, $NO\_PROXY$), and restrict external connectivity.
3. **Reverse Proxy:** Configured with NGINX to route incoming traffic, manage domain names, and handle frontend traffic distribution.
4. **Private Frontend Instance:** Deployed securely within internal subnets.

---

## Automation via EC2 User Data Scripts

### Core Scripting Mechanics
* **Automation Backbone:** Used bash scripts embedded in EC2 user data to handle package repository updates, prerequisites installation (`curl`, CA certificates, `net-tools`), and software deployments automatically upon instance boot.
* **Modular Parameterization:** Designed scripts to accept parameters (such as the VPC CIDR block) as arguments, allowing the same scripts to be reused seamlessly across development, staging, and production environments.
* **Programmatic File Editing:** Utilized utilities like `echo`, `cat`, and redirection operators (`>` and `>>`) to generate and modify configuration files programmatically without manual SSH intervention.

---

## Post-Deployment Validation and Troubleshooting

* **OpenVPN Verification:** Accessed the OpenVPN web interface via the public IP on port 943, configured admin users, set global access rules restricted to the VPC IP pool, and generated client connection profiles.
* **Squid Proxy Troubleshooting:** Addressed script parameterization bugs (such as positional parameters vs. variable expansions like `$1` versus `$VPC\_CIDR`), verified configuration integrity, and restarted the Squid service.
* **NGINX Configuration:** Validated NGINX setup, corrected missing service restart commands (`systemctl restart`), and reloaded configurations to ensure persistence.

---

## Key DevOps Insights

* **Reduced Manual Overhead:** Automating initial configurations via scripts replaces error-prone manual setup steps and reduces configuration drift across environments.
* **Iterative Debugging:** Emphasizes real-world troubleshooting, such as debugging variable scope and missing service reload commands during live deployment.
* **Enhanced Security Posture:** Minimizes the attack surface by reducing broad SSH access and relying on automated provisioning.

---

## README Setup Instructions

If you are setting up or replicating this infrastructure in your own AWS environment, follow these general steps:

1. **Configure VPC and Subnets:** Set up a VPC with properly segregated public and private subnets, along with corresponding route tables and Internet Gateways.
2. **Create Security Groups:** Define restrictive security groups for your proxy servers, VPN instance, and frontend applications, opening only necessary ports.
3. **Prepare User Data Scripts:** Draft modular bash scripts for your target services (OpenVPN, Squid, NGINX) and pass required environment variables (like VPC CIDR blocks) dynamically.
4. **Launch Instances:** Provision your EC2 instances while injecting the user data scripts into the advanced details section.
5. **Validate and Test:** Log into management interfaces, check service logs, and verify network connectivity across public and private subnets.