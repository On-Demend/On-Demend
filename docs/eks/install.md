# Connection & Setup

## AWS CloudShell Setup

### (Optional) Install Kubectl
```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.36.2/2026-07-05/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
```
Download Specific Versions : [Set up kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

### Install eksctl
```bash
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | sudo tar xz -C /usr/local/bin
```

### Install Helm
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

### Connect EKS Cluster

#### Setting Frequently Used Environment Variables
Change the default region via `aws configure` before proceeding.
```bash
echo "export CLUSTER_NAME=$(eksctl get clusters -o json | jq -r '.[0].Name')" >> ~/.bashrc
echo "export AWS_DEFAULT_REGION=$(aws configure get region)" >> ~/.bashrc
echo "export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)" >> ~/.bashrc
source ~/.bashrc
```

#### Update Kubeconfig
```bash
aws eks update-kubeconfig --name $CLUSTER_NAME
```

---

## AWS EC2 Setup

### Install AWSCLIv2
```bash
pip3 install awscli --upgrade
```

### Install Docker
```bash
dnf install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
```

### Install Kubectl
```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.36.2/2026-07-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null
```
Download Specific Versions : [Set up kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

### Install eksctl
```bash
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /usr/local/bin
```

### Install Helm
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Install All K8s Resources (EC2)
```bash
#!/bin/bash
sed -i 's/#Port 22/Port 22222/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
echo 'examplepasswd' | passwd --stdin ec2-user

dnf update -y
dnf install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.36.2/2026-07-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /usr/local/bin
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

### Connect EKS Cluster

#### Setting Frequently Used Environment Variables
You may need to set the `TARGET_REGION` variable.
```bash
TARGET_REGION=${AWS_REGION:-"ap-northeast-2"}

aws configure set region $TARGET_REGION

echo "export CLUSTER_NAME=$(eksctl get clusters --region $TARGET_REGION -o json | jq -r '.[0].Name')" >> ~/.bashrc
echo "export AWS_DEFAULT_REGION=$TARGET_REGION" >> ~/.bashrc
echo "export AWS_REGION=$TARGET_REGION" >> ~/.bashrc
echo "export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)" >> ~/.bashrc

source ~/.bashrc
```

#### Update Kubeconfig
```bash
aws eks update-kubeconfig --name $CLUSTER_NAME
```
