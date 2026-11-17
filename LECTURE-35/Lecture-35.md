# Lecture 35: Monorepo vs Polyrepo, Multi-Stage Builds & Docker Compose

## 1. Git Repository Structures

### Monorepo
One repo holds **everything** (frontend, backend, scripts).

- Easy refactoring and shared dependencies
- Atomic commits across the whole app
- Can get unwieldy as the team and code grow
- Best for: small teams, tightly coupled code

### Polyrepo
**Separate repos** per service or component.

- Clear ownership and isolation
- Scales well for large or distributed teams
- Cross-repo changes and dependency management are harder
- Best for: separate frontend/backend teams, big companies (AWS, Azure style)

### Quick Comparison

| | Monorepo | Polyrepo |
|---|---|---|
| Repos | 1 | Many |
| Team fit | Small, multi-role | Large, specialized |
| Refactoring | Easy | Harder |
| Ownership | Shared | Clear boundaries |

**Rule:** the repo structure should match your team and app structure.

## 2. Why Docker Again? Version Conflicts

Example: the React frontend needs **Node 20**, but the backend needs **Node 24**. You can't easily install both on one machine.

**Docker fix:** each container has its own runtime, so both versions run side by side with no conflict.

### Core Terms

| Term | Meaning |
|---|---|
| **Image** | Immutable template (base image or custom image with your code) |
| **Container** | A running instance of an image |
| **Dockerfile** | Script that defines how to build an image |

## 3. Multi-Stage Builds (React Frontend)

React source code can't be served directly. It must be **built** into static files (HTML/CSS/JS), then served by Nginx.

- **Stage 1 (build):** Node image, install dependencies, run the build.
- **Stage 2 (serve):** small Nginx image, copy only the build output.

```dockerfile
# Stage 1: build
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG API_URL
RUN npm run build

# Stage 2: serve
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
```

**Why:** a much smaller final image, which means faster deploys.

## 4. Docker Compose

**Problem:** with 3 containers (DB, backend, frontend), running each `docker build` and `docker run` by hand is messy.

**Solution:** one `docker-compose.yml` file defines everything.

### What You Define Per Service

| Setting | Purpose |
|---|---|
| `build` / `image` | Where the Dockerfile is, or which image to use |
| `ports` | Host-to-container port mapping |
| `environment` | Credentials, URLs, config |
| `volumes` | Persistent storage |
| `depends_on` | Startup order |

### Start the Whole Stack

```bash
docker-compose up -d --build
```

One command replaces many Docker commands.

## 5. The 3-Container Example

### Database: MongoDB
- Uses the official MongoDB image.
- Environment variables set the username and password.
- A **volume** keeps data on the host so it isn't lost.

### Backend: Node.js
- Built from a local folder (build context).
- Gets the MongoDB connection URI through an environment variable.
- Exposes its port.

### Frontend: React + Nginx
- Built with a multi-stage Dockerfile.
- Uses a **build argument** for the backend API URL.

### Sketch

```yaml
services:
  db:
    image: mongo
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: secret
    volumes:
      - mongo_data:/data/db

  backend:
    build: ./backend
    environment:
      MONGO_URI: mongodb://admin:secret@db:27017
    ports:
      - "5000:5000"
    depends_on:
      - db

  frontend:
    build:
      context: ./frontend
      args:
        API_URL: http://localhost:5000
    ports:
      - "3000:80"
    depends_on:
      - backend

volumes:
  mongo_data:
```

### Startup Order (`depends_on`)

`db` → `backend` → `frontend`

This prevents errors from starting a service before the one it needs is ready.

## 6. Build-Time vs Run-Time Config

- **Build time (`ARG`):** needed while building, e.g. the frontend needs the backend API URL.
- **Run time (`environment`):** needed while running, e.g. the backend needs the MongoDB URI.

This lets you build an image once and configure it differently per environment.

## Quick Summary

1. **Monorepo** = one repo for all, good for small teams. **Polyrepo** = many repos, good for large teams.
2. Docker isolates runtimes, so different Node versions can coexist.
3. **Multi-stage builds** compile in one stage and serve from a tiny Nginx image.
4. **Docker Compose** defines the whole stack in one YAML file.
5. Key Compose settings: `build`, `ports`, `environment`, `volumes`, `depends_on`.
6. Use **volumes** to protect database data.
7. Use **ARG** for build-time config and **environment** for run-time config.
8. One command, `docker-compose up -d --build`, runs the entire app.