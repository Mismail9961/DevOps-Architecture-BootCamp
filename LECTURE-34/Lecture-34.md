# Lecture 34: Docker Images, Dockerfiles, Versioning & Volumes

## 1. Image Versioning

- Docker images **cannot be edited in place**. Any code or config change means a **new image build** with a new tag.
- Tag styles:
  - **Semantic:** `v1`, `v1.1`, `v2`
  - **Date-time:** `20260101-1430` (automatic, no manual mistakes)
- Benefits: clear history, reproducibility, easy rollbacks.

### Dynamic Date-Time Tag (build script idea)

```bash
VERSION=$(date +%Y%m%d-%H%M%S)
docker build -t myapp:$VERSION .
```

Great for CI/CD because every build gets a unique, traceable tag.

## 2. Why Containers Save Money

- Many VMs = many full OS copies = more cost and licensing.
- Containers share the host OS kernel, so you can run many apps on one machine.
- Example: one T3 medium instead of several T3 micros.

## 3. Writing a Dockerfile

| Instruction | What it does |
|---|---|
| `FROM` | Choose a base image (e.g. `nginx:alpine`, `python:slim`) |
| `WORKDIR` | Set the working directory inside the image |
| `COPY` | Copy files from your machine into the image |
| `RUN` | Run a command while **building** (install packages, back up files) |
| `EXPOSE` | Document which port the app uses |
| `CMD` / `ENTRYPOINT` | Command that runs when the container **starts** |

Tip: keep a clean directory structure, because files must be where the app expects them.

## 4. Nginx Example

- Start from an Alpine-based Nginx image.
- Back up the default config inside the image:

```dockerfile
RUN cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
```

- Copy in your own config and custom HTML.
- Point the working directory/config at your HTML so Nginx serves it.

## 5. Python (FastAPI) Example

```dockerfile
FROM python:3.x-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

- Copy `requirements.txt` first, then install, so the build is self-contained.
- Use `--host 0.0.0.0` so the app is reachable from outside the container.

## 6. Running Containers

```bash
docker run -d -p 8080:8000 --name calc myapp:<tag>
```

- `-d` runs in the background.
- `-p host:container` maps ports. Use different host ports to avoid conflicts.
- `--name` gives the container a clear name.
- Remove the old container (`docker rm`) before reusing a name or port.

## 7. Troubleshooting with Logs

```bash
docker logs <container-name>
```

- Use it when a container crashes or exits right away.
- Common cause: **missing directory or file** inside the container.
- Fix the Dockerfile, rebuild with a new tag, and run again.

## 8. Volumes (Persistent Data)

**Problem:** container storage is temporary. Delete or restart the container and the data (like the JSON or database file) is lost.

**Solution:** mount a **volume** so data lives outside the container.

```bash
docker run -d -p 8080:8000 -v mydata:/app/data --name calc myapp:<tag>
```

- Data survives restarts and removals.
- Multiple containers can **share the same volume**.

## 9. What's Next

- **Docker Compose:** manage multi-container apps (frontend + backend + database) easily.
- **Git repo structures** used for Docker deployments.

## Quick Summary

1. New change = new image + new tag.
2. Date-time tags automate versioning.
3. Containers cut costs compared to VMs.
4. Dockerfile flow: `FROM` → `WORKDIR` → `COPY` → `RUN` → `EXPOSE` → `CMD`.
5. Use `docker logs` to debug crashes.
6. Use volumes to keep data safe.
7. Next up: Docker Compose.