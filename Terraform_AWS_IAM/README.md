# 🚀 Terraform AWS IAM Roles – Week 2 Project

![Terraform](https://img.shields.io/badge/Terraform-v1.9%2B-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)
![IaC](https://img.shields.io/badge/Infrastructure--as--Code-Enabled-blue)

This repository demonstrates AWS IAM role management using Terraform as part of my DevOps / SRE learning path.
The goal is to design, create, and manage IAM roles and policies using Infrastructure as Code instead of manual console configuration.
---

## 📌 Project Description
This project provisions multiple IAM roles along with trust relationships and policy attachments using Terraform.
It covers:
- Creating multiple IAM roles dynamically
- Defining assume role (trust) policies
- Creating and attaching IAM policies
- Attaching AWS managed policies
- Using for_each and map structures
- Implementing reusable Terraform module design
- Outputs for role validation

---

## 🎯 Learning Objectives
By completing this project, you will understand:
- IAM roles vs policies vs trust relationships
- Terraform loops (for_each)
- Policy attachment strategies
- Role-based access control design
- Infrastructure modularization
- Real-world Infrastructure-as-Code workflow




## 🔄 Provisioning Flow

           +-------------------+
           |   Terraform Apply |
           +----------+--------+
                      |
                      v
         +------------+----------+
         |  IAM Roles Created    |
         +------------+----------+
                      |
                      v
        +-------------+--------------+
        | Policies Attached to Roles |
        +-------------+--------------+
                      |
                      v          
        +-------------+-----------------+
        | Final IAM Roles Ready for Use |
        +-------------+-----------------+

---
### 🚀 Deployment Steps

1️⃣ Initialize Terraform
```bash
terraform init
```
2️⃣ Validate and Plan
```bash
terraform validate
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
##📤 Outputs

After deployment, you can verify :
- IAM Role Names
- ARN values
- Attached policies
- Trust relationships
```bash
terraform output
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
