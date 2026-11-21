
# 🛒 ShopNow E-Commerce - Kubernetes Learning Project

ShopNow is a **Kubernetes learning project** built around a full-stack MERN e-commerce application:
- **Customer App** (React frontend)  
- **Admin Dashboard** (React admin panel)  
- **Backend API** (Express + MongoDB)  

This project teaches **Kubernetes** from container basics to production-ready deployments with Dockerfiles, Kubernetes manifests, Helm, GitOps and CICD using Jenkins.

## 🎯 Learning Objectives
- Write Dockerfiles for containerising the application
- Master Kubernetes fundamentals through hands-on practice
- Understand and implement HELM Chart for application deployment on kubernetes
- Implement GitOps workflows using ArgoCD
- Implement CICD pipelines using Jenkins

---

## 📁 Project Structure

```
shopNow/
├── backend/               # Node.js API server
├── frontend/              # React customer app
├── admin/                 # React admin dashboard
├── kubernetes
│   ├── k8s-manifests/     # Raw Kubernetes YAML files
│   ├── helm/              # Helm charts for package management
│   │   └── charts/        # Individual charts
│   ├── argocd/            # GitOps deployment configs
│   └── pre-req/           # Cluster prerequisites
├── jenkins/               # Pipeline definitions (CI & CD)       
├── docs/                  # learning resources and guides
└── scripts/               # Automation and utility scripts
```

---


# Sprint 1: Architecture Design, Dockerization, and Jenkins Setup

## Tasks:
### - Design the application architecture for deployment on AWS EKS.
<img width="1110" height="2950" alt="mermaid-diagram" src="https://github.com/user-attachments/assets/1b67ef4c-ac4f-4466-9371-c8c08356a396" />

Let's divide it into four layers.

Layer 1 – User access
- Customers access the frontend.
- Administrators access the admin dashboard.
- The AWS load balancer receives incoming traffic.
- Kubernetes Ingress routes requests to the correct application.
Layer 2 – Application layer

Inside EKS:
- Frontend Pods run the React application through Nginx.
- Admin Pods run the admin React application through Nginx.
- Backend Pods run the Node.js API.
We will use Kubernetes Deployments for these three stateless applications.

Layer 3 – Database layer

MongoDB stores:
- Customer information
- Product information
- Orders
- Shopping cart information
The repository currently describes MongoDB as a StatefulSet with persistent storage. For a learning deployment, we can retain that design using EBS-backed persistent volumes. For production, I would evaluate MongoDB Atlas or Amazon DocumentDB as managed alternatives.

Layer 4 – CI/CD layer

This is where Jenkins comes in:
- GitHub stores source code.
- Jenkins EC2 receives GitHub webhook notifications.
- Jenkins builds Docker images.
- ECR stores the images.
- EKS pulls the images when workloads are deployed or updated.
Notice that Jenkins is outside the EKS cluster. This keeps CI infrastructure separate from application infrastructure.


### - Dockerize the web application by creating a Dockerfile and storing the image in AWS ECR.
### - Set up a Jenkins server on AWS EC2 and configure necessary plugins (Docker, Kubernetes, AWS CLI).
### - Configure Jenkins to access EKS and AWS resources using credentials and AWS IAM roles.
### - Set up Git integration for Jenkins to trigger builds based on code changes.
### - Goal: Complete the application architecture, Dockerize the application, and establish a Jenkins server for CI/CD.





## SPRINT-2
Problem statement Sprint 2: AWS Infrastructure Provisioning with Terraform and Jenkins Integration

Sprint 2
AWS Infrastructure Provisioning with Terraform and Jenkins Integration
Objective
Automate the provisioning of AWS infrastructure using Terraform and Jenkins, store Terraform state securely in Amazon S3, and create reusable infrastructure for multiple environments.

