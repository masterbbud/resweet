import server
from sqlalchemy.sql.expression import text

from .models import User

def add_user(user: User) -> User:
    with server.Session() as s:
        query = text("""
            INSERT INTO users (username, display_name, pass_hash)
            VALUES (:username, :display_name, :pass_hash)
        """)

        s.execute(query, {"username": user.username, "display_name": user.display_name, "pass_hash": user.pass_hash})
        s.commit()
        return user
    
def get_user_by_uuid(id: str) -> User:
    with server.Session() as s:
        query = s.query(User).from_statement(text("""
            SELECT * FROM users
            WHERE id = :id
        """))

        user = s.execute(query, {"id": id}).one_or_none()
        s.commit()
        return None if user == None else user[0]
    
def get_user_by_username(username: str) -> User:
    with server.Session() as s:
        query = s.query(User).from_statement(text("""
            SELECT * FROM users
            WHERE username = :username
        """))

        user = s.execute(query, {"username": username}).one_or_none()
        s.commit()
        return None if user == None else user[0]