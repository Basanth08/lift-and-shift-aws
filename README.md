# About The Project


This project demonstrates a **Multi-Tier Web Application Stack (VPROFILE)** designed to be hosted and run on AWS Cloud for production using a **Lift & Shift strategy**. The goal is to migrate existing application workloads to the cloud with minimal changes, leveraging AWS infrastructure for scalability and reliability.

# Scenario


Initially, application services are running on physical or virtual machines within a traditional datacenter. These services include various technologies such as DNS, PostgreSQL, Oracle, Node.js, Apache Tomcat, NGINX, LAMP stack, Java, MySQL, and PHP. The workload is managed within your own datacenter environment, setting the stage for migration to the cloud.

# Problem


Traditional datacenter environments face several challenges:
- **Complex Management:** Managing multiple services and infrastructure components is difficult and time-consuming.
- **Scaling Complexity:** Scaling resources up or down to meet demand is not straightforward and often requires significant manual intervention.
- **High Costs:** There are significant upfront capital expenditures (CapEx) for hardware and ongoing operational expenditures (OpEx) for maintenance and management.

These issues motivate the move to cloud-based solutions using strategies like Lift & Shift.

## Additional Problems


- **Manual Process:** Many tasks require manual intervention, increasing the risk of errors.
- **Difficult to Automate:** Legacy systems and processes are not designed for automation, making it hard to streamline operations.
- **Time Consuming:** Manual and non-automated processes lead to significant time consumption and inefficiency.

# Solution


Moving to a cloud setup addresses the challenges of traditional datacenter management by providing:
- **Automation:** Streamlines processes and reduces manual intervention.
- **Pay-As-You-Go:** Only pay for the resources you use, reducing upfront costs.
- **IaaS (Infrastructure as a Service):** Easily provision and manage infrastructure components on demand.
- **Flexibility:** Scale resources up or down quickly to match workload requirements.
- **Ease of Infrastructure Management:** Simplifies operations and improves efficiency.

Cloud solutions enable organizations to be more agile, cost-effective, and efficient in managing their IT infrastructure.

# AWS Cloud Components Mapping

This project leverages various AWS services to replace traditional infrastructure components:

- **EC2 Instances:** Act as virtual machines for running Tomcat, RabbitMQ, Memcached, and MySQL servers.
- **ELB (Elastic Load Balancer):** Replaces NGINX as the load balancer for distributing traffic.
- **Auto Scaling:** Automates the scaling of virtual machines based on demand.
- **S3/EFS Storage:** Provides shared storage solutions for application data and backups.
- **Route 53:** Offers private DNS services for internal and external domain management.

These AWS services enable a scalable, automated, and highly available cloud infrastructure for the VProfile application.

# Prerequisites
###
- JDK 11
- Maven 3 or later
- MySQL 5.6 or later

# Technologies 
- Spring MVC
- Spring Security
- Spring Data JPA
- Maven
- JSP
- MySQL
# Database
Here,we used Mysql DB 
MSQL DB Installation Steps for Linux ubuntu 14.04:
- $ sudo apt-get update
- $ sudo apt-get install mysql-server

Then look for the file :
- /src/main/resources/accountsdb
- accountsdb.sql file is a mysql dump file.we have to import this dump to mysql db server
- > mysql -u <user_name> -p accounts < accountsdb.sql

# Objective

The main objectives of this project are:
- **Flexible Infrastructure:** Easily scale and adapt resources as needed.
- **No Upfront Cost:** Leverage cloud pay-as-you-go models to avoid large initial investments.
- **Modernize Effectively:** Update and optimize the application stack for modern cloud environments.
- **Iaac (Infrastructure as Code):** Use automation tools to provision and manage infrastructure efficiently.

# Architecture

![Architecture](Diagrams/architecture.png)

The architecture of this project is designed for scalability, security, and cloud-native deployment. Key components include:

- **DNS (GoDaddy, Route 53):** Manages public and private DNS zones for user access and internal service discovery.
- **Application Load Balancer:** Distributes incoming HTTPS traffic to Tomcat instances, protected by security groups.
- **Tomcat Instances (Auto Scaling Group):** Hosts the application, automatically scaling based on demand.
- **S3 Bucket:** Provides shared storage for application data and backups.
- **Route 53:** Handles DNS resolution for both public and private zones.
- **Security Groups:** Enforce network segmentation and security for Tomcat, Memcache, RabbitMQ, and MySQL instances.
- **Memcache, RabbitMQ, MySQL Instances:** Support caching, messaging, and database services, each within their own security group.

