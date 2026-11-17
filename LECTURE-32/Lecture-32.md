# Lecture 32: Docker, Containers & Microservices

## 1. The Problem: "Works on My Machine"

- **Frontend** apps build into static files (HTML/CSS/JS), so they run on any web server.
- **Backend** apps (e.g. Python) need a specific runtime, version, and packages.
- Your laptop and the production server often differ in:
  - Operating system (Windows vs Linux)
  - Python version (e.g. 3.10 vs something else)
  - Installed packages and dependencies
- Result: the app crashes after deployment on the server (e.g. EC2).

## 2. The Solution: Docker

- **Docker** packages your app + runtime + dependencies into one **image**.
- Run that image anywhere and it behaves the same.
- Images are built from a **Dockerfile** (a recipe listing what's needed).
- **Docker Hub** has ready-made official images: Nginx, Python, Java, etc.

### Containers vs Virtual Machines

| | Container | Virtual Machine |
|---|---|---|
| OS | Shares host OS kernel | Full separate OS each |
| Size | Lightweight | Heavy |
| Startup | Fast | Slow |
| Isolation | Process-level | Full |

## 3. Microservices

- **Monolith:** one big app. To scale, you scale everything together.
- **Microservices:** split into small services (e.g. auth, projects, payments). Each runs in its own container.
- Benefits:
  - Scale only the part that's busy
  - One service failing doesn't kill the whole app
  - Teams can work and deploy independently
  - Saves cost

## 4. Orchestration

Managing many containers by hand is impossible, so we use orchestration tools:

- **Kubernetes (K8s):** industry standard. Handles deployment, scaling, health checks, rolling updates, and rollbacks.
- **Docker Swarm:** Docker's own, simpler option.

## 5. Auto-Scaling & Load Balancing

- **Auto-scaling:** automatically adds or removes instances based on load (CPU, RAM).
  - Example: an e-commerce sale spikes traffic, so it scales from 1 to 10 instances, then back down.
- **Load balancer:** spreads incoming requests across all instances.

## 6. AWS Deployment Options

| Service | What it is | Use for |
|---|---|---|
| **EC2** | Plain virtual server | Dev/testing, monolith apps |
| **ECS** | AWS-managed Docker containers | Production |
| **EKS** | AWS-managed Kubernetes | Production (large scale) |

**Rule of thumb:** Development = correctness (keep it simple). Production = performance and reliability.

## 7. Key Docker Commands

```bash
docker pull <image>          # download an image
docker run -d -p 8080:80 --name web nginx   # run in background with port mapping
docker ps                    # list running containers
docker stop <name>           # stop a container
docker start <name>          # start it again
docker restart <name>        # restart it
docker rm <name>             # remove a container
```

### Port Mapping

`-p <hostPort>:<containerPort>`

Two containers can both use port 80 inside, as long as they map to different host ports:

- Container A: `-p 8080:80`
- Container B: `-p 8081:80`

## 8. Assignment

Build a simple **Python calculator web app**:

- Python API backend + basic frontend using **Jinja templates**
- Save operation history in a **JSON file** (acts as a simple database)
- Then:
  1. Write a **Dockerfile**
  2. Containerize the app
  3. Run it with a **volume** so data persists outside the container

## Quick Summary

1. Backend apps depend on their environment, which causes deployment failures.
2. Docker bundles app + dependencies so it runs the same everywhere.
3. Containers are lighter than VMs.
4. Microservices let you scale only what you need.
5. Kubernetes/Swarm manage containers at scale.
6. Auto-scaling + load balancing = good performance at lower cost.
7. Dev on EC2, production on ECS/EKS.