# Lecture 27 — Launching and Managing AWS EC2 Instances

## Overview

Lecture 27 introduces **Amazon EC2 (Elastic Compute Cloud)** and provides a practical walkthrough of launching, configuring, accessing, and managing a Linux-based EC2 instance.

The lecture focuses on understanding the EC2 launch process, including:

* Selecting an Amazon Machine Image (AMI)
* Choosing an EC2 instance type
* Understanding instance families
* Selecting an SSH key pair
* Configuring networking
* Configuring Security Groups
* Configuring EBS storage
* Launching the instance
* Connecting through SSH
* Securing the `.pem` private key
* Installing Nginx
* Allowing HTTP traffic through a Security Group
* Accessing the deployed web server through the instance's public IP

The overall workflow is:

```text
AWS Console
     |
     v
EC2
     |
     v
Launch Instance
     |
     +---- Select AMI
     |
     +---- Select Instance Type
     |
     +---- Select Key Pair
     |
     +---- Configure Network
     |
     +---- Configure Security Group
     |
     +---- Configure Storage
     |
     v
Launch Instance
     |
     v
SSH Connection
     |
     v
Install Nginx
     |
     v
Allow HTTP Port 80
     |
     v
Access Web Server
```

---

# 1. What is Amazon EC2?

**Amazon EC2 (Elastic Compute Cloud)** is an AWS service that provides virtual machines in the cloud.

Instead of purchasing and maintaining a physical server, you can create an EC2 instance within AWS and use it as a virtual server.

An EC2 instance can be used for:

* Web applications
* APIs
* Backend services
* Nginx
* Node.js applications
* Python applications
* Development environments
* Testing environments
* Cloud infrastructure

The main advantage is that infrastructure can be created and managed dynamically without purchasing physical hardware.

---

# 2. Understanding an EC2 Instance

An EC2 instance is essentially a virtual machine running inside AWS.

A simplified architecture is:

```text
AWS Cloud
   |
   v
EC2 Instance
   |
   +---- CPU
   |
   +---- RAM
   |
   +---- Storage
   |
   +---- Network
   |
   +---- Operating System
```

When launching an EC2 instance, you decide how much compute, memory, storage, and networking capacity it should have.

---

# 3. Amazon Machine Image (AMI)

An **AMI (Amazon Machine Image)** defines the initial operating-system environment of the EC2 instance.

The lecture demonstrates selecting an Ubuntu-based AMI.

For example:

```text
Ubuntu
   |
   v
EC2 Instance
```

An AMI can contain:

* Operating system
* System configuration
* Pre-installed software
* Required packages
* Other configuration information

The AMI you select affects the environment in which your application will run.

---

# 4. Selecting Ubuntu

The lecture demonstrates using an Ubuntu Linux image.

Ubuntu is commonly used for cloud servers because it provides:

* Linux-based server environment
* Package management through APT
* SSH support
* Nginx support
* Large software ecosystem
* Compatibility with many development tools

The lecture specifically discusses Ubuntu 22.04 as an example.

---

# 5. EC2 Instance Types

After selecting an AMI, you must select an **instance type**.

The instance type determines the compute resources available to the virtual machine.

An instance type defines resources such as:

* CPU
* Memory
* Network performance
* Instance capabilities

The general idea is:

```text
Instance Type
      |
      +---- CPU
      +---- Memory
      +---- Network
      +---- Performance
```

---

# 6. EC2 Instance Families

AWS provides different instance families for different workloads.

The lecture discusses categories including:

### General Purpose

Designed for balanced workloads.

Suitable for:

* Web applications
* Development environments
* Small APIs
* General server workloads

### Compute Optimized

Designed for workloads requiring higher CPU performance.

Suitable for:

* CPU-intensive applications
* High-performance processing
* Compute-heavy workloads

### Memory Optimized

Designed for applications requiring large amounts of memory.

Suitable for:

* Memory-intensive applications
* Large in-memory workloads
* Certain database workloads

---

# 7. Instance Family Naming

The lecture discusses families such as:

```text
T2
T3
M8
```

