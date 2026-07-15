# systemd

File location : `/etc/systemd/system/<name>.service`

### Service Unit File
```bash
[Unit]
Description=WorldPay Service

[Service]
Type=simple
EnvironmentFile=/opt/worldpay/.env
ExecStart=/opt/worldpay/app
WorkingDirectory=/opt/worldpay
Restart=on-failure
StandardOutput=file:/var/log/worldpay.log
StandardError=file:/var/log/worldpay.log

[Install]
WantedBy=multi-user.target
```