This architecture ensures high availability, security, and efficient resource utilization in the AWS cloud.

# Flow of Execution

The following are the high-level steps for deploying the VProfile application on AWS:

1. Login to AWS Account
2. Create Key Pairs
3. Create Security groups
4. Launch Instances with user data [BASH SCRIPTS]
5. Update IP to name mapping in Route 53
6. Build Application from source code
7. Upload to S3 bucket
8. Download artifact to Tomcat EC2 Instance
9. Setup ELB with HTTPS [Cert from Amazon Certificate Manager]
10. Map ELB Endpoint to website name in GoDaddy DNS
11. Verify
12. Build Autoscaling Group for Tomcat Instances

These steps outline the end-to-end process for provisioning infrastructure, deploying the application, and ensuring scalability and security in the AWS cloud.

# Domain, SSL, and Security Group Setup

To ensure secure and best-practice cloud deployment, the following steps were performed:

1. **ACM Certificate for Custom Domain**
   - An SSL/TLS certificate was requested from AWS Certificate Manager (ACM) for the domain `basantthvaraganti.xyz` (registered with GoDaddy).
   - Domain ownership was validated by adding the required CNAME record (with the CNAME name and value provided by ACM) to the GoDaddy DNS settings.
   - This enables secure HTTPS connections to your website.

2. **Security Group for Load Balancer**
   - A security group was created for the Application Load Balancer (ALB).
   - This security group allows inbound HTTPS (port 443) and/or HTTP (port 80) traffic from the internet to the load balancer.

3. **Security Group for Tomcat Servers**
   - A separate security group was created for the Tomcat EC2 instances.
   - This security group allows inbound traffic on port 8080, but only from the security group associated with the load balancer (not from the public internet).
   - This ensures that only the load balancer can communicate directly with the Tomcat servers, improving security.

**Why these steps matter:**
- The ACM certificate ensures all traffic to your website is encrypted and secure.
- Security groups act as virtual firewalls, controlling access and reducing the attack surface.
- Restricting Tomcat's access to only the load balancer follows best security practices and protects your application servers from direct public exposure.

These configurations are essential for a secure, scalable, and production-ready cloud deployment.

# Internal Security Group Rules for Application Services

To secure internal communication between your application servers and backend services, the following security group rules were configured:

- **MySQL/Aurora (Port 3306):**
  - **Source:** Tomcat security group (`sg-010857c931e32ff55`)
  - **Purpose:** Allows Tomcat application servers to connect to the MySQL database.

- **Memcached (Port 11211):**
  - **Source:** Tomcat security group (`sg-010857c931e32ff55`)
  - **Purpose:** Allows Tomcat servers to connect to Memcached for caching.

- **RabbitMQ (Port 5672):**
  - **Source:** Tomcat security group (`sg-010857c931e32ff55`)
  - **Purpose:** Allows Tomcat servers to connect to RabbitMQ for messaging.

**Why this setup is important:**
- Follows the principle of least privilege by restricting access to backend services only to the necessary application servers.
- Enhances security by isolating services from public access and other unrelated resources.
- Aligns with AWS best practices for internal service communication and network segmentation.

This configuration ensures that only authorized application servers can access critical backend services, reducing the risk of unauthorized access and improving the overall security posture of your cloud environment.

## Allowing Internal Traffic Within the Backend Security Group

![Backend Security Group Internal Rule]

- **Type:** All traffic (all protocols, all ports)
- **Source:** The backend security group itself (`sg-03dfd52e53d36eabe`)
- **Description:** Allow internal traffic to flow on all ports

**Purpose:**
- This rule allows all instances that are members of the backend security group to communicate freely with each other on any port and protocol.

**Use Case:**
- Useful for backend services (like MySQL, Memcached, RabbitMQ, etc.) that need to communicate with each other for clustering, replication, or other internal operations.

**Security Note:**
- This rule is safe as long as only trusted backend instances are part of this security group. It does not expose these services to the public internet.

This configuration enables seamless service-to-service communication within the backend tier while maintaining isolation from external networks.

