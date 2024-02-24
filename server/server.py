from fastapi import FastAPI
from configparser import ConfigParser
from sqlalchemy.orm import sessionmaker
import os
from google.cloud.sql.connector import Connector, IPTypes
import pg8000
import sqlalchemy
import json

from api import users

app = FastAPI()
app.include_router(users.app)

def connect_with_connector() -> sqlalchemy.engine.base.Engine:
    """
    Initializes a connection pool for a Cloud SQL instance of Postgres.

    Uses the Cloud SQL Python Connector package.
    """
    # Note: Saving credentials in environment variables is convenient, but not
    # secure - consider a more secure solution such as
    # Cloud Secret Manager (https://cloud.google.com/secret-manager) to help
    # keep secrets safe.

    # NOTE From (https://cloud.google.com/sql/docs/postgres/connect-connectors)

    # Load from json file if it exists
    try:
        obj = json.load(open('database.json'))
        os.environ["INSTANCE_CONNECTION_NAME"] = obj['name'] # e.g. 'project:region:instance'
        os.environ["DB_USER"] = obj['user']  # e.g. 'my-db-user'
        os.environ["DB_PASS"] = obj['password']  # e.g. 'my-db-password'
        os.environ["DB_NAME"] = obj['database']  # e.g. 'my-database'
    except FileNotFoundError:
        print("No database.json file found. If you are running locally, please create this file.")

    instance_connection_name = os.environ[
        "INSTANCE_CONNECTION_NAME"
    ]  # e.g. 'project:region:instance'
    db_user = os.environ["DB_USER"]  # e.g. 'my-db-user'
    db_pass = os.environ["DB_PASS"]  # e.g. 'my-db-password'
    db_name = os.environ["DB_NAME"]  # e.g. 'my-database'

    ip_type = IPTypes.PRIVATE if os.environ.get("PRIVATE_IP") else IPTypes.PUBLIC

    # initialize Cloud SQL Python Connector object
    connector = Connector()

    def getconn() -> pg8000.dbapi.Connection:
        conn: pg8000.dbapi.Connection = connector.connect(
            instance_connection_name,
            "pg8000",
            user=db_user,
            password=db_pass,
            db=db_name,
            ip_type=ip_type,
        )
        return conn

    # The Cloud SQL Python Connector can be used with SQLAlchemy
    # using the 'creator' argument to 'create_engine'
    pool = sqlalchemy.create_engine(
        "postgresql+pg8000://",
        creator=getconn,
        # ...
    )
    return pool

pool = connect_with_connector()
Session = sessionmaker(pool, expire_on_commit=False)



@app.get('/')
def test():
    return {'test_result': True}

@app.get('/test-sql')
def test_sql():
    query = """
    DROP TABLE IF EXISTS test;
    CREATE TABLE test (testcol int);
    INSERT INTO test (testcol) VALUES (5);
    SELECT * FROM test;
    """
    # This works! Everything is set up :D
    conn = pool.connect()
    result = conn.execute(sqlalchemy.text(query))
    for record in result:
        print(record)
    return {'test_result': str(result)}

def main():
    pass
    
main()