Different instance families target different workload characteristics.

For example:

```text
T Family
   |
   +---- General / burstable workloads

M Family
   |
   +---- General-purpose workloads
```

The exact instance type should be selected according to the application's resource requirements.

---

# 8. Choosing T3.micro

The lecture demonstrates the use of a small instance type such as:

```text
T3.micro
```

T3 instances are part of the burstable general-purpose family.

A small instance such as `T3.micro` can be useful for:

* Learning AWS
* Small development projects
* Testing
* Lightweight web servers
* Small applications

The lecture also discusses `T2.micro` depending on regional availability.

---

# 9. AWS Free Tier

The lecture explains the AWS Free Tier concept and discusses an allowance of approximately:

```text
750 hours / month
```

For an eligible small EC2 instance, this can allow a single instance to run continuously within the stated monthly allowance.

For example, a 31-day month contains:

```text
31 × 24 = 744 hours
```

Therefore:

```text
744 hours < 750 hours
```

This means one eligible instance running continuously for a 31-day month falls within the 750-hour example discussed in the lecture.

However, actual AWS Free Tier eligibility, limits, and pricing depend on the AWS account, service, instance type, region, and current AWS pricing policies.

---

# 10. Region and Pricing

AWS infrastructure is distributed across geographical **Regions**.

The selected region can affect:

* Available instance types
* Pricing
* Resource availability
* Network latency
* Service availability

Therefore, when launching an EC2 instance, always verify that the selected instance type is available in the chosen region.

---

# 11. Creating an EC2 Instance

## Step 1 — Open EC2

Open the AWS Management Console.

Navigate to:

```text
AWS Console
   |
   v
EC2
   |
   v
Instances
   |
   v
Launch Instance
```

---

# 12. Step 2 — Give the Instance a Name

Give the instance a meaningful name.

Example:

```text
DevOps Dash
```

Other examples:

```text
development-server
web-server
python-api
nginx-server
```

Using descriptive names makes it easier to identify instances when managing multiple servers.

---

# 13. Step 3 — Select an AMI

Under **Application and OS Images**, select the required AMI.

For the setup demonstrated in the lecture, select an Ubuntu image.

Conceptually:

```text
AMI
 |
 +---- Ubuntu
       |
       +---- Linux Operating System
```

---

# 14. Step 4 — Select Instance Type

Select an appropriate instance type.

Example:

```text
T3.micro
```

Depending on the region and availability, the lecture also references:

```text
T2.micro
```

The instance type determines the compute resources available to your server.

---

# 15. Step 5 — Select Key Pair

An SSH key pair is required to securely connect to the Linux EC2 instance.

Example:

```text
DEV-PEM-KP
```

The private key will be downloaded as:

```text
DEV-PEM-KP.pem
```

The `.pem` file must be kept secure.

Do not expose or publicly upload the private key.

---

# 16. Step 6 — Configure Networking

The networking section controls how the EC2 instance communicates with other resources and the internet.

Important networking components include:

* VPC
* Subnet
* Public IP
* Security Group

A basic public web server can use:

```text
Internet
   |
   v
Public IP
   |
   v
EC2 Instance
```

---

# 17. VPC

A **VPC (Virtual Private Cloud)** is the isolated virtual network in which AWS resources are deployed.

Conceptually:

```text
AWS
 |
 +---- VPC
       |
       +---- Subnet
              |
              +---- EC2
```

The VPC provides the networking foundation for EC2 instances.

---

# 18. Subnet

A subnet is a smaller network segment inside a VPC.

For a basic publicly accessible EC2 server, the instance can be placed in a subnet configured for public connectivity.

The lecture also introduces public/private subnet architecture in the following lecture.

---

# 19. Public IPv4 Address

To connect to the EC2 instance directly from your laptop over the internet, the instance needs a reachable public IP configuration.

The basic architecture is:

```text
Your Laptop
     |
     | Internet
     v
Public IPv4 Address
     |
     v
EC2 Instance
```

Without appropriate public connectivity, direct SSH access from your laptop will not work.

---

# 20. Security Groups