## Restricting SSH and Application Access to Your IP

To further enhance security, SSH and direct application access have been restricted to your specific IP address for both the application and backend security groups.

### Application Security Group (`sg-010857c931e32ff55 - vprofile-app-sg`)

- **Port 22 (SSH):**
  - **Source:** Your IP address (`38.49.72.189/32`)
  - **Purpose:** Only your IP can SSH into the application server, preventing unauthorized access from the public internet.

- **Port 8080 (Tomcat Application):**
  - **Source:** Your IP address (`38.49.72.189/32`)
  - **Purpose:** Only your IP can access the Tomcat application directly on port 8080, blocking all other external access.

### Backend Security Group (`sg-03dfd52e53d36eabe - vprofile-backend-SG`)

- **Port 22 (SSH):**
  - **Source:** Your IP address (`38.49.72.189/32`)
  - **Purpose:** Only your IP can SSH into backend servers, ensuring administrative access is tightly controlled.

**Why this is a best practice:**
- Minimizes the risk of brute-force attacks and unauthorized access.
- Limits administrative and debugging access to trusted sources only.
- Follows the principle of least privilege for network access.

This configuration is essential for maintaining a secure cloud environment and protecting your infrastructure from external threats.

# Key Pair Creation for EC2 Access

A new key pair was created for secure SSH access to EC2 instances:

- **Key Pair Name:** vprofile-prod-key
- **Type:** RSA
- **Purpose:** Secure SSH access to your EC2 instances

**Why this is important:**
- The key pair is used for SSH authentication, ensuring only users with the private key can access your EC2 instances.
- Each environment (production, staging, etc.) should have its own key pair for better access control and security.
- AWS requires a key pair to be specified when launching EC2 instances if you want to connect via SSH.

This step is essential for maintaining secure and controlled access to your cloud infrastructure.

# EC2 Instance Deployment

The VProfile application is deployed using multiple EC2 instances, each dedicated to a specific component for modularity, scalability, and fault isolation:

- **vprofile-mc01:** Memcached instance
- **vprofile-db01:** MySQL database instance
- **vprofile-app01:** Tomcat application server instance
- **vprofile-rmq01:** RabbitMQ instance

Each instance runs in the same Availability Zone (`us-east-1a`) and is monitored for health and status. This architecture allows for independent scaling, easier troubleshooting, and improved reliability of each service.

# Step-by-Step Database Server Setup (MariaDB on EC2)

This section documents the process followed to set up a production-ready MariaDB database server for the VProfile application on AWS EC2:

1. **Launched a new EC2 instance** with a larger EBS volume and added swap space to prevent memory issues during installation.
2. **Associated an Elastic IP** and configured security groups to allow SSH access from the current public IP.
3. **Connected to the instance via SSH** using a secure private key.
4. **Added 1GB of swap space** to avoid out-of-memory errors during package installation.
5. **Installed required packages:** `epel-release`, `git`, `zip`, `unzip`, and `mariadb-server`.
6. **Uploaded and executed an improved `mysql.sh` script** that:
   - Started and enabled the MariaDB service
   - Cloned the `vprofile-project` repository
   - Set the MariaDB root password
   - Cleaned up default users and test databases
   - Created the `accounts` database and the `admin` user with appropriate privileges
   - Imported the schema and data from the project's `db_backup.sql`
   - Skipped firewall configuration if `firewalld` was not installed
7. **Verified the database setup** by logging into MariaDB, confirming the existence of the `accounts` database, its tables, and the correct users.
8. **Troubleshot and fixed issues** related to memory, missing files, and permissions to ensure a smooth, repeatable setup.

This process results in a robust, production-ready MariaDB environment, fully prepared for the VProfile application to connect and operate securely and efficiently on AWS.

# Step-by-Step Multi-Tier Application Deployment on AWS

This section documents the process followed to set up a robust, production-like AWS environment for a multi-tier Java web application (VProfile):

