## Kubernetes Setting
`Add Userdata scripts`
```bash
[settings.kubernetes]
cluster-domain = "ws25.me"
```

## CoreDNS
```bash
kubectl edit -n kube-system cm coredns
kubectl rollout restart deployment -n kube-system coredns 
kubectl get --raw "/api/v1/nodes/NODE_NAME/proxy/configz" | jq | grep -i domain
```