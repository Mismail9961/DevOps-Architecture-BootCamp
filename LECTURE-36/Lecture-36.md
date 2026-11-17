    # Lecture 36: Docker Compose, Volumes & Health Checks

## 1. Why Docker Compose?

Without Compose, a full-stack app (DB + backend + frontend) needs many commands:

- Build each image
- Run each container with the right ports, env vars and volumes
- Start them in the right order

This is slow and error-prone.

**With Compose:** one `docker-compose.yml` handles build, start, stop, restart and dependencies.

```bash
docker-compose up -d --build    # build and start everything
docker-compose down             # stop and remove everything
docker-compose restart          # restart services
docker-compose ps               # check status
```

## 2. What Goes in `docker-compose.yml`

| Setting | Purpose |
|---|---|
| `services` | Each container (db, backend, frontend) |
| `build` / `image` | Where the Dockerfile is, or which image to use |
| `ports` | `hostPort:containerPort` mapping |
| `environment` | Config and credentials |
| `volumes` | Persistent data |
| `depends_on` | Startup order |
| `healthcheck` | How to test if the app is really working |

## 3. Volumes vs Local Path Mounts

| | Docker Volume | Local Path Mount (bind mount) |
|---|---|---|
| Example | `mongo_data:/data/db` | `./data:/data/db` |
| Managed by | Docker | You (host folder) |
| Best for | Databases, production | Development, sharing files with host |

- Define volumes explicitly and inspect them (`docker volume ls`, `docker volume inspect <name>`).
- Either way, data survives container restarts.

## 4. Health Checks

**Problem:** a container can be *running* while the app inside is broken or not responding.

**Solution:** a health check regularly tests the app, usually with an HTTP request to an endpoint.

```yaml
backend:
  build: ./backend
  ports:
    - "5000:3000"
  healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
    interval: 30s
    timeout: 5s
    retries: 3
    start_period: 20s
```

### Parameters

| Parameter | Meaning |
|---|---|
| `test` | The command that checks health |
| `interval` | How often to run the check |
| `timeout` | How long to wait for a response |
| `retries` | Failures allowed before marking **unhealthy** |
| `start_period` | Grace time for the app to boot before failures count |

Bad values can mark a container unhealthy too early, causing false alerts or restarts.

## 5. Troubleshooting: "Unhealthy" but Running

**Symptom:** the container is up, the app works, but the status says `unhealthy`.

**Root causes found:**
- Wrong port in the health check command
- Incorrect response handling in the check

### The Key Rule: Container Port vs Host Port

With `ports: "5000:3000"`:
- **5000** = host port (used from your browser)
- **3000** = container port (used **inside** the container)

**Health checks run inside the container, so they must use the container port (3000).**

### Debug Steps

```bash
docker ps                      # see STATUS (healthy/unhealthy)
docker inspect <container>     # see health check logs
docker logs <container>        # see app errors
```

## 6. Lightweight Base Images

- **Alpine** images are small, so builds and deploys are faster.
- Ubuntu or Debian-based images are also common and fine for many apps.
- The trade-off is usually minor for most projects.

## 7. Separate Databases per Project

Containerized databases can be kept separate for each project, each with its own volume, so they don't interfere with one another.

## 8. What's Next: Cloud & CI/CD

- Deploy Dockerized apps to **AWS EC2**.
- Use an image registry like **AWS ECR** to store images.
- Add **CI/CD pipelines** to build and push images automatically.
- Compose is a good first step before moving on to **Kubernetes**.

## Quick Summary

1. Compose replaces many Docker commands with one YAML file.
2. Use **volumes** for database data and **bind mounts** for development.
3. **Health checks** show whether the app works, not just whether the container is running.
4. Health checks use the **container port**, not the host port.
5. Tune `start_period`, `interval`, `timeout` and `retries` to avoid false "unhealthy" results.
6. Alpine images keep images small.
7. Next steps: EC2, ECR and CI/CD.