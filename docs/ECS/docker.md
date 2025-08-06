# Dockerfile Format

## [Golang] Build
### Single Architecture
- Alpine Linux

``` bash
FROM alpine:latest

WORKDIR /app

COPY . .

RUN apk --no-cache add curl

CMD ["./app"]
```

- Amazon Linux

``` bash
FROM amazonlinux:2023

WORKDIR /app

COPY . .

RUN yum install -y shadow-utils

CMD ["./app"]
```

- Ubuntu

``` bash
FROM ubuntu:latest

WORKDIR /app

COPY . .

RUN apt install -y curl

CMD ["./app"]
```
