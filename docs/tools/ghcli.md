# GitHub CLI

## Amazon Linux 2023 (Recommanded)
```
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh -y
```

## Amazon Linux 2
```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo yum install gh -y
```