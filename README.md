# 🛠️ Auction App - DevOps Deployment Project

Welcome! This repository contains a basic Django-based Auction web application that has been **containerized** using Docker and **deployed on Azure** using modern DevOps practices.

> 🚀 The project is live at: [https://auctionapp.duckdns.org](https://auctionapp.duckdns.org)

It will not be live for long because i was using Free Tier account.

---

## 📌 Project Goal

This is a **beginner-friendly DevOps project** created to:
- Understand and practice the **end-to-end CI/CD workflow**
- Learn how to deploy a containerized application using **Docker, Kubernetes, Jenkins**
- Use **Infrastructure as Code (IaC)** tools like **Terraform and Ansible**
- Set up **HTTPS with Let’s Encrypt** and **DuckDNS** for public access

---

## 🧰 Tech Stack & Tools Used

| Purpose                  | Tool/Tech                              |
|--------------------------|----------------------------------------|
| Application              | Python Django                          |
| Containerization         | Docker                                 |
| CI/CD                    | Jenkins                                |
| Container Orchestration  | Kubernetes (local, single-node on VM)  |
| IaC - Infra Provisioning | Terraform                              |
| IaC - Config Management  | Ansible                                |
| Public Access + DNS      | NGINX + DuckDNS + Let's Encrypt SSL    |
| Cloud Platform           | Microsoft Azure (Free Tier)            |

---

## 📁 Project Structure

├── Auction-App/
│ ├── Dockerfile
│ ├── docker-compose.yml (optional)
│ ├── k8s/ # Kubernetes manifests
│ ├── jenkins/ # Jenkins pipeline files
├── devops-infra/
│ └── azure-vm-terraform/ # Terraform code to provision VM
├── ansible-setup/
│ ├── inventory.ini
│ └── playbook.yml # Installs Docker, Kubernetes, Jenkins


---

## 🚀 Deployment Overview

1. **Terraform** is used to provision an Azure VM (`auction-vm`)
2. A second VM runs **Ansible**, which:
   - Installs **Docker**, **Kubernetes**, **Jenkins**
   - Sets up system packages and required configurations
3. Django app is:
   - Dockerized
   - Pushed to **Azure Container Registry**
   - Deployed into **Kubernetes** with a `NodePort` service
4. **NGINX** reverse proxy configured for:
   - SSL with **Let's Encrypt**
   - Dynamic DNS using **DuckDNS**
5. Final app is publicly accessible at [https://auctionapp.duckdns.org](https://auctionapp.duckdns.org)


## 📌 Notes

- This is **not a full-stack application** — it’s focused on **understanding deployment**.
- CI/CD pipeline is under progress for Jenkins integration.
- Ideal for learning how all DevOps tools fit together in a simple flow.

---

## 📂 How to Run Locally

**Pre-requisites:** Docker, Python 3.8+, virtualenv


git clone https://github.com/SathishbabuMG/Auction-App.git
cd Auction-App
docker build -t auction-app .
docker run -p 8000:8000 auction-app


🙌 Acknowledgements
Thanks to the open-source community and documentation that helped make this possible. This is part of my continuous journey to become a skilled DevOps Engineer.


