# Install/Setting Script

## Install AWSCLIv2
`
pip3 install awscli --upgrade
`

## Install Docker
```bash
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
```

## Install Kubectl
```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null
```
Other Version Download : [Set up kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

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
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl
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