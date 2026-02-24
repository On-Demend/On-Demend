## Download

Download Link : [ekristen/aws-nuke](https://github.com/ekristen/aws-nuke)

## Settings

`config.yml`
```bash
regions:
- us-east-1
# - us-east-2
# - us-west-1
# - us-west-2
# - ap-south-1
# - ap-northeast-1
- ap-northeast-2
# - ap-northeast-3
# - ap-southeast-1
# - ap-southeast-2
# - ca-central-1
# - eu-central-1
# - eu-north-1
# - eu-west-1
# - eu-west-2
# - eu-west-3
# - sa-east-1
- global

blocklist:
- "999999999999"

accounts:
  "000000000000": # <- Account Alias
    filters:
      IAMUser:
      - "<IAM UserName>"
      IAMUserPolicyAttachment:
      - "<IAM UserName> -> AdministratorAccess"
      IAMUserAccessKey:
      - "<IAM UserName> -> <AccessKey>"
```

## RUN
```bash
aws-nuke nuke -c ".\config.yml" --no-dry-run
```