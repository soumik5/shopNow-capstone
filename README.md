
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
#### -> Docker-compose file is created to build all the docker images and test the application locally. docker-compose file is [placed in the project directory for your reference.
<img width="1896" height="840" alt="image" src="https://github.com/user-attachments/assets/7c4f0d1f-4b4b-407a-865f-2196e78cf112" />

#### -> Pushed all the images to AWS ECR.
<img width="1622" height="952" alt="image" src="https://github.com/user-attachments/assets/54b4ee4f-3ea8-4f3e-b32c-e496124fa44e" />
<img width="1891" height="552" alt="image" src="https://github.com/user-attachments/assets/89e645a0-6b68-4de8-80ad-ff9abc34f38b" />

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
     
        <img width="2880" height="1800" alt="CreateUser-1" src="https://github.com/user-attachments/assets/4a9b459e-5249-4e27-a3ef-4ee421ad5d1a" />

        <img width="2880" height="1800" alt="UserCreated" src="https://github.com/user-attachments/assets/4a60a2e5-bcad-40b5-86a3-842e9cc75ac6" />


    2. Configure AWS CLI
        
        Install AWS CLI on the system where Jenkins will execute Terraform. first we need to find out aws version and then do aws configuration 
        below are the command
        aws --version
        aws configure
       
        <img width="2338" height="1216" alt="AwsVersion" src="https://github.com/user-attachments/assets/32eba107-ccaf-4fad-a914-0084c163fc8c" />


        <img width="2360" height="1228" alt="awsconfigure" src="https://github.com/user-attachments/assets/21f91d55-716c-4a76-8c65-00293ac65ce0" />


    4. Install Terraform 

        Terraform must be installed on the machine where Jenkins executes the pipeline.

        <img width="2316" height="234" alt="terraform install" src="https://github.com/user-attachments/assets/1bfa10c6-52bb-4e9c-a986-3d9572a18038" />

    
    5. Create Project Directory

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

        <img width="2346" height="1216" alt="terraform providers" src="https://github.com/user-attachments/assets/790b1b25-5a1e-4a3a-934b-04758ce1044c" />


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
        <img width="2356" height="280" alt="terraforminit" src="https://github.com/user-attachments/assets/a687c7be-b1fb-4998-b09e-67032fc14c23" />


        Terraform Validate

        <img width="2356" height="1214" alt="terraformvalidate" src="https://github.com/user-attachments/assets/ed335c7b-94e0-4e28-b73f-84712418717f" />


        Terraform plan 
         <img width="2880" height="1800" alt="terraformplan " src="https://github.com/user-attachments/assets/9fd004d9-87ea-4e46-b5e4-56087c26de13" />


         Terraform apply 
         <img width="2880" height="1794" alt="terraformapply" src="https://github.com/user-attachments/assets/aa4a57e3-7589-4201-a084-e5df34c406fc" />


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

      <img width="2880" height="1800" alt="awss3bucketstatus" src="https://github.com/user-attachments/assets/ffc82778-a466-4e65-9187-84d6b63af9ef" />


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

   <img width="2880" height="1798" alt="jenkins" src="https://github.com/user-attachments/assets/b28e964b-9ad3-4c42-bca3-44de657b21cd" />

   <img width="1920" height="1074" alt="jenkinspipelinecreated" src="https://github.com/user-attachments/assets/daddd8f5-e1df-40f3-ad46-b2733421e117" />
 
   <img width="1920" height="1072" alt="pipelinerunsuccessfully" src="https://github.com/user-attachments/assets/6d5992c2-be15-43e7-936b-57b7fb4e2272" />


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

      <img width="1920" height="1074" alt="jenkinspipelinecreated-1" src="https://github.com/user-attachments/assets/be6179e4-77c0-4102-b173-1f2b5307a4d9" />

        
      <img width="1920" height="1080" alt="JenkinsBuildsucessfully" src="https://github.com/user-attachments/assets/28f34520-b3bb-4f2c-a130-02b7f7636722" />


        

    21. Run the Jenkins Pipeline

      | Stage | Expected Result |
      |---|---|
      | Checkout | GitHub code downloaded |
      | Terraform Init | Terraform initialized |
      | Terraform Validate | Configuration validated |
      | Terraform Plan | AWS resource plan generated |
      | Approval | User approves infrastructure changes |
      | Terraform Apply | AWS resources created |

   <img width="1920" height="1072" alt="pipelinerunsuccessfully-1" src="https://github.com/user-attachments/assets/feb89551-2180-4fdf-8177-2d5653bab8fc" />


    22. Verify Infrastructure in AWS

        After the Jenkins pipeline completes, log in to AWS Console and Verify the resources.

    Final Output - AWS and Terraform 
    
   <img width="2880" height="1800" alt="projectrunwithbackendusingjenkins" src="https://github.com/user-attachments/assets/f9f4694d-2b55-4f01-979f-442ef5694628" />



