# Pod IAM Roles

## Amazon EKS Pod Identity

- Install Amazon EKS Pod Identity Agent Add-on.

### Create Trust Policy File

!!! info
    The following JSON file validates the account ARN and cluster name. If you only want to apply it to pods, remove the `condition` statement.

```bash
cat <<EOF > trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "pods.eks.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession"
      ],
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "${AWS_ACCOUNT_ID}"
        },
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:eks:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:cluster/${CLUSTER_NAME}"
        }
      }
    }
  ]
}
EOF
```

### Create Policy File
Example : Allow `dynamodb:PutItem` and `kms:Decrypt`
```bash
cat << 'EOF' > policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowDynamoDBPutItem",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowKMSDecrypt",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt"
      ],
      "Resource": "*"
    }
  ]
}
EOF
```

### Create IAM Policy & Role

```bash
aws iam create-policy \
  --policy-name "example-policy" \
  --policy-document file://policy.json \
  --description "Example Policy"

aws iam create-role \
  --role-name "example-role" \
  --assume-role-policy-document file://trust-policy.json \
  --description "Example Role"

aws iam attach-role-policy \
  --role-name "example-role" \
  --policy-arn "arn:aws:iam::$AWS_ACCOUNT_ID:policy/example-policy"
```

### EKS Pod Identity Association
```bash
aws eks create-pod-identity-association \
  --cluster-name example-cluster \
  --namespace example \
  --service-account example-sa \
  --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/example-role
```

---

## IAM Roles for Service Accounts (IRSA)

- Enable OIDC Provider for your EKS Cluster

### Create Policy File
Example : Allow `dynamodb:PutItem` and `kms:Decrypt`
```bash
cat << 'EOF' > policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowDynamoDBPutItem",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowKMSDecrypt",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt"
      ],
      "Resource": "*"
    }
  ]
}
EOF
```

### Create IAM Policy & Role
```bash
aws iam create-policy \
    --policy-name example-policy \
    --policy-document file://policy.json
```

### Create IAM Roles for Service Accounts
```bash
eksctl create iamserviceaccount \
  --cluster=$CLUSTER_NAME \
  --namespace=example \
  --name=example-sa \
  --role-name=example-role \
  --attach-policy-arn=arn:aws:iam::$AWS_ACCOUNT_ID:policy/example-policy \
  --approve
```