A **Security Group** acts as a virtual firewall for the EC2 instance.

It controls which network traffic can reach the instance.

For example:

```text
Internet
   |
   +---- Port 22 ----> SSH
   |
   +---- Port 80 ----> HTTP
```

Security Groups are therefore a critical part of EC2 security.

---

# 21. SSH Security Group Rule

SSH uses:

```text
Port: 22
Protocol: TCP
```

A typical rule is:

```text
Type: SSH
Port: 22
Source: Your IP
```

Restricting SSH access to your IP is preferable to unnecessarily exposing SSH to the entire internet.

---

# 22. HTTP Security Group Rule

For an Nginx web server, HTTP uses:

```text
Port: 80
Protocol: TCP
```

If the website should be publicly accessible, the Security Group can allow:

```text
Type: HTTP
Port: 80
Source: 0.0.0.0/0
```

This allows HTTP requests from the internet.

The architecture becomes:

```text
Internet
    |
    | HTTP : 80
    v
Security Group
    |
    v
EC2
    |
    v
Nginx
```

---

# 23. Storage Configuration

EC2 instances use **Amazon EBS (Elastic Block Store)** for persistent block storage.

The launch wizard provides a storage configuration where you can select:

* Volume size
* Volume type
* Device
* Delete-on-termination behavior

The lecture discusses a default storage configuration and a Free Tier storage allowance example.

The important concept is that EBS storage is separate from the compute capacity of the EC2 instance.

---

# 24. Launch the Instance

After configuring:

* Name
* AMI
* Instance type
* Key pair
* VPC
* Subnet
* Public IP
* Security Group
* Storage

select:

```text
Launch Instance
```

AWS will create the virtual machine.

The instance will initially go through a startup process.

---

# 25. Verify Instance Status

After launching, check the EC2 dashboard.

The instance should eventually show a running state and pass its status checks.

Conceptually:

```text
Pending
   |
   v
Running
   |
   v
Status Checks Passed
```

Once the instance is running and reachable, you can connect through SSH.

---

# 26. Find the Public IP Address

Open the EC2 instance details.

Locate:

```text
Public IPv4 address
```

Example:

```text
13.215.224.161
```

This is only an example. Your instance will have its own public IP.

---

# 27. Connect to EC2 Using SSH

From your Linux terminal:

```bash
ssh -i DEV-PEM-KP.pem ubuntu@<PUBLIC_IP>
```

Example:

```bash
ssh -i DEV-PEM-KP.pem ubuntu@13.215.224.161
```

The command consists of:

```text
ssh
 |
 +---- -i DEV-PEM-KP.pem
 |
 +---- ubuntu@
 |
 +---- Public IP
```

---

# 28. Fix PEM Permission Error

One of the most common SSH issues is incorrect private-key permissions.

Run:

```bash
chmod 400 DEV-PEM-KP.pem
```

Then connect again:

```bash
ssh -i DEV-PEM-KP.pem ubuntu@<PUBLIC_IP>
```

The purpose of:

```bash
chmod 400
```

is to restrict access to the private key.

The key should not be readable by other users on the system.

---

# 29. Successful SSH Connection

After successful authentication, you should receive a shell on the remote EC2 server.

Conceptually:

```text
Your Laptop
     |
     | SSH
     v
Internet
     |
     v
AWS EC2
     |
     v
Ubuntu Shell
```

You are now managing the remote Linux server from your local machine.

---

# 30. Update the Server

After connecting to Ubuntu, update the package information:

```bash
sudo apt update
```

You can also upgrade installed packages:

```bash
sudo apt upgrade -y
```

---

# 31. Install Nginx

Install Nginx using:

```bash
sudo apt install nginx -y
```

After installation, check its status:

```bash
sudo systemctl status nginx
```

If Nginx is running, the server is ready to handle HTTP requests.

---

# 32. Start Nginx

If Nginx is not running:

```bash
sudo systemctl start nginx
```

To configure Nginx to start automatically after boot:

```bash
sudo systemctl enable nginx
```

---

# 33. Test Nginx Locally

