# Push2Prod: Episode 1 — From Terminal to Production

> Real DevOps. No Fluff. Just Builds.

Welcome to the first episode of **Push2Prod**, where we go beyond tutorials and actually ship infrastructure and code — with security, scalability, and CI/CD built in.

This project shows how to deploy a real FastAPI app to **AWS ECS with Fargate** using:
- ✅ Terraform for infrastructure as code
- ✅ GitHub Actions for CI/CD
- ✅ Trivy for container security scanning
- ✅ S3 + DynamoDB for secure remote state management

---

## 🧱 Stack Overview

| Tool            | Purpose                           |
|-----------------|-----------------------------------|
| **FastAPI**     | Lightweight web framework         |
| **Docker**      | Containerization                  |
| **ECR**         | Container image registry          |
| **ECS Fargate** | Serverless container hosting      |
| **ALB**         | Load balancing for HTTP traffic   |
| **Terraform**   | Provision AWS infra               |
| **GitHub Actions** | CI/CD pipeline                  |
| **Trivy**       | Security scanning for Docker      |
| **S3 + DynamoDB** | Secure remote state + locking    |

---

## 📂 Project Structure

my-prod-app/
├── app/                    # FastAPI app code
│   ├── main.py
│   ├── requirements.txt
│   ├── templates/          # HTML templates (if any)
│   └── static/             # Static assets
├── .github/
│   └── workflows/
│       └── deploy.yml      # GitHub Actions pipeline
├── terraform/              # ECS, ALB, ECR, and app infrastructure
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
├── terraform-bootstrap/    # S3 bucket and DynamoDB for state management
│   ├── main.tf
│   └── terraform.tfstate
├── .gitignore
├── Dockerfile              # FastAPI app container
├── Jenkinsfile             # Optional Jenkins pipeline
├── README.md
├── .pre-commit-config.yaml # (Optional) Code formatting/linting

---

## 🚀 CI/CD Workflow Highlights

Your pipeline (in `deploy.yml`) does the following:

1. **Builds and tags a Docker image**
2. **Scans the image using Trivy**
3. **Pushes the image to ECR**
4. **Applies Terraform changes**
5. **Updates ECS service with the new image**

🔐 Secrets used:
- `AWS_ACCOUNT_ID`
- GitHub OIDC for secure, secretless authentication

---

## 🔐 Security Highlights

- 🔒 Encrypted S3 bucket for state
- 🔄 Versioning + lifecycle for rollback
- 🔐 DynamoDB for state locking
- 🧪 Trivy scans for CRITICAL/HIGH vulnerabilities

---

## 🧪 Local Development

```bash
# Build Docker image locally
docker build -t my-prod-app .

# Run locally on port 8000
docker run -p 8000:8000 my-prod-app

# 1. Bootstrap remote state (S3 + DynamoDB)
cd terraform-bootstrap
terraform init
terraform apply -auto-approve

# 2. Deploy full stack
cd ../terraform
terraform init
terraform apply -auto-approve \
  -var="ecr_image_uri=<your-latest-image-uri>"