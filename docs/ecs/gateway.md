# Dockerfile Format

### Test: Amazonlinux

```bash
    server {
        listen 80;
        server_name _;
        location /v1 {
            proxy_pass         http://server.com/;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
        location = /health {
            proxy_pass         http://server.com/health;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
```