1. **Launched multiple EC2 instances** for different roles: MariaDB (database), Memcached, RabbitMQ, and Tomcat (application server).
2. **Assigned Elastic IPs** to each instance for public access and configured security groups to allow only necessary traffic (SSH, application ports, etc.).
3. **Added swap space** to t2.micro instances to prevent out-of-memory errors during package installation.
4. **MariaDB Server:** Uploaded and executed an improved `mysql.sh` script to automate installation, configuration, database/user creation, and schema import. Verified the setup via the MariaDB CLI.
5. **Memcached Server:** Uploaded and executed `memcache.sh` to automate installation and configuration, ensuring Memcached listens on all interfaces. Verified Memcached is running and accessible on port 11211.
6. **RabbitMQ Server:** Uploaded and prepared to execute `rabbitmq.sh` to automate installation, configuration, user/admin setup, and port opening for messaging.
7. **Tomcat Server:** Launched an Ubuntu 24.04 instance, discovered Tomcat 9 is not available in default repos, downloaded and installed Tomcat 9.0.87 manually from Apache archives, set permissions, started Tomcat, and located the `webapps` directory for application deployment.
8. **General Linux & AWS Skills:** Used `scp` to transfer scripts, `systemctl` to manage and check the status of services, `ss`/`netstat` to verify services are listening on the correct ports, and troubleshot/fixed issues related to memory, missing packages, and network/firewall settings.

This process results in a scalable, secure, and production-ready AWS environment for deploying and running a multi-tier Java web application, with all supporting services (database, cache, messaging, and application server) properly configured and verified.

# Internal DNS with AWS Route 53

To enable flexible and maintainable service discovery within the AWS environment, AWS Route 53 was used to create internal DNS records for backend services:

- **db01.vprofile.in** → 172.31.8.67 (Database server)
- **mc01.vprofile.in** → 172.31.5.41 (Memcached server)
- **rmq01.vprofile.in** → 172.31.8.126 (RabbitMQ server)

This setup allows application components to refer to backend services by easy-to-remember DNS names instead of private IP addresses. If the underlying EC2 instance changes, only the DNS record needs to be updated, not every client configuration. This approach is a best practice for cloud-native and multi-tier deployments, improving flexibility, scalability, and maintainability.

# Application Build and Deployment

The final step in the deployment pipeline is building and deploying the Java application to the Tomcat server:

1. **Build the application using Maven:**
   - Ran `mvn install` to compile the code and generate a `.war` file in the `target/` directory.
2. **Transfer the `.war` file to the Tomcat server:**
   - Used `scp` to copy the `.war` file from the local machine to the Tomcat server's `/opt/tomcat9/webapps/` directory:
     ```sh
     scp -i ~/Downloads/vprofile-prod-key.pem /path/to/your-app.war ubuntu@<tomcat-public-ip>:/opt/tomcat9/webapps/
     ```
3. **Tomcat automatically deploys the `.war` file** when it is placed in the `webapps` directory.
4. **Access the application in a browser:**
   - Go to `http://<tomcat-public-ip>:8080/<app-name>/` (replace `<app-name>` with the name of your `.war` file, minus the `.war` extension).

This completes the end-to-end deployment pipeline, taking your code from build to a running application in the AWS environment.

# Storing Build Artifacts in AWS S3

To enable centralized, cloud-based storage of build artifacts for deployment, backup, or sharing across environments, the following steps were performed:

1. **Configured AWS CLI** with credentials, default region, and output format:
   - Ran `aws configure` and entered the AWS Access Key ID, Secret Access Key, region (`us-east-1`), and output format (`json`).
2. **Created an S3 bucket** for storing artifacts:
   - Ran `aws s3 mb s3://basantth-war-artifacts` to create the bucket.
3. **Uploaded the built `.war` file to S3:**
   - Ran `aws s3 cp target/vprofile-v2.war s3://basantth-war-artifacts` to upload the WAR file to the bucket.

This approach enables easy, reliable storage and retrieval of build artifacts, supporting automated deployments and multi-environment workflows in the cloud.

# IAM Role, User, and S3 Artifact Deployment Process

To securely manage access to AWS resources and automate artifact deployment, the following steps were performed:

1. **Created an IAM Role for EC2:**
   - Created a new IAM role with a trust relationship for EC2 service.
   - Attached policies such as `AmazonS3ReadOnlyAccess` (or a custom policy with least-privilege S3 access) to allow EC2 instances to access S3 buckets for artifact download.
   - Assigned this IAM role to the EC2 instance running Tomcat.

