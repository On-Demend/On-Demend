# Basic Objects

## Deployment

```yaml title="deployment.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ws25-green-deploy
  namespace: ws25
spec:
  replicas: 2
  selector:
    matchLabels:
      app: green
  template:
    metadata:
      labels:
        app: green
    spec:
      terminationGracePeriodSeconds: 60
      nodeSelector:
        node: app
      tolerations:
      - key: node
        operator: Equal
        value: app
        effect: NoSchedule
      containers:
      - name: ws26-green-app
        image: 000000000000.dkr.ecr.us-east-1.amazonaws.com/green:v1.0.0
        resources:
          requests:
            cpu: 250m
            memory: 512Mi
          limits:
            cpu: 250m
            memory: 512Mi
        envFrom:
        - secretRef:
            name: aurora-secret
        ports:
        - containerPort: 80
```

## Service
```yaml title="service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: ws25-green-service
  namespace: ws25
spec:
  type: NodePort
  selector:
    app: green
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
```

## Ingress
```yaml title="ingress.yaml"
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ws25-ingress
  namespace: ws25
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: ws25-app-alb
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/target-node-labels: node=app
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/healthcheck-path: /health
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
          - path: /green
            pathType: Exact
            backend:
              service:
                name: ws25-green-service
                port:
                  number: 80
          - path: /red
            pathType: Exact
            backend:
              service:
                name: ws25-red-service
                port:
                  number: 80
```
## Secret
```yaml title="secret.yaml"
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
  namespace: ws26
stringData:
  DB_USER: admin
  DB_PASSWD: examplepw
  DB_URL: ws26-db-instance.c84fdel995b8.us-east-1.rds.amazonaws.com
```