| Resource | Purpose |
|---|---|
| VPC | Isolated network for the application |
| Public Subnets | Host internet-facing resources |
| Private Subnets | Host Kubernetes worker nodes and applications |
| Internet Gateway | Allow public internet connectivity |
| Route Tables | Route traffic between networks |
| Security Groups | Control network access |
| EC2 | Jenkins server or supporting infrastructure |
| EKS Cluster | Kubernetes orchestration platform |
| S3 Bucket | Store Terraform state securely |

2. Architecture of Sprint 2
The infrastructure provisioning workflow will look like this:

                 Developer
                    |
                    v
              GitHub Repository
                    |
                    v
                  Jenkins
                    |
          +---------+----------+
          |                   |
          v                   v
    Terraform Init       Terraform Plan
          |                   |
          v                   v
    S3 Remote State     Terraform Apply
                              |
                              v
                       AWS Infrastructure
                              |
          +-------------------+-------------------+
          |                   |                 |
          v                   v                 v
         VPC              EC2 Instance       EKS Cluster
          |                                    |
          v                                    v
   Public/Private Subnets                Worker Nodes
          |
          v
    Internet Gateway


    Steps to Perform Sprint 2

    1. Create an IAM User or Role for Terraform
        
        Terraform requires permissions to create and manage AWS resources.
     
        ![alt text](CreateUser-1.jpg)

        ![alt text](UserCreated.jpg)

    2. Configure AWS CLI
        
        Install AWS CLI on the system where Jenkins will execute Terraform. first we need to find out aws version and then do aws configuration 
        below are the command
        aws --version
        aws configure
        ![alt text](AwsVersion.jpg)

        ![alt text](awsconfigure.jpg)

    3. Install Terraform 

        Terraform must be installed on the machine where Jenkins executes the pipeline.

        ![alt text](<terraform install.jpg>)
    
    4. Create Project Directory

      ShopNow-DevOps/
    │
    ├── terraform/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── providers.tf
    │   ├── backend.tf
    │   ├── terraform.tfvars
    │   └── modules/
    │
    ├── Jenkinsfile
    │
    ├── Screenshots/
    │
    └── README.md

    5.Configure Terraform AWS Provider

      Create providers.tf and this configuration tells Terraform:
      - Use Terraform version 1.5 or newer.
      - Download the AWS provider.
      - Use AWS as the cloud provider.
      - Deploy resources in the region defined by aws_region.

        ![alt text](<terraform providers.jpg>)

    6.Define Variables
      
      Create variables.tf. and These variables make the infrastructure reusable.

      For example, the same Terraform code can be used for:
      - Development
      - Staging
      - Production
      Instead of rewriting Terraform files for each environment, you simply change the environment variables.

    7. Create AWS VPC

        Create main.tf. First, configure the VPC. and This provides a private network for your AWS infrastructure.

    8. Create Internet Gateway

        An Internet Gateway allows resources in public subnets to communicate with the internet, when routing and security rules permit.

        Add the following to main.tf:The Internet Gateway will be attached to your VPC.

    9. Create Public Subnets

       We will create two public subnets in different Availability Zones.AWS EKS clusters typically require subnets in at least two Availability Zones for high availability.This allows the infrastructure to remain more resilient if one Availability Zone experiences an issue.

    10. Create Private Subnets

        Private subnets are intended for resources that should not directly receive inbound internet traffic.

        For example:
        - Kubernetes worker nodes
        - Application workloads
        - Databases
        - Internal services

    11. Create Public Route Table

        Create a route table:means traffic destined for any IPv4 address outside the VPC will be routed through the Internet Gateway.

        Associate the route table with the public subnets:

    12. Create Security Group

        Security Groups control inbound and outbound traffic.

        For this infrastructure, we will create a security group for an EC2 instance.
        Do not leave SSH open to everyone (0.0.0.0/0) unless it is a temporary lab environment and you fully understand the risk.

    13. Create EC2 Instance

        Terraform can also create an EC2 instance.

        This instance could be used for:
        - Jenkins
        - Administration
        - Testing
      - Supporting services

    14. Configure Terraform Outputs

        Create outputs.tf and Outputs allow us to retrieve resource information after Terraform completes.

    15. Test Terraform Locally

        Before integrating Terraform with Jenkins, test the configuration locally.

        Navigate to your Terraform folder:

        Terraform init
        ![alt text](terraforminit.jpg)

        Terraform Validate

        ![alt text](terraformvalidate.jpg)

        Terraform plan 
        ![alt text](<terraformplan .jpg>)

        Terraform apply 
        ![alt text](terraformapply.jpg)

    16. Configure S3 Remote Backend   

        Terraform state files contain information about managed infrastructure. By default, Terraform stores the state locally in:
        terraform.tfstate

      Step 1 - Create S3 Bucket 
        
        AWS Console → S3 → Create Bucket  - Bucket name (shopnow-terraform-state-unique-123456)
        Bucket names must be globally unique.

        Configure:
        - Block all public access
        - Enable versioning
        - Enable server-side encryption
        - Restrict access through IAM
        - Enable logging where appropriate
          Versioning helps recover earlier state versions if an accidental change occurs.

        ![alt text](awss3bucketstatus.jpg)

      Step 2 - Configure Backend 

        Create backend.tf and Replace the bucket name with your actual bucket.

        The S3 backend stores state remotely, and S3 lock files help coordinate concurrent Terraform operations.

    17. Push Terraform Code to GitHub   

        Create a GitHub repository and Suggested structure

        ShopNow-DevOps/
        │
        ├── terraform/
        │   ├── main.tf
        │   ├── variables.tf
        │   ├── outputs.tf
        │   ├── providers.tf
        │   ├── backend.tf
        │   └── terraform.tfvars
        │
        ├── Jenkinsfile
        ├── Screenshots/
        └── README.md

    18. Configure Jenkins

       Step 1: Jenkins will automatically execute Terraform commands and the workflow will be :

                        GitHub
                          |
                          v
                        Jenkins Pipeline
                          |
                          v
                        Terraform Init
                          |
                          v
                        Terraform Validate
                          |
                          v
                        Terraform Plan
                          |
                          v
                        Terraform Apply
                          |
                          v
                        AWS Infrastructure

            ![alt text](jenkins.jpg)

            ![alt text](jenkinspipelinecreated.jpg)
 
            ![alt text](pipelinerunsuccessfully.jpg)

       Step 2 : Configure AWS Credentials in Jenkins

                Manage Jenkins → Credentials → System → Global credentials

                If using access keys for a temporary learning setup:
                - Kind: Secret text or username/password, depending on the credential setup
                - Store the AWS Access Key ID
                - Store the AWS Secret Access Key securely
                For a production environment, use IAM roles or temporary credentials rather than long-lived access keys.

    19. Create Jenkins Pipeline

        Create a Jenkinsfile in the repository root and this pipeline will 
          Clone the GitHub repository.
          Initialize Terraform.
          Validate Terraform.
          Generate a Terraform plan.
          Ask for approval.
          Provision infrastructure.

    20. Create Jenkins Job
        
        Go to Jenkins.

        ![alt text](jenkinspipelinecreated-1.jpg)
        
        ![alt text](JenkinsBuildsucessfully.jpg)

        

    21. Run the Jenkins Pipeline

      | Stage | Expected Result |
      |---|---|
      | Checkout | GitHub code downloaded |
      | Terraform Init | Terraform initialized |
      | Terraform Validate | Configuration validated |
      | Terraform Plan | AWS resource plan generated |
      | Approval | User approves infrastructure changes |
      | Terraform Apply | AWS resources created |

        ![alt text](pipelinerunsuccessfully-1.jpg)

    22. Verify Infrastructure in AWS

        After the Jenkins pipeline completes, log in to AWS Console and Verify the resources.

    Final Output - AWS and Terraform 
    
    ![alt text](projectrunwithbackendusingjenkins.jpg)


## Sprint 3

Sprint 3: Configuration Management with Ansible and Jenkins Pipeline



![alt text](image-1.png)
