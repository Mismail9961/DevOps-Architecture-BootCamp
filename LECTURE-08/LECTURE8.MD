# Introduction to Web Servers and Nginx Configuration

## Summary
The session begins with a recap of shell scripting and quickly transitions into the core topic: web servers. The instructor explains the fundamental architecture of web applications, distinguishing between frontend and backend components, and the difference between static and dynamic websites. Frontend components render user interfaces in browsers using HTML, CSS, and JavaScript, while backend handles server-side logic and database operations.

A detailed explanation of web server roles follows, introducing common web servers like Apache, IIS, and Nginx—the latter being emphasized due to its prevalence in Linux and DevOps environments. The instructor demonstrates installing, troubleshooting, and configuring Nginx on Linux, with a focus on key configuration files and concepts such as worker processes, permissions, and including modular configuration files.

Next, HTTP and HTTPS protocols are explained along with their standard ports (80 and 443). The transcript delves deep into HTTP status codes, classified into success (2xx), redirection (3xx), client errors (4xx), and server errors (5xx), with examples provided for common codes and their meanings.

The importance of domain names (DNS) and domain registration processes is covered, explaining how domains map to public IP addresses. The instructor walks through interactions with domain registrars, DNS record setups, and pricing details for domains. The lecture ends with a glimpse into subdomain usage and management.

Throughout, practical command-line demonstrations on Linux reinforce the theoretical concepts, showing real-time troubleshooting, configuration edits, and server status checks.

## Highlights
- 🌐 Explanation of web application architecture: frontend (UI) vs backend (logic/database).
- ⚙️ Introduction and installation of Nginx web server on Linux.
- 🔑 Detailed walkthrough of Nginx configuration files and process management.
- 🔒 The role of HTTP/HTTPS protocols and their default ports in web communication.
- 📊 Comprehensive overview of HTTP status codes (2xx, 3xx, 4xx, 5xx) with real examples.
- 🌍 Domain name system (DNS) explained, including domain registration and DNS record setup.
- 💡 Practical Linux commands demonstration to install, configure, and troubleshoot web servers.

## Key Insights
- 🌟 **Separation of Concerns in Web Apps:** Understanding that frontend handles the user interface, while backend manages data processing and storage, is critical for web development and deployment. This allows developers to optimize client-server interactions and design better user experiences.

- 🐧 **Nginx Dominance in Linux-based Environments:** The emphasis on Nginx over other servers like Apache or IIS highlights the modern trend where Nginx is preferred for its efficiency, simplicity, and scalability in handling web traffic, especially in DevOps pipelines.

- 🔧 **Modular and Secure Configuration Management:** Nginx uses a modular approach where the main configuration file includes other configuration files, separating concerns like modules, sites, and logs. Also, strict file permission management (user www-data) ensures security by limiting access.

- 📡 **HTTP(S) as the Backbone of Web Communication:** HTTP and HTTPS protocols define how browsers and servers communicate, with HTTPS adding encryption (via secure ciphers). Ports 80 (HTTP) and 443 (HTTPS) are standards, enabling consistent web access and security.

- 📉 **HTTP Status Codes as Diagnostic Tools:** The categorization of HTTP status codes offers insights into request outcomes, redirect behavior, client errors like unauthorized access, and server failures. Developers and sysadmins rely on these codes to debug and optimize applications.

- 🌐 **Domain Registration and DNS Mapping:** Domains serve as user-friendly addresses mapping to servers’ public IPs. Domain registrars manage these globally, and DNS records bridge domains with server IPs. This abstraction is essential to simplify web access and enable scalable hosting.

- 🖥️ **Linux Commands as Essential Skills for Server Ops:** Ability to install, remove, update packages, change permissions, and check services via CLI tools like `sudo apt`, `systemctl`, and `nano` is fundamental for administering web servers, especially in cloud or production environments.

---

# Detailed Overview

