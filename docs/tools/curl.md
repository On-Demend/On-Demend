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
ENDPOINT=$'<ENDPOINT>'
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

`Example 2`
```bash
ENDPOINT=$'<ENDPOINT>'
curl https://${ENDPOINT}/v1/user -X POST -H "Content-Type: application/json" -d \
'{
"requestid":"77777777",
"uuid":"8c6a5c6a-758f-4bc5-9bdf-3e573a0ad729",
"username":"dbdump810000",
"email":"dbdump810000@example.io",
"status_message":"I’m Very Happy"
}'
```
```bash
curl https://${ENDPOINT}/v1/user?id=dbdump810000&requestid=77777777&uuid=8c6a5c6a-758f-4bc5-9bdf-3e573a0ad729
```

```bash
ENDPOINT=$'<ENDPOINT>'
curl https://${ENDPOINT}/v1/product -X POST -H "Content-Type: application/json" -d \
'{
"requestid":"66666666",
"uuid":"8c6a5c6a-758f-4bc5-9bdf-3e573a0ad729",
"id":"dbdump620000",
"name":"dbdump620000",
"price":6200
}'
```
```bash
curl https://${ENDPOINT}/v1/product?id=dbdump6200&requestid=66666666&uuid=8c6a5c6a-758f-4bc5-9bdf-3e573a0ad729
```

```bash
ENDPOINT=$'<ENDPOINT>'
curl https://${ENDPOINT}/v1/stress -X POST -H "Content-Type: application/json" -d \
'{
"requestid":"11111111",
"uuid":"8c6a5c6a-758f-4bc5-9bdf-3e573a0ad729",
"length": 256
}'
```