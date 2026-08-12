# Dockerfile

## Golang
### Alpine Linux

```dockerfile
FROM public.ecr.aws/docker/library/alpine

WORKDIR /app

COPY app .

RUN chmod +x ./app

RUN apk --no-cache add curl

CMD ["./app"]
```

### Amazon Linux (2023)

```dockerfile
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

WORKDIR /app

COPY app .

RUN chmod +x ./app

RUN dnf install -y shadow-utils

CMD ["./app"]
```