## Sprint 3

Sprint 3: Configuration Management with Ansible and Jenkins Pipeline
1. Sprint Overview
Sprint 3 focuses on automating server configuration using Ansible and Jenkins.

In Sprint 2, Terraform was used to provision AWS infrastructure, such as EC2 instances. However, creating an EC2 instance does not automatically install or configure everything required to run an application.

<img width="2880" height="1800" alt="image-1" src="https://github.com/user-attachments/assets/3c5e2cbe-77ea-4dfc-839a-0428dfc16d54" />

Architecure 
Working Steps for Architecture

1.The developer pushes code to GitHub.
2.Jenkins triggers the Terraform pipeline.
3.Terraform creates the EC2 infrastructure.
4.Terraform provides the EC2 public IP address.
5.Jenkins triggers the Ansible pipeline after Terraform completes successfully.
6.Ansible connects to the EC2 instance using SSH.
7.Ansible installs Docker, kubectl, Git, and other dependencies.
8.Ansible verifies that the installations are successful.
9.Jenkins displays the pipeline status.

Project Structure

shopNow-capstone/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── ansible/
│   ├── inventory.ini
│   ├── ansible.cfg
│   ├── install_dependencies.yml
│   └── Jenkinsfile
│
├── Jenkinsfile
│
└── README.md

Steps for Confiuration

Step 1 - Ansible must be installed on the machine where Jenkins will execute the Ansible playbooks. If your Jenkins server is running on Ubuntu, execute:

<img width="2880" height="1800" alt="sudoaptupdate" src="https://github.com/user-attachments/assets/c881ec26-3fa1-4c18-a8b2-cd90d46b981d" />

Install Ansible

<img width="2880" height="1800" alt="install ansible" src="https://github.com/user-attachments/assets/ca5ce298-0a7c-451c-88ac-7af2398a797e" />

Ansible Version

<img width="2880" height="552" alt="ansible--version" src="https://github.com/user-attachments/assets/d94b6cc8-0814-4c25-ad29-ba6bec9018c2" />

Step 2: Configure SSH Access to EC2
Ansible can use the same SSH connection to configure the server.
<img width="2880" height="1800" alt="connectwithubuntu" src="https://github.com/user-attachments/assets/fed7fd9d-4a66-48fe-8e45-70f990d7a5f2" />

Step 3: Create the Ansible Inventory
The inventory file tells Ansible which servers it needs to configure
The inventory allows Ansible to identify and connect to the EC2 server.
path - ansible/inventory.ini
<img width="2346" height="1228" alt="ansibleinventorylist" src="https://github.com/user-attachments/assets/a358ac09-3ba7-4111-9aeb-cf51aa57b264" />

For a larger environment, manually updating IP addresses is not practical.

Later, we can use AWS dynamic inventory to automatically discover EC2 instances using AWS tags.

For this sprint, static inventory is sufficient.

Step 4: Configure Ansible

Create:

<img width="2880" height="1800" alt="ansibleconfigurationfile" src="https://github.com/user-attachments/assets/17df3532-d353-4177-8a27-5c293411679c" />

Add:

 [defaults]
inventory = ./inventory.ini
host_key_checking = False
timeout = 30

[privilege_escalation]
become = True
become_method = sudo
become_user = root


Step 5: Create the Ansible Playbook

Now we will create the playbook that installs Docker, kubectl, Git, and other dependencies.

Create:

ansible/install_dependencies.yml
This tells Ansible:
- Docker should be running.
- Docker should automatically start after a reboot.
If Docker is already running, Ansible does not need to restart it unnecessarily.

This is called idempotency.

Step 6: Test Ansible Manually
Before integrating Ansible with Jenkins, test the playbook manually and Check whether Ansible can communicate with EC2:

<img width="2880" height="636" alt="pingserver" src="https://github.com/user-attachments/assets/38f4dfb0-d9e1-4ac8-87ff-ee592ddf2e4b" />

