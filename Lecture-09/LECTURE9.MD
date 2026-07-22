# Comprehensive Guide to Hosting Websites Using Nginx and Understanding CI/CD Pipelines

## Summary
This session elaborately discusses the process of installing, configuring, and running websites on the Nginx web server, with a strong focus on practical commands and file structure. The instructor revisits the essential components of Nginx configuration, such as the primary config file and the three critical directories: `conf.d`, `modules-enabled`, and `sites-enabled`. Emphasis is placed on understanding symbolic links and their role in managing site configurations between `sites-available` and `sites-enabled`. 

The session then moves towards creating a custom website on port 81, demonstrating file setup, configuration adjustments, and the necessity of restarting Nginx for changes to take effect. It provides a hands-on approach to creating and deploying static web pages, even guiding learners to utilize online resources like W3Schools for ready-to-use HTML templates.

Transitioning toward more advanced topics, the instructor highlights the modern web ecosystem's shift towards dynamic websites built using frameworks like React, Next.js, Laravel, and Django. The concept of builds is introduced — how developers generate build folders from source code but never commit build files to Git repositories.

This leads into a critical discussion of operational challenges between developers and system administrators, specifically around who builds and deploys the application. The concept of the Software Development Life Cycle (SDLC) with 7-9 stages is briefly introduced to explain how applications progress from development to production.

To solve existing deployment frictions, the instructor introduces Continuous Integration/Continuous Deployment (CI/CD) pipelines. CI/CD automates integration and deployment, minimizing manual errors, reducing conflicts, and ensuring smoother coordination between development and operations teams.

To conclude, learners are encouraged to practice by hosting their own portfolio websites using Nginx and automated tools like ChatGPT for generating the code, posting screenshots on LinkedIn to demonstrate their learning progression and readiness for job opportunities.

## Highlights
- ⚙️ Detailed walkthrough of Nginx configuration, including key directories and symbolic links.
- 🔄 Explanation of the two-step process of enabling sites via `sites-available` and `sites-enabled`.
- 🌐 Step-by-step creation of a basic static website served on port $81$.
- 🔗 Clarification of hard links vs symbolic (soft) links and best practices favoring symbolic links.
- 🏗 Insight into build generation for dynamic websites using frameworks like React and Laravel.
- 🔄 Introduction to CI/CD pipelines for automating build, testing, and deployment in software projects.
- 🎯 Practical task assigned to learners to host their portfolio sites and share progress to boost job readiness.

## Key Insights
- 🔍 **Understanding Nginx File Architecture Simplifies Server Management:**  
  The distinction between `sites-available` and `sites-enabled` directories along with symbolic links streamlines managing multiple website configurations efficiently. Symbolic links allow activating or deactivating sites without duplication of config files, reducing errors and promoting cleaner server setups.

- 🔄 **Port Configuration Is Crucial for Hosting Multiple Sites:**  
  Since default HTTP traffic listens on port $80$, hosting multiple websites requires altering the listening ports within the server block configurations (e.g., changing to port $81$). Proper configuration avoids conflicts and ensures simultaneous hosting of several web services.

- 🔗 **Symbolic Links vs Hard Links: Soft Links Offer Practical Flexibility:**  
  Symbolic (soft) links provide pointers to actual files without duplicating content. Unlike hard links, symbolic links become invalid if the original file is removed. This property offers better flexibility and ease of administration, making them the recommended standard for linking configurations.

- 🏗 **Builds Are Separate from Source Code, Emphasizing Clear Dev and Ops Responsibilities:**  
  Developers commit source code without build artifacts to SCM (e.g., Git). Builds — the compiled or bundled artifacts ready for deployment — are generated externally, typically by system administrators or CI/CD pipelines. This separation prevents bloating repos and preserves repository cleanliness.

- 🤝 **DevOps and CI/CD Pipelines Resolve Deployment Bottlenecks:**  
  The traditional friction where developers and operations teams argue over deployment failures and build issues is alleviated via CI/CD tools. These automate integration, testing, build, and deployment workflows, ensuring continuous updates and consistent releases, thus increasing productivity and reducing errors.

- 📈 **Software Development Life Cycle (SDLC) Reflects the Multiple Stages of Application Delivery:**  
  Application development passes through stages such as development, testing, system integration testing (SIT), user acceptance testing (UAT), pre-production, production, and disaster recovery. Properly understanding these phases is critical for coordinating development, testing, and deployment.

- 🎓 **Automation and Tools Democratize Web Hosting and Development:**  
  Leveraging code generators like ChatGPT and online resources like W3Schools drastically lowers the barrier to entry for creating and hosting personal websites. This not only accelerates learning but also helps candidates quickly showcase their skills to prospective employers through platforms like LinkedIn.

## Additional Notes on Process and Commands Used
- Checking Nginx status using `systemctl status nginx`.
- Editing configuration files using `nano /etc/nginx/nginx.conf` and site-specific configs in `/etc/nginx/sites-available/`.
- Creating symbolic links with `ln -s` from `sites-available` to `sites-enabled`.
- Restarting Nginx with `systemctl restart nginx` to apply configuration changes.
- Creating directories with `mkdir` for hosting site content.
- Using online HTML templates from W3Schools and scripting commands to create index pages.
- Cloning or pulling code via Git; build artifacts are not pushed to Git repositories.
- Executing build commands like `npm run build` for frontend frameworks such as React.
- Understanding that CI/CD automates the pull-build-deploy process, which is manual otherwise.

This detailed explanation provides learners both conceptual frameworks and practical guidance, preparing them to efficiently set up web servers, troubleshoot issues, and understand modern deployment pipelines in software development.