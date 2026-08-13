# Lecture 28 — AWS EC2: Public and Private Subnets

## Overview

Lecture 28 covers how to deploy applications securely on AWS EC2 using a **public-private subnet architecture**.

The main objective is to avoid exposing backend services directly to the public internet. Instead, a public EC2 instance is used as a **Jump Server (Bastion Host)**, while backend services such as Python APIs and Nginx are deployed on EC2 instances inside **private subnets**.

The architecture discussed in the lecture is:

```text
                         Internet
                            |
                            |
                    Public IP Address
                            |
                    +----------------+
                    |  Public EC2    |
                    | Jump Server     |
                    | Bastion Host    |
                    +----------------+
                            |
                     Private IP / SSH
                            |
             +--------------+--------------+
             |                             |
      +-------------+               +-------------+
      | Private EC2 |               | Private EC2 |
      | Nginx       |               | Python API  |
      | Web Server  |               | FastAPI     |
      +-------------+               +-------------+
             |
        Private Subnet
```

This approach provides better isolation, access control, and security compared with placing every application server directly on the internet.

---

## What You Will Learn

* What AWS EC2 is
* Why public EC2 instances create security risks
* Difference between public and private subnets
* How to create EC2 instances
* How to place an EC2 instance inside a specific subnet
* How to disable public IP assignment
* How to create a public Jump Server
* How to connect to a private EC2 instance through a Jump Server
* How to configure Security Groups
* How to use EC2 User Data
* How to install Nginx automatically during instance creation
* How to manage `.pem` SSH keys
* How to use `chmod 400`
* How to create a custom AMI
* How to troubleshoot SSH connectivity

---

# 1. What is Amazon EC2?

**Amazon EC2 (Elastic Compute Cloud)** provides virtual servers that can be launched and managed inside AWS.

An EC2 instance can be used to run:

* Web applications
* APIs
* Python applications
* Node.js applications
* Nginx
* Databases
* Background workers
* Other server-side workloads

EC2 is a paid AWS service, so unused instances should be stopped or terminated when they are no longer required.

---

# 2. Why Not Put Everything on a Public EC2 Instance?

A simple deployment could look like this:

```text
Internet
   |
   v
Public IP
   |
   v
EC2 Instance
   |
   +---- Nginx
   |
   +---- Python API
```

Although this works, the EC2 instance is directly exposed to the internet.

The lecture explains that a public IP increases the attack surface of the server. Even if only ports such as `80`, `8000`, and `22` are exposed, the machine is still reachable from the internet.

For production systems, sensitive backend services should generally not be directly accessible from the public internet.

---

# 3. Public and Private Subnets

A more secure architecture separates the infrastructure into public and private network segments.

## Public Subnet

A public subnet contains resources that need direct internet connectivity.

Example:

```text
Public Subnet
    |
    +---- Jump Server / Bastion Host
```

The Jump Server has a public IP and provides controlled administrative access to private servers.

## Private Subnet

A private subnet contains internal application servers.

Example:

```text
Private Subnet
    |
    +---- Nginx
    |
    +---- Python FastAPI
```

These instances do not receive public IP addresses.

Therefore, users on the internet cannot directly SSH into them.

---

# 4. Jump Server / Bastion Host

A **Jump Server**, also called a **Bastion Host**, is an EC2 instance located in the public subnet.

Its primary purpose in this architecture is to provide a controlled entry point to private EC2 instances.

The connection flow becomes:

```text
Your Laptop
     |
     | SSH
     v
Public EC2
Jump Server
     |
     | SSH using private IP
     v
Private EC2
Backend Server
```

Instead of:

```text
Your Laptop
     |
     | Direct SSH
     v
Private EC2
```

The second approach does not work when the private instance has no public IP and is not directly reachable from the internet.

---

# 5. Creating an EC2 Instance

The lecture demonstrates launching EC2 instances with the correct networking configuration.

## Step 1: Open AWS EC2

Go to the AWS Management Console and open:

**EC2 → Instances**

Select:

**Launch instance**

---

## Step 2: Give the Instance a Name

Enter a meaningful name.

For example:

```text
jump-server
```

For a backend server:

```text
private-backend
```

Using descriptive names makes infrastructure easier to manage.

---

# 6. Select an AMI

Choose the operating system image required by the application.

For example:

```text
Ubuntu Server
```

The AMI determines the initial operating-system environment of the EC2 instance.

---

# 7. Select an Instance Type

Choose an appropriate EC2 instance type based on the workload.

For learning and testing, a small instance can be sufficient.

For production, the instance type should be selected according to:

* CPU requirements
* Memory requirements
* Network requirements
* Application workload
* Expected traffic
* Cost

---

# 8. Select the Key Pair

During EC2 creation, select or create an SSH key pair.

For example:

```text
DEV-PEM-KP.pem
```

The `.pem` file is required to authenticate with the EC2 instance through SSH.

Keep the private key secure.

---

# 9. Configure the Network

