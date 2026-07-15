## Deployment
### ***`deployment.yaml`***
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ws26-green-deploy
  namespace: ws26
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

## service
### ***`service.yaml`***
```bash
apiVersion: v1
kind: Service
metadata:
  name: ws26-green-service
  namespace: ws26
spec:
  type: NodePort
  selector:
    app: green
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

## Ingress
### ***`ingress.yaml`***
```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ws26-app-alb
  namespace: ws26
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: ws26-app-alb
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/target-node-labels: node=app
    alb.ingress.kubernetes.io/scheme: internal
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
                name: ws26-green-service
                port:
                  number: 80
          - path: /red
            pathType: Exact
            backend:
              service:
                name: ws26-red-service
                port:
                  number: 80
```
## Secret
### ***`secret.yaml`***
```bash
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