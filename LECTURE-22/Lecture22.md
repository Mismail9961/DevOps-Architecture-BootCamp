# Lecture 22 — AWS IAM: Policies, Groups & User Management

---

## Account Alias
- An **account alias** replaces the default numeric AWS account ID with a friendly name.
- Makes sign-in easier and more usable — especially helpful if the root account or MFA device is temporarily unavailable.

---

## IAM Policies — The Access Backbone
- Policies are **JSON-based documents** that define what actions are **allowed or denied**.
- Administrators should be comfortable reading/writing JSON, though AWS also provides a **visual policy editor**.

### Types of Policies
| Policy Type | Description | Best Used For |
|---|---|---|
| **AWS Managed Policies** | Pre-built, standardized, tested by AWS | Development / less-critical environments |
| **Customer-Managed Policies** | Custom-written, grants only required permissions | Production environments (more secure, avoids over-broad access) |
| **Job-Function Policies** | Pre-defined sets aligned to common roles (e.g., admin, developer) | Quick-start role-based access |

### Granular Permission Levels
IAM permissions can be tiered for precise control:
- **View** — see a list of resources, no detail
- **Read** — view full resource details
- **Write** — modify/create/delete resources

This tiering supports the **principle of least privilege**.

### Custom Policy Example
- A **database admin** team might get a custom policy allowing them to **start/stop** servers — but *not* create or delete them — protecting critical infrastructure while still enabling operational needs.

---

## User Groups
- Assigning permissions directly to individual users is **error-prone and tedious**.
- **Groups** let admins manage permissions at scale:
  - Add a user to a group → they inherit all group permissions.
  - Remove a user from a group → permissions revoked instantly.
- Especially valuable for onboarding/offboarding staff and reducing manual mistakes.

---

## Creating IAM Users — Security Best Practices
- Enforce **password reset on first login**.
- Use **auto-generated passwords** rather than admin-set ones.
- Enable **multi-factor authentication (MFA)**.
- Assign users to the appropriate **group(s)** rather than attaching policies individually.

---

## Policy Simulator
- AWS's **Policy Simulator** lets admins **test permissions before applying them**.
- Confirms whether a user/group actually has the exact permissions intended.
- Prevents situations where permissions look correct on paper but fail in practice — streamlines troubleshooting.

---

## AWS Service Quotas
- AWS enforces **default limits (quotas)** on resources — e.g., number of EC2 instances, IAM users, or IAM groups.
- Important to **monitor quotas** in scaling environments to avoid hitting unexpected limits.
- Quotas can be **checked and increased** via a request to AWS when needed.

---

## Third-Party Identity Provider Integration
- IAM supports integrating with **external identity/authentication systems**.
- Lets organizations reuse their existing authentication frameworks (e.g., corporate SSO) instead of managing credentials solely within AWS.
- Improves security and streamlines user management at scale.

---

## Summary Takeaways
- Set an **account alias** early for easier, more resilient sign-in.
- Prefer **customer-managed policies** over AWS-managed ones in production for tighter security.
- Use **groups**, not individual user policies, to manage permissions at scale.
- Apply **least privilege** using view/read/write tiering and custom policies where needed.
- Always enforce **password reset + MFA** on new IAM users.
- Use the **Policy Simulator** to validate access before deploying it.
- Track **service quotas** proactively, especially as environments scale.
- Consider **third-party identity provider integration** for enterprise-scale user management.