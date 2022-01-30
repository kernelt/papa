from typing import Optional
from fastapi import FastAPI, Request
from starlette_context import middleware, plugins, context
from datetime import datetime
from configparser import ConfigParser
import psycopg2

def config(filename='database.ini', section='postgresql'):
    parser = ConfigParser()
    parser.read(filename)
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, filename))

    return db

def create_tables():
    conn = None
    try:
        params = config()
        conn = psycopg2.connect(**params)
        cur = conn.cursor()
        cur.execute("CREATE TABLE IF NOT EXISTS history (id BIGSERIAL PRIMARY KEY, time VARCHAR(255), ip VARCHAR(255))")
        cur.close()
        conn.commit()
        print("table 'history' is created")
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def save_ip(time, ip):
    conn = None
    try:
        params = config()
        conn = psycopg2.connect(**params)
        cur = conn.cursor()
        cur.execute("INSERT INTO history (time, ip) VALUES ('{}', '{}')".format(time, ip))
        conn.commit()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
    print("new ip is saved", ip)


def list_ip():
    conn = None
    try:
        params = config()
        conn = psycopg2.connect(**params)
        cur = conn.cursor()
        cur.execute("SELECT * FROM history")
        history = cur.fetchall()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

    return history

create_tables()
app = FastAPI()


app.add_middleware(
    middleware.ContextMiddleware,
    plugins=(
        plugins.ForwardedForPlugin(),
    ),
)

@app.get("/")
async def root():
    return {"message": "papa-webapp"}

@app.get("/client-ip")
async def client_ip():
    current_time = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
    forwarded_for = context.data["X-Forwarded-For"]
    save_ip(current_time, forwarded_for)
    return {current_time: forwarded_for}

@app.get("/client-ip/list")
async def client_ip_list():
    return list_ip()