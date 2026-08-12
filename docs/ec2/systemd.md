# system daemon

File location : `/etc/systemd/system/<name>.service`

## Minimal Service File
```toml
[Unit]
Description=WS Minimal SVC File

[Service]
Type=simple
ExecStart=/opt/ws/app
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

## Recommended Service File
```toml
[Unit]
Description=WS Minimal SVC File

[Service]
User=ec2-user
Group=ec2-user
Type=simple
Environment="PORT=8080" "PASSWD=12345678"
EnvironmentFile=/opt/ws/.env
ExecStart=/opt/ws/app
WorkingDirectory=/opt/ws
Restart=on-failure
StandardOutput=file:/var/log/ws.log
StandardError=file:/var/log/ws.log

[Install]
WantedBy=multi-user.target
```