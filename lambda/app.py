import os
import json
import boto3
import pymysql
from botocore.exceptions import ClientError

SECRETS_ARN = os.environ.get("SECRETS_ARN") or os.environ.get("SECRETS_ARN")  # env var from TF

sm = boto3.client("secretsmanager")

def get_db_credentials():
    resp = sm.get_secret_value(SecretId=SECRETS_ARN)
    secret = json.loads(resp["SecretString"])
    return secret

def get_connection():
    creds = get_db_credentials()
    conn = pymysql.connect(
        host=os.environ.get("DB_HOST", ""),
        user=creds["username"],
        password=creds["password"],
        database=creds.get("dbname","personasdb"),
        cursorclass=pymysql.cursors.DictCursor,
        connect_timeout=5
    )
    return conn

def lambda_handler(event, context):
    # Simple router that proxies to DB. Implement the endpoints required.
    method = event.get("requestContext",{}).get("http",{}).get("method") or event.get("httpMethod")
    path = event.get("rawPath") or event.get("path", "/")
    try:
        if path.startswith("/persons") and method == "GET":
            return list_persons()
        if path.startswith("/persons") and method == "POST":
            body = json.loads(event.get("body") or "{}")
            return create_person(body)
        if path.startswith("/persons/") and method == "PUT":
            person_id = path.rsplit("/",1)[-1]
            body = json.loads(event.get("body") or "{}")
            return update_person(person_id, body)
        if path.startswith("/persons/") and method == "DELETE":
            person_id = path.rsplit("/",1)[-1]
            return delete_person(person_id)
        return respond(404, {"message":"Not Found"})
    except Exception as e:
        return respond(500, {"message": str(e)})

def list_persons():
    conn = get_connection()
    with conn.cursor() as cur:
        cur.execute("SELECT id, nombre, apellidos, email, tipo_documento, numero_documento FROM persons")
        rows = cur.fetchall()
    conn.close()
    return respond(200, rows)

def create_person(payload):
    # basic validation
    if payload.get("tipo_documento") not in ("DNI","CE"):
        return respond(400, {"message":"Tipo de documento inválido"})
    conn = get_connection()
    with conn.cursor() as cur:
        # generate uuid in app or use AUTO_INCREMENT
        import uuid
        person_id = str(uuid.uuid4())
        cur.execute(
            "INSERT INTO persons (id,nombre,apellidos,email,tipo_documento,numero_documento) VALUES (%s,%s,%s,%s,%s,%s)",
            (person_id, payload.get("nombre"), payload.get("apellidos"), payload.get("email"), payload.get("tipo_documento"), payload.get("numero_documento"))
        )
        conn.commit()
    conn.close()
    return respond(200, {"id": person_id, **payload})

def update_person(person_id, body):
    conn = get_connection()
    with conn.cursor() as cur:
        cur.execute("UPDATE persons SET email=%s WHERE id=%s", (body.get("email"), person_id))
        conn.commit()
    conn.close()
    return respond(200, {"id": person_id, "email": body.get("email")})

def delete_person(person_id):
    conn = get_connection()
    with conn.cursor() as cur:
        cur.execute("DELETE FROM persons WHERE id=%s", (person_id,))
        conn.commit()
    conn.close()
    return respond(200, {"message": f"Persona {person_id} eliminada"})

def respond(status, body):
    return {
        "statusCode": status,
        "headers": {"Content-Type":"application/json"},
        "body": json.dumps(body)
    }
