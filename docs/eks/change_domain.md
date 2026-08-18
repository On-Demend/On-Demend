# Customize Cluster Domain

## Add Launch Template UserData

- Only Bottlerocket

```bash
[settings.kubernetes]
cluster-domain = "example.skills.local"
```

## Apply CoreDNS

Update the `*.cluster.local` domain

```bash
kubectl edit -n kube-system cm coredns

kubectl rollout restart deployment -n kube-system coredns 
```