# About The Project

![About The Project](images/about-the-project.png)

This project demonstrates a **Multi-Tier Web Application Stack (VPROFILE)** designed to be hosted and run on AWS Cloud for production using a **Lift & Shift strategy**. The goal is to migrate existing application workloads to the cloud with minimal changes, leveraging AWS infrastructure for scalability and reliability.

# Scenario

![Scenario](images/scenario.png)

Initially, application services are running on physical or virtual machines within a traditional datacenter. These services include various technologies such as DNS, PostgreSQL, Oracle, Node.js, Apache Tomcat, NGINX, LAMP stack, Java, MySQL, and PHP. The workload is managed within your own datacenter environment, setting the stage for migration to the cloud.

# Problem

![Problem](images/problem.png)

Traditional datacenter environments face several challenges:
- **Complex Management:** Managing multiple services and infrastructure components is difficult and time-consuming.
- **Scaling Complexity:** Scaling resources up or down to meet demand is not straightforward and often requires significant manual intervention.
- **High Costs:** There are significant upfront capital expenditures (CapEx) for hardware and ongoing operational expenditures (OpEx) for maintenance and management.

These issues motivate the move to cloud-based solutions using strategies like Lift & Shift.

## Additional Problems

![Problem - Manual Process](images/problem-manual-process.png)

- **Manual Process:** Many tasks require manual intervention, increasing the risk of errors.
- **Difficult to Automate:** Legacy systems and processes are not designed for automation, making it hard to streamline operations.
- **Time Consuming:** Manual and non-automated processes lead to significant time consumption and inefficiency.

# Solution

![Solution](images/solution.png)

Moving to a cloud setup addresses the challenges of traditional datacenter management by providing:
- **Automation:** Streamlines processes and reduces manual intervention.
- **Pay-As-You-Go:** Only pay for the resources you use, reducing upfront costs.
- **IaaS (Infrastructure as a Service):** Easily provision and manage infrastructure components on demand.
- **Flexibility:** Scale resources up or down quickly to match workload requirements.
- **Ease of Infrastructure Management:** Simplifies operations and improves efficiency.

Cloud solutions enable organizations to be more agile, cost-effective, and efficient in managing their IT infrastructure.

# AWS Cloud Components Mapping

![AWS Cloud Components Mapping](images/aws-cloud-components-mapping.png)

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

![Objective](images/objective.png)

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

![Flow of Execution](images/flow-of-execution.png)

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


