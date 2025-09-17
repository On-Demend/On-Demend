## SSH Connect Command (Example)
```bash
ssh ec2-user@3.35.171.254 -i ws-key.pem -p 22
```
## Change Port & Enable Password (Example)
```bash
sed -i 's/#Port 22/Port 22222/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
echo 'examplepasswd' | passwd --stdin ec2-user
```
## VSCode SSH Config (Example)
- Extension : Remote - SSH
```bash
Host Bastion
  HostName 3.35.171.254
  User ec2-user
  Port 22222
  IdentityFile C:\Users\Example\Downloads\bastion-key.pem
```

## (No SSH) Install VSCode Server
```bash
curl -fsSL https://code-server.dev/install.sh | sh

cat <<EOF > /home/ec2-user/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8080
auth: none
cert: false
EOF

sudo systemctl enable --now code-server@ec2-user
```