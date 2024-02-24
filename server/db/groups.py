import server
from sqlalchemy.sql.expression import text

from .models import Group

def add(group: Group) -> Group:
    with server.Session() as s:
        query = text("""
            INSERT INTO groups (name)
            VALUES (:name)
        """)

        s.execute(query, {"name": group.name})
        s.commit()
        return group
    
def get_by_uuid(id: str) -> Group:
    with server.Session() as s:
        query = s.query(Group).from_statement(text("""
            SELECT * FROM groups
            WHERE id = :id
        """))

        groups = s.execute(query, {"id": id}).one_or_none()
        s.commit()
        return None if len(groups) == 0 else groups[0]