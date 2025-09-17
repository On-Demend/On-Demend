# cURL
## GET
```bash
curl "http://localhost:8080/data?key1=value1&key2=value2"
```

## POST
```bash
curl -d '{"key1":"value1", "key2":"value2"}' \
-H "Content-Type: application/json" \
-X POST http://localhost:8080/data
```
```bash
curl -d "{\"key1\":\"value1\", \"key2\":\"value2\"}" -H "Content-Type: application/json" -X POST http://localhost:8080/data
```

## Quick API Request - Temporary
`Example`
```bash
ENDPOINT=$'http://<ENDPOINT>'
curl -X POST -H "Content-Type: application/json" -d '{"x": "cloud-bot", "y": 99}' http://${ENDPOINT}/green
```
```bash
curl http://${ENDPOINT}/green?id=example
```
```bash
curl -X POST -H "Content-Type: application/json" -d '{"name":"cloud-bot"}' http://${ENDPOINT}/red
```
```bash
curl http://${ENDPOINT}/red?id=example
```