From inside the EC2 instance:

```bash
curl http://localhost
```

If Nginx is working, it should return the default Nginx HTML response.

This verifies that:

```text
EC2
 |
 v
Nginx
 |
 v
HTTP Server
```

is working locally.

---

# 34. Allow HTTP Traffic

Installing Nginx alone does not automatically make it accessible from the internet.

The EC2 Security Group must allow inbound HTTP traffic.

Add:

```text
Type: HTTP
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

The request path becomes:

```text
Internet
    |
    | TCP : 80
    v
Security Group
    |
    | Allowed
    v
EC2
    |
    v
Nginx
```

---

# 35. Access Nginx From the Browser

Open your browser and enter:

```text
http://<PUBLIC_IP>
```

Example:

```text
http://13.215.224.161
```

If the Security Group and Nginx configuration are correct, the default Nginx page should appear.

---

# 36. Complete EC2 Deployment Flow

The entire process can be summarized as:

```text
AWS Console
     |
     v
EC2
     |
     v
Launch Instance
     |
     +---- Name
     |
     +---- AMI
     |
     +---- Instance Type
     |
     +---- Key Pair
     |
     +---- VPC
     |
     +---- Subnet
     |
     +---- Public IP
     |
     +---- Security Group
     |
     +---- EBS Storage
     |
     v
Launch
     |
     v
Running EC2
     |
     v
Get Public IP
     |
     v
chmod 400 key.pem
     |
     v
SSH
     |
     v
Ubuntu Server
     |
     v
Install Nginx
     |
     v
Allow HTTP : 80
     |
     v
Open Public IP
     |
     v
Nginx Web Server
```

---

# 37. Important Commands

## SSH

```bash
ssh -i key.pem ubuntu@<PUBLIC_IP>
```

## Fix Key Permissions

```bash
chmod 400 key.pem
```

## Update Packages

```bash
sudo apt update
```

## Upgrade Packages

```bash
sudo apt upgrade -y
```

## Install Nginx

```bash
sudo apt install nginx -y
```

## Start Nginx

```bash
sudo systemctl start nginx
```

## Enable Nginx on Boot

```bash
sudo systemctl enable nginx
```

## Check Nginx

```bash
sudo systemctl status nginx
```

## Test Nginx

```bash
curl http://localhost
```

---

# 38. EC2 Launch Checklist

* [ ] Open AWS EC2
* [ ] Select the required AWS Region
* [ ] Click Launch Instance
* [ ] Provide an instance name
* [ ] Select Ubuntu AMI
* [ ] Select an appropriate instance type
* [ ] Select or create an SSH key pair
* [ ] Configure the VPC
* [ ] Select the subnet
* [ ] Configure public IPv4 connectivity if required
* [ ] Configure the Security Group
* [ ] Allow SSH on port 22 from an appropriate source
* [ ] Allow HTTP on port 80 if hosting a public website
* [ ] Configure EBS storage
* [ ] Launch the instance
* [ ] Wait for the instance to become running
* [ ] Copy the public IPv4 address
* [ ] Set `.pem` permissions with `chmod 400`
* [ ] Connect through SSH
* [ ] Update Ubuntu
* [ ] Install Nginx
* [ ] Verify Nginx
* [ ] Access the public IP from a browser

---

# 39. Key Concepts From Lecture 27

## EC2

Cloud-based virtual machines provided by AWS.

## AMI

The image used as the initial operating-system and software environment for an EC2 instance.

## Instance Type

Defines the compute resources available to the EC2 instance.

## Instance Family

Groups EC2 instance types according to their intended workloads and resource characteristics.

## VPC

The virtual network in which AWS resources are deployed.

## Subnet

A network segment inside a VPC.

## Public IP

An internet-reachable IP address that can be used for external connectivity when networking and security rules permit it.

## Security Group

A virtual firewall controlling inbound and outbound traffic for an EC2 instance.

## Key Pair

A cryptographic mechanism used for secure SSH authentication.

## EBS

AWS block storage attached to EC2 instances.

## SSH

A secure protocol used to remotely access Linux servers.

## Nginx

A web server that can serve HTTP requests from the EC2 instance.

---

# 40. Security Best Practices

### Restrict SSH

Avoid unnecessarily allowing:

```text
SSH
22
0.0.0.0/0
```

Instead, restrict SSH to a trusted source IP whenever possible.

### Protect PEM Files

Never commit private keys to Git repositories.

Do not upload them to public websites or messaging platforms.

Use:

```bash
chmod 400 key.pem
```

### Expose Only Required Ports

For a basic web server:

```text
22  -> SSH
80  -> HTTP
```

Only expose additional ports when the application actually requires them.

### Monitor Costs

EC2 follows AWS's usage-based billing model. Always monitor running resources, storage, and other associated services.

---

# 41. EC2 Pricing Concept

The lecture explains the cloud's **pay-as-you-go** model.

Instead of purchasing physical infrastructure:

```text
Traditional Infrastructure
        |
        +---- Buy Server
        +---- Buy Storage
        +---- Buy Network Equipment
        +---- Maintain Hardware