2. **Created an IAM User for Artifact Management:**
   - Created a dedicated IAM user for managing build artifacts.
   - Attached policies such as `AmazonS3FullAccess` (or a custom policy with limited S3 permissions) to this user for uploading and managing artifacts in S3.
   - Generated Access Key ID and Secret Access Key for this user.

3. **Configured AWS CLI on EC2 Instance:**
   - Ran `aws configure` on the EC2 instance.
   - Entered the IAM user's Access Key ID, Secret Access Key, default region, and output format.
   - Verified configuration by running `aws s3 ls` to list available S3 buckets.

4. **Uploaded Build Artifact to S3:**
   - Used the AWS CLI to upload the built `.war` file to the S3 bucket:
     ```sh
     aws s3 cp target/vprofile-v2.war s3://basantth-war-artifacts/
     ```

5. **Downloaded Artifact from S3 to EC2:**
   - On the Tomcat EC2 instance, downloaded the `.war` file from S3:
     ```sh
     aws s3 cp s3://basantth-war-artifacts/vprofile-v2.war /tmp/
     ```

6. **Deployed Artifact to Tomcat:**
   - Stopped Tomcat using the manual script:
     ```sh
     /opt/tomcat9/bin/shutdown.sh
     ```
   - Copied the WAR file to the Tomcat webapps directory as `ROOT.war`:
     ```sh
     cp /tmp/vprofile-v2.war /opt/tomcat9/webapps/ROOT.war
     ```
   - Started Tomcat:
     ```sh
     /opt/tomcat9/bin/startup.sh
     ```

This process ensures secure, auditable, and automated management of application artifacts using AWS IAM best practices and S3 as a central artifact repository. It also enables seamless deployment and redeployment of application builds to EC2 instances in a production environment.

# Configuring Custom Domain with AWS Load Balancer and GoDaddy

To route traffic from a custom domain to the AWS-hosted application, the following steps were performed:

1. **Created an Application Load Balancer (ALB) in AWS:**
   - Set up an ALB to distribute incoming traffic across backend EC2 instances for high availability and scalability.

2. **Created a Target Group:**
   - Defined a target group and registered backend EC2 instances (e.g., Tomcat servers) to receive traffic from the load balancer.

3. **Copied the Load Balancer DNS Name:**
   - Retrieved the DNS name of the ALB (e.g., `my-alb-1234567890.us-east-1.elb.amazonaws.com`) from the AWS console.

4. **Updated GoDaddy Domain DNS Settings:**
   - Logged into GoDaddy domain management.
   - Created a DNS record:
     - **Type:** CNAME (for subdomains like www) or A (Alias) for root domain
     - **Name:** `www` (or `@` for root domain)
     - **Value:** The ALB DNS name
   - Saved the changes and waited for DNS propagation.

5. **Tested Domain Routing:**
   - Opened the custom domain in a browser to verify it routes traffic to the AWS application via the load balancer.

**Result:**
- The custom domain (e.g., `www.yourdomain.com`) now points to the AWS load balancer, enabling scalable, highly available access to the application.
- This setup allows seamless management of backend servers and supports future scaling or failover scenarios.

**Note:**
- For production, it is recommended to set up an SSL certificate (via AWS ACM) and enable HTTPS on the load balancer for secure traffic.

# Auto Scaling Group Setup for Application Servers

To ensure high availability, scalability, and automated recovery for the application servers, the following steps were performed:

1. **Created an Amazon Machine Image (AMI):**
   - Generated an AMI from a fully configured and tested EC2 instance running the application stack.
   - This AMI serves as a golden image for launching new instances with identical configuration.

2. **Created a Launch Template:**
   - Defined a launch template using the AMI, specifying instance type, security groups, key pair, and other required settings.
   - The launch template standardizes instance creation and ensures consistency across all application servers.

3. **Created an Auto Scaling Group (ASG):**
   - Set up an Auto Scaling Group using the launch template.
   - Configured the ASG with minimum, maximum, and desired instance counts.
   - Attached the ASG to the Application Load Balancer for automatic registration and deregistration of instances.
   - Enabled health checks and automatic instance replacement for fault tolerance.

**Result:**  
The application server layer is now highly available and scalable. The Auto Scaling Group automatically maintains the desired number of healthy instances, replaces failed instances, and scales the environment based on demand.


