# Install/Setting Script

## Install AWSCLIv2
`
pip3 install awscli --upgrade
`

## Install Docker
```bash
dnf install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
```

## Install Kubectl
```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.3/2025-08-03/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null
```
Download other Versions : [Set up kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

## Install Helm
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Install eksctl
```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
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
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.3/2025-08-03/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
```

## Connect to EKS Cluster
### Set Environment Variables
```bash
echo "export CLUSTER_NAME=$(eksctl get clusters -o json | jq -r '.[0].Name')" >> ~/.bashrc
echo "export AWS_DEFAULT_REGION=$(aws configure get region)" >> ~/.bashrc
echo "export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)" >> ~/.bashrc
source ~/.bashrc
```
### Upade Kubeconfig
`aws eks update-kubeconfig --name $CLUSTER_NAME`