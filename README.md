
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


## SPRINT-1


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

  