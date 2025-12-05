# 🚀 Terraform AWS EKS Cluster – Week 1 Project

![Terraform](https://img.shields.io/badge/Terraform-v1.9%2B-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)
![IaC](https://img.shields.io/badge/Infrastructure--as--Code-Enabled-blue)

This repository contains a Terraform-based AWS EKS cluster implementation as part of my DevOps / SRE learning path.
In **Week 1, the objective is to understand how Kubernetes infrastructure is provisioned on AWS using Infrastructure as Code rather than manual UI operations.

---

## 📌 Project Description
This project provisions a complete Amazon EKS cluster with managed EC2 worker nodes using Terraform.
It demonstrates:
- Creating IAM roles and trust relationships
- Attaching required AWS policies
- Deploying an EKS control plane
- Creating and managing node groups
- Understanding cluster networking basics
- Learning safe and reusable Terraform practices

---

## 🎯 Learning Objectives
By completing this project, you will understand:
- Core Terraform workflow (init → plan → apply)
- IAM trust policies for AWS services
- EKS architecture fundamentals
- Kubernetes control plane vs worker nodes
- Networking configuration for EKS
- Terraform dependencies and resource ordering
- Real-world Infrastructure-as-Code workflow




## 🔄 Provisioning Flow

           +-------------------+
           |   Terraform Apply |
           +----------+--------+
                      |
                      v
           +----------+------------+
           |  IAM Roles Created    |
           +------+----------------+
                      |
                      v
         +------------+--------------+
         |EKS Control Plane Created  |
         +------------+--------------+
                      |
                      v
           +----------+------------+
           |Node IAM Role Attached |
           +----------+------------+
                      |
                      v
          +-----------+----------+
          | Worker Nodes Launch  |
          +-----------+----------+
                      |
                      v          
           +--------------------+
           | Nodes Join Cluster |
           +--------------------+

---
### 🚀 Deployment Steps

1️⃣ Initialize Terraform
```bash
terraform init
```
2️⃣ Validate and Plan
```bash
terraform plan
```
3️⃣ Apply Infrastructurre
```bash
terraform apply
```
4️⃣ Destroy (when needed)
```bash
terraform destroy
```
⚠️ Before destroying, migrate your state back to local if you want to delete the S3 backend bucket:
```bash
terraform init -migrate-state -backend-config="path=terraform.tfstate"
```
---
### ❗ Important Terraform Notes
DO NOT commit:
```bash
.terraform/
terraform.tfstate
terraform-provider-*
```
Always use .gitignore before running:
```bash
terraform init
```

---
💬 Want to Improve This Project?
Feel free to fork the repo and raise PRs 👇
https://github.com/lucifer045/Terraform_AWS

---

### 👨‍💻 Author
**Prince Raghav** — Freelance DevOps & SRE Engineer  
🔗 GitHub: https://github.com/lucifer045  
🔗 LinkedIn: https://www.linkedin.com/in/prince-raghav
