# Lecture 40: Load Balancing & Auto Scaling on AWS

## 1. The Problem: Traffic Spikes

**Example: Daraz flash sale.** Normal traffic is small, then suddenly a huge number of users arrive. With fixed server capacity, the app slows down or crashes.

**Solution:**
- Run **multiple server copies (replicas)**
- Use a **load balancer** to spread requests across them
- Use **auto scaling** to add or remove servers automatically

## 2. Load Balancer Basics

A **load balancer (LB)** sits in front of your servers and distributes incoming requests.

- Internet-facing: users hit the LB, and the LB forwards to **private** servers.
- Replaces the old single reverse proxy with something scalable.
- Prevents one server from being overloaded.

## 3. Three AWS Load Balancer Types

| Type | OSI Layer | Protocols | Use for |
|---|---|---|---|
| **ALB** (Application) | Layer 7 | HTTP, HTTPS, WebSocket | Web apps, path/host-based routing |
| **NLB** (Network) | Layer 4 | TCP, UDP, TLS | High performance, non-HTTP traffic |
| **GWLB** (Gateway) | Layer 3/4 | IP-based | Firewalls, security appliances |

Choose based on the protocol and what your app needs.

## 4. Key Components

### Target Group
A group of servers (targets) that the LB sends traffic to.

### Health Checks
The LB tests each target before sending traffic.

- Set the **path** and the **success codes**.
- Configure **success and failure thresholds**.
- Customize for apps that return non-200 responses while healthy (e.g. **401** for an unauthorized-but-working endpoint).

### Listener and Rules
- A **listener** waits on a port and protocol (e.g. 80 or 443).
- **Rules** decide what happens: forward to a target group or return a fixed response.

## 5. Demo Flow: ALB with Multiple Web Servers

1. Launch **EC2 instances** (web servers).
2. Set up **security groups**.
3. Create a **target group** and register the instances.
4. Create an **Application Load Balancer** with a listener.
5. Forward listener traffic to the target group.
6. Test: requests now spread across the servers.

## 6. Auto Scaling Groups (ASG)

Auto scaling changes the **number of instances** based on demand.

### Key Pieces

| Piece | Meaning |
|---|---|
| **Launch template** | Blueprint for new instances (OS/AMI, instance type, security groups) |
| **Min / Max / Desired** | Smallest, largest and target instance counts |
| **Scaling policy** | Rule that triggers scaling (e.g. CPU %, request count) |
| **Lifecycle behavior** | How instances start, run and terminate |

### Example
Normal: 2 instances. Sale spike: CPU rises, so scale out to 10. Traffic drops, so scale back in to 2.

## 7. Load Balancing vs Auto Scaling

| | Load Balancing | Auto Scaling |
|---|---|---|
| Job | **Distributes** requests | **Adjusts** the number of instances |
| Question it answers | "Which server handles this request?" | "How many servers do we need?" |

They work **together**: the ASG adds instances, and the LB sends traffic to them.

## 8. Best Practices

- **One purpose per machine** (don't mix roles).
- Private instances need internet access? Use a **proxy** or **NAT gateway**.
- Automate setup with **user-data scripts** (e.g. install Docker and run containers).
- Use proper **tagging**.
- **Document** the infrastructure: private/public IPs, security group rules, server roles.
- Plan **version rollouts** and maintenance.
- Automation and documentation prevent **configuration drift**.

## Quick Summary

1. Traffic spikes crash fixed-capacity apps, so use replicas, an LB and auto scaling.
2. **ALB** = Layer 7 (HTTP), **NLB** = Layer 4 (TCP/UDP), **GWLB** = Layer 3/4 (IP).
3. LB parts: **target groups**, **health checks**, **listeners and rules**.
4. Customize health check codes if the app returns something like 401 while healthy.
5. ASG uses a **launch template**, **min/max/desired** counts and **scaling policies**.
6. LB distributes requests, ASG changes instance count, and together they give resilience.
7. Use user-data scripts, tags and documentation to stay organized.