# Karpenter
Just-in-time Nodes for Any Kubernetes Cluster

## Set Up the AWS Infrastructure
Setting Up Infrastructure and Environment Variables
```bash
export KARPENTER_NAMESPACE="kube-system"
export KARPENTER_VERSION=$(curl -sL "https://api.github.com/repos/aws/karpenter/releases/latest" | jq -r '.tag_name | ltrimstr("v")')
export K8S_VERSION=$(kubectl version -o json | jq -r '.serverVersion | "\(.major).\(.minor)"')
export AWS_PARTITION="aws"
export TEMPOUT="$(mktemp)"
curl -fsSL "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v${KARPENTER_VERSION}/website/content/en/preview/getting-started/getting-started-with-karpenter/cloudformation.yaml" > "${TEMPOUT}"

aws cloudformation deploy \
  --stack-name "Karpenter-${CLUSTER_NAME}" \
  --template-file "${TEMPOUT}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "ClusterName=${CLUSTER_NAME}"
```

## Subnet Tagging
Tag subnets so Karpenter can auto-discover them. (Note: `ASG_NAME` must be set to the Auto Scaling Group name of your add-on node group.)
```bash
SUBNETS=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $ASG_NAME --query 'AutoScalingGroups[0].VPCZoneIdentifier' --output text | tr ',' '\n')
for SUBNET in $SUBNETS
do
    aws ec2 create-tags --resources $SUBNET --tags Key=karpenter.sh/discovery,Value=${CLUSTER_NAME}
done

LAUNCH_TEMPLATE_ID=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $ASG_NAME --query 'AutoScalingGroups[0].MixedInstancesPolicy.LaunchTemplate.LaunchTemplateSpecification.LaunchTemplateId' --output text)
SECURITY_GROUPS=$(aws ec2 describe-launch-template-versions --launch-template-id $LAUNCH_TEMPLATE_ID --versions $Latest --query 'LaunchTemplateVersions[0].LaunchTemplateData.SecurityGroupIds' --output text)
for SECURITY_GROUP in $SECURITY_GROUPS
do
    aws ec2 create-tags --resources $SECURITY_GROUP --tags Key=karpenter.sh/discovery,Value=${CLUSTER_NAME}
done
```

## Configuring IRSA
Create a Kubernetes service account and AWS IAM Role, and associate them using IRSA to let Karpenter launch instances.
```bash
eksctl create iamserviceaccount \
  --cluster "${CLUSTER_NAME}" --region "${AWS_DEFAULT_REGION}" \
  --namespace "${KARPENTER_NAMESPACE}" --name karpenter \
  --role-name "${CLUSTER_NAME}-karpenter" \
  --attach-policy-arn "arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerNodeLifecyclePolicy-${CLUSTER_NAME}" \
  --attach-policy-arn "arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerIAMIntegrationPolicy-${CLUSTER_NAME}" \
  --attach-policy-arn "arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerEKSIntegrationPolicy-${CLUSTER_NAME}" \
  --attach-policy-arn "arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerInterruptionPolicy-${CLUSTER_NAME}" \
  --attach-policy-arn "arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerResourceDiscoveryPolicy-${CLUSTER_NAME}" \
  --attach-policy-arn "arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerZonalShiftPolicy-${CLUSTER_NAME}" \
  --role-only --approve

aws eks create-access-entry \
  --cluster-name "${CLUSTER_NAME}" \
  --principal-arn "arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}" \
  --type EC2_LINUX --region "${AWS_DEFAULT_REGION}"
```

## Install Karpenter
Install Karpenter using Helm
```bash
helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter \
  --version "${KARPENTER_VERSION}" \
  --namespace "${KARPENTER_NAMESPACE}" \
  --set "settings.clusterName=${CLUSTER_NAME}" \
  --set "settings.interruptionQueue=${CLUSTER_NAME}" \
  --set "serviceAccount.annotations.eks\.amazonaws\.com/role-arn=arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:role/${CLUSTER_NAME}-karpenter" \
  --set controller.resources.requests.cpu=1 \
  --set controller.resources.requests.memory=1Gi \
  --set controller.resources.limits.cpu=1 \
  --set controller.resources.limits.memory=1Gi \
  --set "priorityClassName=system-cluster-critical" \
  --wait
```

---

## NodePool
```yaml title="nodepool.yaml"
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 1m
  template:
    metadata:
      labels:
        node: app
    spec:
      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: default
      taints:
        - key: node
          value: app
          effect: NoSchedule
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
        - key: kubernetes.io/os
          operator: In
          values: ["linux"]
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["on-demand"]
        - key: karpenter.k8s.aws/instance-category
          operator: In
          values: ["c", "m", "r"]
        - key: karpenter.k8s.aws/instance-generation
          operator: Gt
          values: ["3"]
#       - key: node.kubernetes.io/instance-type
#         operator: In
#         values: ["c5.large", "c5.xlarge"]
      expireAfter: 720h
  limits:
    cpu: 1000
```

## EC2NodeClasses
```yaml title="ec2nodeclass.yaml"
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiFamily: Bottlerocket
  amiSelectorTerms:
    - id: ${AMI_ID}
  role: "KarpenterNodeRole-${CLUSTER_NAME}"
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${CLUSTER_NAME}
  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${CLUSTER_NAME}
  metadataOptions:
    httpPutResponseHopLimit: 1
  tags:
    Name: apdev-ec2nodeclass
```