Step 7: Verify Configuration on EC2
Connect to your EC2 instance:

<img width="2378" height="1232" alt="shopnow-key" src="https://github.com/user-attachments/assets/ec2945b4-e45b-40cf-9462-8352dd66394c" />

Next Step to check the docker Version
<img width="2880" height="1800" alt="install_docker" src="https://github.com/user-attachments/assets/7e6b637a-bd06-4216-bb69-347571900e17" />

<img width="2880" height="322" alt="docker--version" src="https://github.com/user-attachments/assets/5fa9850f-5c88-4581-b449-37e82cf80584" />

<img width="2880" height="526" alt="dockerstatus" src="https://github.com/user-attachments/assets/17bdabf8-a527-4f44-a3a8-6843db03a594" />

<img width="2880" height="1090" alt="dockerstatus_2" src="https://github.com/user-attachments/assets/de668b0f-d6c9-48eb-a36a-278123f88413" />

Step 8: Integrate Ansible with Jenkins

Now we automate the Ansible execution through Jenkins.Instead of manually running:
ansible-playbook install_dependencies.yml

Jenkins will execute the command automatically.
Jenkins responsibilities
Jenkins will:
1. Download the project from GitHub.
2. Access the Ansible directory.
3. Execute the Ansible playbook.
4. Configure the EC2 instance.
5. Verify the configuration.
6. Report success or failure.

Configure Jenkins Credentials

We should not store SSH private keys directly in the Jenkinsfile. Instead, use Jenkins Credentials.

Step 9: Create Jenkinsfile for Ansible

<img width="2880" height="358" alt="TestAnsible" src="https://github.com/user-attachments/assets/4918a327-a3de-4b84-b71b-31439782a6f6" />

<img width="2876" height="1800" alt="syntaxcheckplaybook" src="https://github.com/user-attachments/assets/5719148a-e771-4341-9e27-26ab79ecd5d8" />
This Jenkinsfile is an initial example. The SSH credential must be configured correctly, and the inventory must use the credential's key. The SSH agent setup and Ansible connection configuration should be aligned with your Jenkins environment. We will refine the pipeline during implementation.


Step 10: Create Jenkins Job for Ansible

Now create a Jenkins job to execute the Ansible pipeline.
| Field | Value |
|---|---|
| SCM | Git |
| Repository URL | Your ShopNow GitHub repository |
| Branch | main |
| Script Path | ansible/Jenkinsfile |

Step 11: Execute Ansible Through Jenkins
ShopNow-Ansible-Configuration

Step 12: Connect Terraform Pipeline with Ansible Pipeline
This is one of the most important tasks in Sprint 3.

We want to create an automated pipeline where Terraform creates infrastructure and Ansible configures it.


Step 13: Test the Entire Sprint 3 Workflow

<img width="2880" height="358" alt="TestAnsible" src="https://github.com/user-attachments/assets/5779896a-58ee-4027-a4db-8da38c9d4886" />






##Sprint 4

Sprint 4: CI/CD Pipeline for Application Deployment on Kubernetes (EKS)

Sprint 4 focuses on building a complete CI/CD pipeline using Jenkins, Docker, AWS ECR, and Kubernetes (EKS).

In the previous sprints, we completed the foundational work:
- Sprint 1: Application development.
- Sprint 2: Infrastructure provisioning using Terraform.
- Sprint 3: Configuration management using Ansible and Jenkins.
Now, in Sprint 4, we will automate the process of taking application code from GitHub, building it into a Docker image, pushing the image to Amazon ECR, and deploying it to Kubernetes running on Amazon EKS.

The goal is to eliminate manual deployment steps and create a reliable deployment pipeline.
The objectives of this sprint are:
- Create a multi-stage Jenkins pipeline.
- Automate application build and testing.
- Build Docker images using Jenkins.
- Push Docker images to Amazon Elastic Container Registry (ECR).
- Deploy the application to Amazon EKS.
- Create Kubernetes Deployment and Service manifests.
- Configure health checks.
- Configure Horizontal Pod Autoscaler (HPA).
- Validate the application deployment.
- Automate the workflow from GitHub to EKS.

