## Kubernetes Setting

`Bottle Rocket Userdata script`
```bash
settings.kubernetes.cluster-name = 'ws25-eks-cluster'
```

## CoreDNS
```bash
kubectl edit cm coredns -n kube-system
kubectl rollout restart deployment coredns -n kube-system
kubectl get --raw "/api/v1/nodes/NODE_NAME/proxy/configz" | jq | grep -i domain
```