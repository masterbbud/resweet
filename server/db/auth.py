import server
from sqlalchemy.sql.expression import text
from hashlib import sha256
import secrets

from .models import User

def try_login(username: str, password: str) -> str:
    with server.Session() as s:
        query = s.query(User).from_statement(text("""
            SELECT * FROM users
            WHERE username = :username AND pass_hash = :pass_hash
        """))

        user = s.execute(query, {"username": username, "pass_hash": sha256(password.encode("utf-8")).hexdigest()}).one_or_none()
        s.commit()

        if user == None: return None

        token = secrets.token_urlsafe()
        query = text("""
            UPDATE users
            SET token = :token
            WHERE username = :username
        """)

        s.execute(query, {"token": token, "username": username})
        s.commit()
        return token
    
def authenticate(token: str) -> User:
    with server.Session() as s:
        query = s.query(User).from_statement(text("""
            SELECT * FROM users
            WHERE token = :token
        """))

        user = s.execute(query, {"token": token}).one_or_none()
        s.commit()
        return None if user == None else user[0]