The networking section is one of the most important parts of the setup.

Select the appropriate:

* VPC
* Subnet
* Security Group
* Public IP configuration

The public Jump Server should be placed in the **public subnet**.

The backend server should be placed in the **private subnet**.

---

# 10. Public EC2 Configuration

For the Jump Server:

```text
VPC
 |
 +-- Public Subnet
       |
       +-- Jump Server
             |
             +-- Public IP: Yes
```

Enable public IP assignment.

This allows your local computer to connect to the Jump Server through SSH.

---

# 11. Private EC2 Configuration

For the backend instance:

```text
VPC
 |
 +-- Private Subnet
       |
       +-- Backend EC2
             |
             +-- Public IP: No
             +-- Private IP: Yes
```

During instance creation, disable:

```text
Auto-assign Public IP
```

The instance will communicate using its private IP address within the VPC.

---

# 12. Security Groups

A **Security Group** acts as a virtual firewall for EC2 instances.

It controls inbound and outbound network traffic.

## Jump Server Security Group

SSH should be restricted to your allowed source IP.

Example:

```text
Type: SSH
Port: 22
Source: Your IP Address
```

HTTP traffic can be allowed where required:

```text
Type: HTTP
Port: 80
Source: 0.0.0.0/0
```

The lecture also demonstrates application traffic such as port:

```text
8000
```

when required by the Python application.

---

# 13. Private Server Security Group

The private EC2 instance should not allow SSH from the entire internet.

Instead, SSH should be allowed only from the Jump Server.

Conceptually:

```text
Jump Server
     |
     | Port 22
     v
Private EC2
```

The source can be configured using:

* Jump Server private IP
* Jump Server Security Group

Using a Security Group as the source is more flexible because private IP addresses can change when instances are recreated.

---

# 14. SSH Connection to the Jump Server

From your local machine:

```bash
ssh -i DEV-PEM-KP.pem ubuntu@<JUMP_SERVER_PUBLIC_IP>
```

For example:

```bash
ssh -i DEV-PEM-KP.pem ubuntu@13.215.224.161
```

The exact public IP will be different for your instance.

---

# 15. SSH Key Permissions

SSH requires appropriate permissions on the private key.

Run:

```bash
chmod 400 DEV-PEM-KP.pem
```

Then connect:

```bash
ssh -i DEV-PEM-KP.pem ubuntu@<JUMP_SERVER_PUBLIC_IP>
```

`chmod 400` ensures that the private key is readable only by the owner.

---

# 16. Connecting to the Private EC2

A private EC2 instance does not have a public IP.

Therefore, you cannot normally connect to it directly from your laptop.

First connect to the Jump Server:

```text
Laptop
  |
  v
Jump Server
```

Then connect from the Jump Server to the private EC2:

```bash
ssh -i DEV-PEM-KP.pem ubuntu@<PRIVATE_IP>
```

Example:

```bash
ssh -i DEV-PEM-KP.pem ubuntu@10.0.2.15
```

The private IP is only an example. Use the actual private IP assigned to your EC2 instance.

The complete connection becomes:

```text
Laptop
   |
   | SSH
   v
Jump Server
Public IP
   |
   | SSH
   v
Private EC2
Private IP
```

---

# 17. Transferring the PEM Key

To SSH from the Jump Server into the private EC2, the required private key must be available on the Jump Server.

The lecture demonstrates transferring the `.pem` file to the Jump Server.

After transferring it, set its permissions:

```bash
chmod 400 DEV-PEM-KP.pem
```

Then use it to authenticate with the private EC2:

```bash
ssh -i DEV-PEM-KP.pem ubuntu@<PRIVATE_IP>
```

The private key should be handled carefully because anyone who obtains it may be able to authenticate to instances that trust that key pair.

---

# 18. EC2 User Data

EC2 provides **User Data** for automatically running commands during instance initialization.

Instead of manually installing software after every instance launch, commands can be provided during the launch process.

For example:

```bash
#!/bin/bash

apt update -y
apt install nginx -y
```

The script runs during the instance's initial setup.

This can automate tasks such as:

* Updating packages
* Installing Nginx
* Installing required software
* Preparing the server environment

---

# 19. Why Use User Data?

Without User Data:

```text
Launch EC2
     |
     v
SSH into server
     |
     v
Update packages
     |
     v
Install Nginx
     |
     v
Configure server
```

With User Data:

```text
Launch EC2
     |
     v
User Data executes
     |
     v
Packages installed automatically
```

This makes infrastructure provisioning more repeatable and reduces manual configuration.

---

# 20. Custom AMI

The lecture also introduces **Custom Amazon Machine Images (AMI)**.

An AMI can be created from an already configured EC2 instance.

For example:

```text
Base EC2
   |
   +-- Ubuntu
   +-- Nginx
   +-- Application Dependencies
   +-- Configuration
        |
        v
     Custom AMI
        |
        +---- New EC2
        |
        +---- New EC2
        |
        +---- New EC2
```