Architecture
The architecture for Sprint 4 will look like this:
If the cluster is ACTIVE but nodes are missing, resolve the node group/IAM configuration before continuing.
Sprint 4 Project Structure
Your ShopNow project should contain the following structure:
shopNow-capstone/
│
├── frontend/
│   ├── Dockerfile
│   └── application files
│
├── backend/
│   ├── Dockerfile
│   └── application files
│
├── kubernetes/
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   └── hpa.yaml
│
├── Jenkinsfile
│
├── docker-compose.yml
│
└── README.md

Depending on your application architecture, the frontend and backend may be deployed separately.

For ShopNow, we will use separate Docker images for the frontend and backend.

This gives us the ability to:
- Scale frontend independently.
- Scale backend independently.
- Update frontend without redeploying backend.
- Update backend without redeploying frontend.

Step 1: Create AWS ECR Repositories
Amazon Elastic Container Registry (ECR) is a container registry that stores Docker images.

Jenkins will build Docker images and push them to ECR.

<img width="2880" height="1800" alt="CreateECR" src="https://github.com/user-attachments/assets/61a537a2-3b80-430d-b37d-d1b8b5f43822" />

<img width="2880" height="1800" alt="CreateECRRepo" src="https://github.com/user-attachments/assets/65bdbf80-e3a9-4e2b-85a3-38fc8a03f462" />

Step 2: Configure AWS Authentication for Jenkins

Jenkins requires permission to access AWS resources.

It must be able to:
- Authenticate to AWS.
- Log in to ECR.
- Push Docker images.
- Access EKS.
- Deploy Kubernetes resources.
The recommended approach is to use an IAM role or short-lived credentials wherever possible.

If Jenkins is running on an EC2 instance, an IAM instance role is generally preferred over storing permanent AWS access keys.

The Jenkins EC2 role should have the necessary permissions for:
- ECR authentication.
- ECR image push and pull.
- EKS cluster access.
- Kubernetes deployment authorization, where applicable.

Step 3: Authenticate Docker with AWS ECR
Before pushing Docker images, Docker must authenticate with ECR.The following command uses the AWS CLI to retrieve an authentication token.
<img width="2880" height="1800" alt="amazonEKS" src="https://github.com/user-attachments/assets/dccddcff-dc4f-49e2-b72b-7ed829edcb24" />

Step 4: Prepare Dockerfiles
We need Dockerfiles to build the application images. Because ShopNow contains a frontend and backend, we will create two Docker images.
Frontend Dockerfile
<img width="2880" height="1780" alt="dockerbuildfrontend" src="https://github.com/user-attachments/assets/be892383-29ca-478f-a906-b8db65945337" />
Backend Dockerfile
<img width="2880" height="1800" alt="dockerbuildbackend" src="https://github.com/user-attachments/assets/35107181-b752-46e2-b94e-65c99c78d038" />

Step 5: Build Docker Images
Before Jenkins automates the process, test Docker builds locally.
<img width="2880" height="1792" alt="dockerimages" src="https://github.com/user-attachments/assets/c89376b0-7736-4b62-8ad5-a74809b56a80" />

Step 6: Tag Docker Images for ECR
Docker images must be tagged with the ECR repository URL before they can be pushed.

<img width="2880" height="1800" alt="dockerbackendbuildoutput" src="https://github.com/user-attachments/assets/6614a573-f0d0-4ff6-bd4d-87a2bac9b7a0" />

Step 7: Push Images to AWS ECR
After Docker authentication, push the backend image.
<img width="2880" height="1800" alt="keyrings" src="https://github.com/user-attachments/assets/e90c7ee2-9584-410d-921a-be6aaca67a95" />

Step 8: Create Kubernetes Deployment Manifests

Kubernetes Deployment manages Pods.Instead of manually creating containers, we define the desired state in YAML files.Kubernetes ensures that the desired number of Pods are running.

kubernetes/
│
├── backend-deployment.yaml
├── backend-service.yaml
├── frontend-deployment.yaml
├── frontend-service.yaml
└── hpa.yaml

Step 9: Backend Deployment
Create:
kubernetes/backend-deployment.yaml


Step 10: Backend Service
Create:
kubernetes/backend-service.yaml

Step 11: Frontend Deployment
Create:
kubernetes/frontend-deployment.yaml

Step 11: Frontend Service
Create:
kubernetes/frontend-service.yaml

Step 12: Configure Health Checks
Kubernetes uses health checks to determine whether containers are functioning correctly.We are using two types of health checks.
A. Readiness Probe
readinessProbe:
  httpGet:
    path: /
    port: 80

