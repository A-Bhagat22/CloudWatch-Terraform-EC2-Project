# CloudWatch-Terraform-EC2-Project
# 🚀 CloudWatch Monitoring on EC2 using Terraform + SNS Alerts

## 📌 Project Description

This project provisions an AWS EC2 instance using **Terraform** and sets up monitoring via **AWS CloudWatch**.  
It creates a CloudWatch metric alarm for high **CPU usage** and sends alert notifications using **SNS email subscription**.

---

## 🛠 Tech Stack Used

- AWS EC2  
- AWS CloudWatch  
- AWS SNS  
- Terraform  
- Amazon Linux 2  
- CloudWatch Agent  
- IAM, VPC, Security Groups

---

## 📁 Folder Structure

📁 CloudWatch-Monitoring-EC2/
├── main.tf
├── variables.tf
├── outputs.tf
├── config.json
├── README.md


---

## 🚀 How to Deploy

1. Clone this repository  
2. Run `aws configure` to set your AWS credentials  
3. Edit `variables.tf` and replace the `email` variable with your SNS alert email  
4. Run `terraform init`  
5. Run `terraform apply` and confirm  
6. Confirm the SNS email subscription in your inbox  
7. Visit AWS Console → CloudWatch → Alarms to verify setup

---

## 📊 Simulate High CPU (Optional Test)

SSH into EC2 instance:
```bash
sudo yum install -y stress
stress --cpu 2 --timeout 300

This will simulate high CPU and trigger the alarm, sending you an email alert.

Destroy Resources After Use
terraform destroy
