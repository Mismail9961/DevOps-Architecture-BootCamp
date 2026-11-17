# Lecture 37: Deploying Docker Apps on AWS (ECR + EC2 + IAM Roles)

## 1. Quick Recap

- Containers, custom images, volumes, Docker Compose.
- Now we move from **local** to **cloud** deployment.

## 2. The Big Idea: Ship Images, Not Code

- Don't copy your source code onto production servers (security risk).
- Instead: **build image locally, push to a registry, pull on the server.**

```
Local machine --build/tag/push--> ECR (registry) --pull--> EC2 server
```

Two deployment styles:
- **Manual:** you do each step yourself (this lecture)
- **CI/CD:** an automated pipeline does it (later)

## 3. AWS ECR (Elastic Container Registry)

- A **private** registry for Docker images (alternative: Docker Hub).
- Create **one repository per image**, e.g. one for frontend and one for backend.
- Set **tag mutability = Immutable** so published tags can't be overwritten.

## 4. Tagging Strategy

- Use **semantic versions:** `0.1`, `0.1.1`, `0.2`, and so on.
- Never reuse or overwrite a tag that is already published.
- Benefits: auditability, safe rollbacks, consistent environments.

## 5. Push Workflow (Local Machine)

1. **Configure AWS CLI** with credentials and the **correct region**.
2. **Log in** Docker to ECR.
3. **Build** the image.
4. **Tag** it with the full ECR URI.
5. **Push** it.

```bash
aws configure                                   # set keys + region

aws ecr get-login-password --region <region> | \
  docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

docker build -t backend:0.1 ./backend
docker tag backend:0.1 <account-id>.dkr.ecr.<region>.amazonaws.com/backend:0.1
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/backend:0.1
```

### ECR URI Format

`<account-id>.dkr.ecr.<region>.amazonaws.com/<repo-name>:<tag>`

Repeat for the frontend image.

### Common Error: "Repository does not exist"

Cause: the AWS CLI **region** doesn't match the region where the repo was created.
Fix: set the correct region.

## 6. Deploying on EC2

On the EC2 instance:

1. Install **Docker** and the **AWS CLI**.
2. Authenticate Docker to ECR.
3. Pull the images.
4. Run them (or use Docker Compose).

## 7. IAM Roles (Secure Access Without Keys)

**Problem:** EC2 needs permission to pull from ECR, but you don't want to store AWS access keys on the server.

**Solution:** create an **IAM role** with ECR permissions and **attach it to the EC2 instance**.

- No credentials to copy or leak
- Permissions are granted automatically
- Safer and less work to manage

In the lecture, a custom role was created with access to the container registry and attached to the instance.

## 8. Docker Compose with Remote Images

Change `build:` to `image:` so servers pull ready-made images.

**Before (local):**
```yaml
backend:
  build: ./backend
```

**After (production):**
```yaml
backend:
  image: <account-id>.dkr.ecr.<region>.amazonaws.com/backend:0.1
```

Adjust ports and container names as needed.

## 9. Troubleshooting

| Issue | Cause / Fix |
|---|---|
| "Repository does not exist" | Wrong AWS CLI region |
| Permission denied on pull | IAM role missing or lacking ECR permissions |
| MongoDB container crashes | Check `docker logs`, config, volumes |
| Backend can't connect | App uses `localhost`, which must be changed to the correct host/public IP or service name |
| Frontend can't reach backend | Check networking and ports |

Typical cause: **dev vs production environment mismatch**.

## 10. Production Recommendation

- Self-managed EC2 with Docker is fine for **learning and early testing**.
- For production, move to **managed services**:
  - **ECS** (AWS-managed containers)
  - **EKS** (AWS-managed Kubernetes)
- These handle orchestration, scaling, and high availability.

## Quick Summary

1. Push **images** to a registry, not code to servers.
2. ECR = private registry; make tags **immutable**.
3. Use **semantic version** tags.
4. Flow: configure CLI (right region) → login → build → tag → push.
5. EC2 uses an **IAM role** to pull images, so no keys are needed.
6. In Compose, replace `build` with `image: <ECR URI>`.
7. Watch for region errors, permissions and `localhost` issues.
8. Move to **ECS/EKS** for real production.