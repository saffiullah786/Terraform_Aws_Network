# Terraform_Aws_Network

# Terraform AWS Infrastructure

A hands-on **AWS infrastructure project built with Terraform** to provision a secure, multi-AZ VPC environment with public and private networking.

## Architecture

```text
                         Internet
                            │
                       Internet Gateway
                            │
                 ┌──────────┴──────────┐
                 │                     │
              AZ 1                   AZ 2
                 │                     │
          Public Subnet 1       Public Subnet 2
                 │                     │
          Bastion + EC2          Bastion + EC2
                 │                     │
          Private Subnet 1      Private Subnet 2
                 │                     │
                 └──────────┬──────────┘
                            │
                       NAT Gateway
                            │
                         Internet
```

## What This Project Includes

* VPC with `10.0.0.0/16` CIDR
* Two Availability Zones
* Two public subnets
* Two private subnets
* Internet Gateway
* NAT Gateway
* Public and private route tables
* Bastion hosts for SSH access
* Public EC2 instances
* Private EC2 instances using Auto Scaling
* Application Load Balancer
* Security Groups
* Network ACLs
* Route Table
* S3 bucket with versioning and public access blocked
* IAM role and instance profile for EC2
* Terraform variables and outputs

## Terraform Structure

```text
├── alb.tf
├── data.tf
├── iam.tf
├── main.tf
├── nacl.tf
├── output.tf
├── provider.tf
├── s3bucket.tf
├── sg.tf
├── terraform.tfvars
├── variables.tf
├── versions.tf
└── .gitignore
```

## How It Works

The infrastructure is divided into **public and private subnets**.

Public resources can communicate with the internet through the **Internet Gateway**.

Private EC2 instances do not have public IP addresses. When they need outbound internet access, traffic goes through:

```text
Private EC2
    ↓
Private Route Table
    ↓
NAT Gateway
    ↓
Internet Gateway
    ↓
Internet
```

SSH access to private instances is designed to go through a **bastion host** rather than directly from the internet.

## Deployment

Initialize Terraform:

```bash
terraform init
```

Format the configuration:

```bash
terraform fmt
```

Validate the configuration:

```bash
terraform validate
```

Preview the infrastructure:

```bash
terraform plan
```

Create the infrastructure:

```bash
terraform apply
```

To remove the infrastructure after testing:

```bash
terraform destroy
```

## Security

The project uses:

* Separate public and private subnets
* Security Groups
* Network ACLs
* Bastion-based SSH access
* No public IPs on private EC2 instances
* S3 public access blocked
* IAM role for EC2 access to AWS services

Private keys, Terraform state files, and other sensitive files are excluded using `.gitignore`.

## Technologies

* **Terraform**
* **AWS VPC**
* **EC2**
* **Application Load Balancer**
* **NAT Gateway**
* **Internet Gateway**
* **S3**
* **IAM**
* **RouteTable**
* **Security Groups**
* **Network ACLs**
## Routing

The VPC uses separate route tables for public and private subnets.

### Public Route Table

The public route table is associated with both public subnets.

It contains:

```text
10.0.0.0/16 → local
0.0.0.0/0   → Internet Gateway
```

The `local` route allows communication within the VPC, while the default route sends internet-bound traffic to the Internet Gateway.

```text
Public EC2
    ↓
Public Route Table
    ↓
Internet Gateway
    ↓
Internet
```

### Private Route Table

The private route table is associated with both private subnets.

It contains:

```text
10.0.0.0/16 → local
0.0.0.0/0   → NAT Gateway
```

Private instances do not have public IP addresses. Their outbound internet traffic is sent to the NAT Gateway, which is located in a public subnet.

```text
Private EC2
    ↓
Private Route Table
    ↓
NAT Gateway
    ↓
Internet Gateway
    ↓
Internet
```

The NAT Gateway allows private instances to **initiate outbound internet connections without being directly reachable from the internet**.

### Route Table Structure

```text
VPC
│
├── Public Route Table
│   ├── Public Subnet 1
│   └── Public Subnet 2
│
└── Private Route Table
    ├── Private Subnet 1
    └── Private Subnet 2
```

AWS also creates a default/main route table automatically when a VPC is created. The Terraform configuration uses dedicated public and private route tables for the project's subnets.

## Purpose

This project was built as a practical exercise to understand **Infrastructure as Code (IaC)** and how Terraform can be used to provision and manage AWS infrastructure instead of creating resources manually through the AWS Console.

> Built for learning and DevOps practice.