Readiness checks answer:
Is this Pod ready to receive traffic?

If the Pod is not ready, Kubernetes does not send Service traffic to it.

B. Liveness Probe
livenessProbe:
  httpGet:
    path: /
    port: 80

Liveness checks answer:
Is this container still healthy?

If the liveness probe repeatedly fails, Kubernetes may restart the container.

Step 13 : Configure Horizontal Pod Autoscaler (HPA)

HPA automatically adjusts the number of Pods based on resource utilization.

Step 12: Configure Jenkins Pipeline

Now we will automate the entire process using Jenkins.

The pipeline will contain the following stages:


Checkout
   |
   v
Build
   |
   v
Test
   |
   v
Docker Build
   |
   v
ECR Login
   |
   v
Push Images
   |
   v
Deploy to EKS
   |
   v
Verify Deployment

Step 13: Jenkins Credentials
Jenkins needs access to AWS and EKS.

Depending on your Jenkins setup, you can use:
- IAM instance role for Jenkins EC2.
- IAM role assumption.
- AWS credentials stored securely in Jenkins.
If using IAM instance roles, verify that the Jenkins server can access AWS.

Step 13: Create Jenkinsfile
Create a Jenkinsfile in the root of your ShopNow project.
Understanding the Jenkins Pipeline

Stage 1: Checkout
stage('Checkout') {
    steps {
        git branch: 'main',
            url: 'YOUR_GITHUB_REPOSITORY_URL'
    }
}

Jenkins downloads your ShopNow application from GitHub.

This is the first stage of the pipeline.
Stage 2: Build Backend
stage('Build Backend') {
    steps {
        dir('backend') {
            sh 'npm install'
        }
    }
}

This stage installs the backend dependencies.

Jenkins executes:
npm install

The backend dependencies are downloaded based on package.json.
Stage 3: Test Backend
stage('Test Backend') {
    steps {
        dir('backend') {
            sh 'npm test'
        }
    }
}

This stage runs the backend tests.

If tests fail, the pipeline stops before the deployment stages.

This prevents broken application code from being deployed to EKS.
Your project must have a working test script in package.json. If it does not, we will configure it according to the actual ShopNow test files.

Stage 4: Build Frontend
stage('Build Frontend') {
    steps {
        dir('frontend') {
            sh 'npm install'
            sh 'npm run build'
        }
    }
}

Jenkins installs frontend dependencies and generates production build files.
Stage 5: Docker Build
docker build -t shopnow-backend:latest ./backend

This creates the backend Docker image.
docker build -t shopnow-frontend:latest ./frontend

This creates the frontend Docker image.

Now the application is packaged into containers.
Stage 6: ECR Login
aws ecr get-login-password --region ${AWS_REGION}

Jenkins obtains an authentication token from AWS.

Docker uses the token to authenticate with ECR.
Stage 7: Push to ECR
docker push ...

Jenkins uploads the Docker images to AWS ECR.

Now EKS can pull the images.
Stage 8: Configure EKS
aws eks update-kubeconfig

This command configures Kubernetes access for Jenkins.

Jenkins uses the AWS CLI to retrieve EKS cluster information and configure the local kubeconfig.

The following command verifies cluster connectivity:
kubectl get nodes

Stage 9: Deploy to EKS
kubectl apply -f kubernetes/backend-deployment.yaml

Kubernetes creates or updates the backend Deployment.

Similarly:
kubectl apply -f kubernetes/frontend-deployment.yaml

Kubernetes deploys the frontend.

The Service manifests expose the application through Kubernetes networking.
Stage 10: Verify Deployment
kubectl rollout status deployment/shopnow-backend

This checks whether the backend Deployment rollout has completed.
kubectl rollout status deployment/shopnow-frontend

This checks the frontend Deployment.

If both complete successfully, the deployment is considered successful at the Kubernetes rollout level.

Step 11: Configure Kubernetes Access for Jenkins

Jenkins must have permission to access your EKS cluster.After configuring AWS credentials on Jenkins, test:
aws eks update-kubeconfig --region us-east-1 --name shopnow-cluster
kubectl get nodes

then AWS authentication or EKS Kubernetes authorization is not configured correctly.

The Jenkins IAM identity must be granted the required EKS cluster access permissions.

Depending on your EKS configuration, this may be managed using EKS access entries and Kubernetes access policies, or the legacy aws-auth ConfigMap.

