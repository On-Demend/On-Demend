## Serverless - SQL Lambda Function

`SELECT(Read) Only`
```bash
import json
import os
import pymysql

conn = None


def get_connection():
    global conn
    if conn is None or not conn.open:
        conn = pymysql.connect(
            host=os.environ["DB_HOST"],
            port=int(os.environ["DB_PORT"]),
            user=os.environ["DB_USER"],
            password=os.environ["DB_PASSWORD"],
            database=os.environ["DB_NAME"],
            connect_timeout=5,
            read_timeout=5,
            cursorclass=pymysql.cursors.DictCursor,
        )
    return conn


def lambda_handler(event, context):
    params = event.get("queryStringParameters") or {}
    name = params.get("name")

    if not name:
        return {
            "statusCode": 400,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "name parameter is required"}),
        }

    try:
        with get_connection().cursor() as cur:
            cur.execute("SELECT id, name FROM product WHERE name = %s", (name,))
            row = cur.fetchone()
    except Exception:
        global conn
        conn = None
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "internal server error"}),
        }

    if row is None:
        return {
            "statusCode": 404,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "product not found"}),
        }

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(row),
    }
```

`CRUD Version`

```bash
import json
import os
import pymysql

conn = None

def get_connection():
    global conn
    if conn is None or not conn.open:
        conn = pymysql.connect(
            host=os.environ["DB_HOST"],
            port=int(os.environ["DB_PORT"]),
            user=os.environ["DB_USER"],
            password=os.environ["DB_PASSWORD"],
            database=os.environ["DB_NAME"],
            connect_timeout=5,
            read_timeout=5,
            cursorclass=pymysql.cursors.DictCursor,
            autocommit=True
        )
    return conn

def lambda_handler(event, context):
    method = event.get("httpMethod")
    params = event.get("queryStringParameters") or {}
    
    try:
        body = json.loads(event.get("body", "{}")) if event.get("body") else {}
    except json.JSONDecodeError:
        return response(400, {"error": "Invalid JSON body"})

    try:
        if method == "GET":
            return handle_read(params)
        elif method == "POST":
            return handle_create(body)
        elif method == "PUT":
            return handle_update(body)
        elif method == "DELETE":
            return handle_delete(params)
        else:
            return response(405, {"error": f"Method {method} not allowed"})
            
    except Exception as e:
        global conn
        conn = None 
        return response(500, {"error": str(e)})

def handle_create(body):
    name = body.get("name")
    if not name:
        return response(400, {"error": "name is required"})
    
    with get_connection().cursor() as cur:
        cur.execute("INSERT INTO product (name) VALUES (%s)", (name,))
        new_id = cur.lastrowid
    return response(201, {"id": new_id, "name": name})

def handle_read(params):
    name = params.get("name")
    product_id = params.get("id")
    
    with get_connection().cursor() as cur:
        if product_id:
            cur.execute("SELECT id, name FROM product WHERE id = %s", (product_id,))
        elif name:
            cur.execute("SELECT id, name FROM product WHERE name = %s", (name,))
        else:
            cur.execute("SELECT id, name FROM product")
            return response(200, cur.fetchall())
            
        row = cur.fetchone()
        return response(200, row) if row else response(404, {"message": "Not found"})

def handle_update(body):
    product_id = body.get("id")
    new_name = body.get("name")
    
    if not product_id or not new_name:
        return response(400, {"error": "id and name are required"})
        
    with get_connection().cursor() as cur:
        affected = cur.execute("UPDATE product SET name = %s WHERE id = %s", (new_name, product_id))
    
    return response(200, {"updated": True}) if affected else response(404, {"message": "Product not found"})

def handle_delete(params):
    product_id = params.get("id")
    if not product_id:
        return response(400, {"error": "id parameter is required"})
        
    with get_connection().cursor() as cur:
        affected = cur.execute("DELETE FROM product WHERE id = %s", (product_id,))
    
    return response(200, {"deleted": True}) if affected else response(404, {"message": "Product not found"})

def response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*" 
        },
        "body": json.dumps(body),
    }
```