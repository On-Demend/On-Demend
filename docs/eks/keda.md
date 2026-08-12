# KEDA

## IAM Credentials Setup
Create and associate an IAM role with a ServiceAccount.
```bash
eksctl create iamserviceaccount \
  --cluster=${CLUSTER_NAME} \
  --namespace=keda \
  --name=keda-operator \
  --attach-policy-arn=arn:aws:iam::aws:policy/AmazonSQSReadOnlyAccess \
  --approve
```

## Install
Install KEDA using Helm
```bash
helm repo add keda https://kedacore.github.io/charts
helm repo update

helm install keda keda/keda \
  --namespace keda \
  --create-namespace \
  --set serviceAccount.operator.name=keda-operator \
  --set serviceAccount.operator.create=false
```
