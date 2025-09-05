# Docker Installation - ECS

## Install Docker
Only Amazon Linux 2023
```bash
pip3 install awscli --upgrade # (Optional) Upgrade AWSCLIv2 
sudo dnf install -y docker # Install Docker package
sudo systemctl start docker # Start Docker Service
sudo systemctl enable docker # Enable Docker Daemon
sudo usermod -aG docker ec2-user # Reconnect Required
```

## Install Docker on Userdata
```bash
dnf install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
```