```

Cloud infrastructure works more like:

```text
AWS
 |
 +---- Create Resource
 |
 +---- Use Resource
 |
 +---- Pay According to Usage
```

This makes it possible to start with relatively small infrastructure and increase resources as requirements grow.

---

# 42. Important Cost Considerations

When using EC2, cost can come from multiple resources, including:

* EC2 compute
* EBS storage
* Public IPv4 resources where applicable
* Data transfer
* Other AWS services attached to the infrastructure

Therefore, do not assume that an EC2 instance is the only potential source of AWS charges.

Always check the current AWS pricing and Free Tier terms for your account and region before deploying production infrastructure.

---

# 43. Lecture 27 vs Lecture 28

Lecture 27 focuses primarily on **creating and configuring an individual EC2 instance**.

```text
Lecture 27
     |
     +---- Launch EC2
     +---- AMI
     +---- Instance Type
     +---- Key Pair
     +---- VPC
     +---- Security Group
     +---- EBS
     +---- SSH
     +---- Nginx
     +---- Public Web Access
```

Lecture 28 builds on this foundation and introduces a more secure architecture using **public and private subnets**.

```text
Lecture 28
     |
     +---- Public Subnet
     |       |
     |       +---- Jump Server
     |
     +---- Private Subnet
             |
             +---- Backend EC2
```

Understanding Lecture 27 first makes the networking and security architecture in Lecture 28 easier to understand.

---

# 44. Final Architecture From Lecture 27

The practical deployment demonstrated in this lecture can be represented as:

```text
                    Internet
                       |
                       |
                 Public IPv4
                       |
                       v
              +----------------+
              | Security Group |
              |                |
              | SSH : 22       |
              | HTTP : 80      |
              +-------+--------+
                      |
                      v
               +-------------+
               | EC2 Ubuntu  |
               |             |
               |    Nginx    |
               +-------------+
                      |
                      v
                 Web Browser
```

The key idea is that AWS allows you to create a complete server environment in minutes by combining compute, networking, storage, security, and operating-system configuration.

---

# Conclusion

Lecture 27 provides the foundation for working with AWS EC2.

The complete process starts with selecting an **AMI** and **instance type**, followed by configuring the **key pair, VPC, subnet, public IP, Security Group, and EBS storage**.

After launching the instance, SSH provides remote access to the Ubuntu server. The `.pem` key must have appropriate permissions, commonly configured using:

```bash
chmod 400 key.pem
```

Once connected, Nginx can be installed and configured as a web server:

```bash
sudo apt update
sudo apt install nginx -y
```

Finally, allowing inbound HTTP traffic on **port 80** through the EC2 Security Group makes the Nginx server accessible through the instance's public IP.

Lecture 27 therefore establishes the fundamental EC2 workflow:

```text
Create
  |
Configure
  |
Launch
  |
Connect
  |
Install
  |
Secure
  |
Deploy
  |
Access
```

These concepts form the foundation for the more advanced EC2 networking and public-private subnet architecture introduced in **Lecture 28**.