## Web Application Architecture
Any web application consists of two main components:
- **Frontend:** This is the user interface rendered in the browser. It fundamentally consists of:
  - **HTML (HyperText Markup Language):** Defines the page structure, like the framing of a house.
  - **CSS (Cascading Style Sheets):** Controls the design elements such as colors, fonts, and layouts — akin to decorating and painting walls.
  - **JavaScript:** Adds interactivity and controls dynamic behaviors, similar to installing functional wiring and switches inside the house.

There are two types of sites:
- **Static websites:** Only frontend code, no dynamic interactions or backend processing.
- **Dynamic websites:** Include frontend plus backend (server-side logic) plus database for interactive features like login forms and dashboards.

## Role of Backend and Database
Backend servers process and validate input data submitted by users. For example, inputting username and password on LMS or any web app sends data to backend processing logic on the server, which validates credentials by querying a database. Direct database access is never exposed to clients; controlled, secured access is implemented via backend logic.

## Web Servers Overview
- Web servers deliver frontend assets (HTML/CSS/JS) over HTTP or HTTPS protocols.
- Common web servers: Apache HTTP Server, Nginx, Microsoft IIS, LiteSpeed.
- **Nginx (pronounced Engine-X)** is Linux-based and popular in global and DevOps environments.
  
### Installing and Running Nginx on Linux
- Installation via terminal: `sudo apt install nginx -y`
- Troubleshooting startup issues can involve checking conflicts with previous configuration or other service ports.
- Verifying status: `sudo systemctl status nginx`
- Web browser access using `http://localhost` after successful installation shows the default welcome page.

### Configuration Files and Permissions
- Main config: `/etc/nginx/nginx.conf`
- Worker processes manage parallel request handling based on CPU availability.
- Permissions for served files must allow the `www-data` user/group access to read files.
- Modular config allows including files from `/etc/nginx/sites-enabled` for defining websites.
- Log files reside in `/var/log/nginx/`, splitting access and error logs for monitoring.

## HTTP/HTTPS and Ports
- Requests start with HTTP or HTTPS (secure version).
- **Port 80** default for HTTP.
- **Port 443** default for HTTPS.
- Special domain URLs may omit port numbers when they use defaults.

## HTTP Status Codes
These codes communicate server responses:

| Series | Meaning                  | Examples                      |
|--------|--------------------------|------------------------------|
| 2xx    | Success                  | 200 OK, 201 Created, 204 No Content |
| 3xx    | Redirection              | 301 Moved Permanently, 302 Found, 304 Not Modified |
| 4xx    | Client Errors            | 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 405 Method Not Allowed, 413 Payload Too Large, 429 Too Many Requests |
| 5xx    | Server Errors            | 500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable, 504 Gateway Timeout |

- Status codes are integral for developers to debug and handle client-server interactions.
- Some codes (e.g., 413) are relevant when users upload too-large files.
- 405 indicates disallowed HTTP methods like POST on a read-only endpoint.

## Domain Name System (DNS) and Domain Registration
- Domains are human-readable names linked to IP addresses via DNS.
- Registrars like GoDaddy, Namecheap, Cloudflare sell domain names and manage their entries in global registries.
- Domains are mapped via **A records** (for IPv4 addresses) to public IPs of hosted servers.
- Domain ownership incurs yearly or monthly fees depending on uniqueness.
  
### Mapping Domain to Public IP
- Public IP detected using services like `whatismyip.com`.
- DNS records updated to point domain (e.g., smit.com) to server’s public IP.
- This DNS setup enables users globally to access hosted web apps via friendly URLs.

## Practical CLI Demonstrations
- Using commands like:
  - `sudo apt install nginx -y` to install.
  - `sudo systemctl status nginx` to check service.
  - Editing config with `nano /etc/nginx/nginx.conf`.
  - Changing ownership or permissions for served files to allow access by Nginx user.
  - Removing and reinstalling Nginx when facing conflicts.
- Inspecting browser Developer Tools network tab to examine HTTP status codes and troubleshoot errors.

---

This session emphasizes the practical foundation in managing web servers—understanding web app components, deploying and configuring servers, using HTTP protocols correctly, monitoring server responses, and managing domain names to make websites globally accessible. The approach balances theory with hands-on Linux commands to equip learners with essential skills in web hosting and infrastructure management.