AWS authentication and Kubernetes authorization are two separate things:
1. IAM allows Jenkins to authenticate as an AWS identity.
2. EKS access configuration allows that identity to perform Kubernetes operations.
Both are required.

Step 12: Create Jenkins Pipeline Job

Open Jenkins.
Step 1
Click:
New Item

Step 2
Enter:
ShopNow-CI-CD-EKS

Step 3
Select:
Pipeline

Click:
OK

Step 4
Under Pipeline configuration, choose:
Pipeline script from SCM

Step 15: Run the Pipeline

Open the Jenkins job.

Click:
Build Now

Jenkins will execute:
Checkout
   ↓
Build Backend
   ↓
Test Backend
   ↓
Build Frontend
   ↓
Docker Build
   ↓
ECR Login
   ↓
Tag Images
   ↓
Push to ECR
   ↓
Configure EKS
   ↓
Deploy to EKS
   ↓
Verify Deployment

Monitor:
Jenkins
    → Build
        → Console Output

The pipeline should complete with:
Finished: SUCCESS

Step 16: Verify Deployment on EKS
After the Jenkins pipeline completes, verify the Kubernetes resources.
Check Deployments
kubectl get deployments
NAME                READY   UP-TO-DATE   AVAILABLE
shopnow-backend     2/2     2            2
shopnow-frontend    2/2     2            2

Check Pods
kubectl get pods

NAME                                  READY   STATUS
shopnow-backend-xxxxx                 1/1     Running
shopnow-backend-yyyyy                 1/1     Running
shopnow-frontend-xxxxx                1/1     Running
shopnow-frontend-yyyyy                1/1     Running

Check Services
kubectl get services

Expected:
NAME                       TYPE           PORT
shopnow-backend-service    ClusterIP     5000
shopnow-frontend-service   LoadBalancer   80

Check HPA
kubectl get hpa

Expected:
NAME                   TARGETS          MINPODS   MAXPODS   REPLICAS
shopnow-backend-hpa     10%/70%        2         5         2

Actual CPU values may vary.

Step 17: Access the Application
Check the frontend Service:
kubectl get svc shopnow-frontend-service

If the Service type is LoadBalancer, AWS may provision a load balancer.

You will see an external address similar to:

EXTERNAL-IP
a1b2c3d4e5f6.us-east-1.elb.amazonaws.com

Open the external DNS address in your browser:
http://a1b2c3d4e5f6.us-east-1.elb.amazonaws.com

Your ShopNow frontend should load.

Step 18: Test Auto-Scaling
We configured:minReplicas: 2
maxReplicas: 5

Now verify HPA:
kubectl get hpa

Describe HPA:
kubectl describe hpa shopnow-backend-hpa

If Metrics Server is working, Kubernetes can monitor CPU utilization.

The HPA will attempt to scale the backend based on the configured target.
Current Pods: 2
CPU Utilization: 85%
Target: 70%

Kubernetes may increase the number of Pods:
The exact scale-up behavior depends on metrics, current load, resource availability, and HPA behavior settings.

Step 19: Test the End-to-End CI/CD Pipeline
The final test is to verify the complete workflow.
Test scenario
Make a small change in your application.

If a GitHub webhook is configured, Jenkins should automatically start the pipeline.

Otherwise, manually trigger the Jenkins job.

Troubleshooting
Issue 1: Docker Build Failed
Error:

Possible causes
- Dockerfile missing.
- Incorrect path.
- Dependencies unavailable.
- Incorrect build context.
  
ECR Authentication Failed

no basic auth credentials

ImagePullBackOff
kubectl get pods

CrashLoopBackOff
kubectl logs POD_NAME

Possible causes:
- Application startup error.
- Missing environment variables.
- MongoDB connection failure.
- Incorrect container port.
- Incorrect Docker startup command.

Pods Are Pending

kubectl describe pod POD_NAME
Possible causes:
- Insufficient CPU.
- Insufficient memory.
- No available worker nodes.
- Incorrect resource requests.

LoadBalancer Pending
kubectl get svc

If the external address is still pending, check:
- Worker node networking.
- Subnets.
- AWS load balancer provisioning permissions.
- Service annotations.
- AWS networking configuration.
  
Jenkins Cannot Access EKS
Check:
aws sts get-caller-identity

Then:
aws eks update-kubeconfig --region us-east-1 --name shopnow-cluster
And:
kubectl get nodes
- 
