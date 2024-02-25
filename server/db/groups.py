import server
from sqlalchemy.sql.expression import text

from .models import Group

def add_group(group: Group) -> Group:
    with server.Session() as s:
        query = s.query(Group).from_statement(text("""
            INSERT INTO groups (name)
            VALUES (:name)
            RETURNING *
        """))

        group = s.execute(query, {"name": group.name}).one_or_none()[0]
        s.commit()
        return group
    
def get_group_by_name(name : str) -> Group:
    with server.Session() as s:
        query = s.query(Group).from_statement(text("""
            SELECT * FROM groups
            WHERE name = :name
        """))

        group = s.execute(query, {"name": name}).one_or_none()
        s.commit()
        return None if group == None else group[0]
    
def get_user_group(user_id : str) -> Group:
    with server.Session() as s:
        query = s.query(Group).from_statement(text("""
            SELECT groups.* FROM groups
            INNER JOIN users_groups
            ON groups.id = users_groups.group_id
            INNER JOIN users
            ON users.id = users_groups.user_id
            WHERE users.id = :id
        """))

        group = s.execute(query, {"id": user_id}).one_or_none()
        s.commit()
        return None if group == None else group[0]