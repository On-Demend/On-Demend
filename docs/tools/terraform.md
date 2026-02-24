# Terraform - IaC

## What is Terraform?
Terraform is an infrastructure as code tool that lets you build, change, and version infrastructure safely and efficiently. [Learn More](https://developer.hashicorp.com/terraform)

## Install Terraform on Amazon Linux
```bash
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```

## Simple Terraform Environment EC2 User Scripts
```bash
#!/bin/bash
yum install -y docker git
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum install -y terraform

type -p yum-config-manager >/dev/null || yum install -y yum-utils
yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
yum install -y gh
```