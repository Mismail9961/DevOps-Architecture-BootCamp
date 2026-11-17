# Lecture 41: Configuring Auto Scaling Groups with a Load Balancer

## 1. Quick Recap

- **Load balancer (LB):** spreads traffic across healthy instances.
- **Auto Scaling Group (ASG):** adds or removes instances based on demand, and helps control cost.
- The LB sends traffic only to instances that **pass health checks**.

## 2. Live Demo: Changing Desired Capacity

- Change the ASG **desired capacity from 0 to 1**.
- The ASG automatically **launches a new instance**.
- The instance first showed **unhealthy**. Two causes:
  1. **Security group** misconfigured
  2. **Startup delay**, because the user-data script (installing NGINX) takes time

## 3. Why Health Checks Failed

| Cause | Explanation | Fix |
|---|---|---|
| Security group rules | Health check port or traffic blocked | Allow the app/health check port from the LB's security group |
| Slow bootstrapping | NGINX still installing when the check runs | Increase timeouts, thresholds or grace period |
| Script typo | Error in the user-data script | Fix the **launch template** |

**Lesson:** health check timing must match how long your app takes to start.

## 4. Launch Templates

- A launch template is the blueprint for every new instance (AMI, type, security groups, user data).
- Fix the typo in the template, then use the **latest version** in the ASG.
- New instances then launch with correct, consistent configuration. No manual fixes per instance.

## 5. Instance Management Policies

- Terminate old instances **only after new ones are healthy**.
- This avoids downtime during updates and rollouts.

## 6. Health Check Best Practices

- Tune **timeout**, **interval**, **healthy/unhealthy thresholds** to fit real startup time.
- Too aggressive means premature failures and instances being cycled.
- Check the **path** and **success codes** match your app.

## 7. Security: Don't Expose Backend Servers

- Don't give backend EC2 instances direct internet access.
- Put a **load balancer or reverse proxy** in front.
- Use separate **security groups** for frontend and backend traffic.
- Benefits:
  - Smaller attack surface
  - Central monitoring and access control
  - SSL termination at one point

## 8. Path-Based Routing (One LB, Multiple Apps)

You don't need a separate LB per app. Use **listener rules** with **multiple target groups**.

| Path | Goes to |
|---|---|
| `/` | Frontend target group |
| `/api` | Backend target group |

Benefits:
- Saves cost and resources
- Fits microservices
- Frontend and backend share a single entry point

## 9. How It All Fits Together

```
User -> Load Balancer (listener rules)
          |-- "/"     -> Frontend target group -> ASG instances
          |-- "/api"  -> Backend target group  -> ASG instances
```

ASG keeps the right number of instances, and the LB routes only to the healthy ones.

## 10. Coming Up

- Securing the setup with a **free domain name** (and HTTPS).
- Cloud certification and course logistics updates.

## Quick Summary

1. Changing **desired capacity** makes the ASG launch or terminate instances.
2. New instances fail health checks if security groups are wrong or startup is slow.
3. Match health check timeouts and thresholds to real startup time.
4. Fix problems in the **launch template**, then use the latest version.
5. Replace old instances only after new ones are healthy.
6. Keep backends private, with the LB or a proxy as the only entry point.
7. Use **path-based routing** (`/`, `/api`) to serve several apps from **one** LB.