This allows the same configured environment to be reproduced quickly.

Custom AMIs are useful for:

* Rapid deployment
* Scaling
* Consistent environments
* Disaster recovery
* Repeated infrastructure provisioning

---

# 21. Complete Architecture

The final architecture from the lecture can be represented as:

```text
                         Internet
                            |
                            v
                     Public IP Address
                            |
                            v
                +------------------------+
                |     Public Subnet      |
                |                        |
                |   +----------------+   |
                |   | Jump Server    |   |
                |   | Bastion Host   |   |
                |   +----------------+   |
                +-----------|------------+
                            |
                       Private Network
                            |
             +--------------+--------------+
             |                             |
             v                             v
      +-------------+               +-------------+
      | Private     |               | Private     |
      | EC2         |               | EC2         |
      | Nginx       |               | Python API  |
      +-------------+               +-------------+
             |
             +-------- Private Subnet --------+
```

---

# 22. Security Principles

The lecture emphasizes several important security principles.

## Do Not Expose Backend Servers Directly

Backend services should not unnecessarily have public IP addresses.

Instead:

```text
Internet
   |
   v
Public Layer
   |
   v
Private Backend
```

---

## Restrict SSH Access

Avoid:

```text
Port 22
Source: 0.0.0.0/0
```

when it is not required.

Prefer:

```text
Port 22
Source: Specific IP
```

or:

```text
Port 22
Source: Jump Server Security Group
```

---

## Use Private IPs for Internal Communication

Private EC2 instances communicate with other resources inside the VPC using private networking.

This reduces unnecessary public exposure.

---

# 23. Important Commands

### Set SSH Key Permissions

```bash
chmod 400 DEV-PEM-KP.pem
```

### Connect to Public EC2

```bash
ssh -i DEV-PEM-KP.pem ubuntu@<PUBLIC_IP>
```

### Connect to Private EC2

```bash
ssh -i DEV-PEM-KP.pem ubuntu@<PRIVATE_IP>
```

### Install Nginx

```bash
sudo apt update
sudo apt install nginx -y
```

---

# 24. Troubleshooting SSH

If SSH to the private instance fails, check the following.

### 1. Verify the Private IP

Make sure you are using the current private IP address.

### 2. Check Security Groups

The private EC2 Security Group should allow:

```text
SSH
Port: 22
Source: Jump Server
```

### 3. Check Key Permissions

Run:

```bash
chmod 400 DEV-PEM-KP.pem
```

### 4. Confirm the Instance Is Running

Check the EC2 console and ensure the instance is in the running state.

### 5. Verify Network Placement

Confirm that:

* Jump Server is in the public subnet
* Backend EC2 is in the private subnet
* Backend EC2 does not have a public IP

### 6. Check the SSH Path

The expected connection is:

```text
Local Machine
     |
     v
Public Jump Server
     |
     v
Private EC2
```

---

# 25. Lecture Workflow

The complete workflow demonstrated in the lecture is:

```text
1. Create VPC / networking
        |
        v
2. Create Public Subnet
        |
        v
3. Create Private Subnet
        |
        v
4. Launch Public EC2
        |
        v
5. Launch Private EC2
        |
        v
6. Configure Security Groups
        |
        v
7. Configure User Data
        |
        v
8. SSH into Jump Server
        |
        v
9. Transfer PEM Key
        |
        v
10. chmod 400 PEM Key
        |
        v
11. SSH into Private EC2
        |
        v
12. Configure Application
        |
        v
13. Create Custom AMI
```

---

# 26. Key Takeaways

1. EC2 provides virtual servers for running applications in AWS.
2. Public EC2 instances are directly reachable from the internet and therefore require careful security configuration.
3. A public subnet can contain a Jump Server or Bastion Host.
4. Backend servers can be placed inside private subnets.
5. Private EC2 instances should not have public IP addresses when direct internet access is unnecessary.
6. Security Groups work as virtual firewalls.
7. SSH access to private instances can be performed through a Jump Server.
8. SSH private keys require appropriate permissions such as `chmod 400`.
9. EC2 User Data can automate initial server configuration.
10. Custom AMIs allow configured EC2 environments to be reproduced quickly.
11. Security Group references are useful when private IP addresses may change.
12. Public-private subnet segmentation reduces the attack surface of backend infrastructure.

---

# 27. Final Architecture Goal

The main goal of Lecture 28 is to move from a simple architecture:

```text
Internet
   |
   v
Public EC2
   |
   +-- Backend API
```

to a more secure layered architecture:

```text
                         Internet
                            |
                            v
                     Public EC2
                    Jump / Bastion
                            |
                            v
                     Private Network
                            |
                 +----------+----------+
                 |                     |
                 v                     v
            Private EC2          Private EC2
               Nginx             Python API
```

This architecture provides a foundation for secure AWS application deployment by combining **EC2, VPC networking, public/private subnets, Security Groups, SSH, User Data, and custom AMIs**.
