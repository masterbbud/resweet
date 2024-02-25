import server
from sqlalchemy.sql.expression import text
import secrets

from .models import Invite, Group, User
from .groups import *

def create_invite(group: Group):
    invite_code = secrets.token_urlsafe(8)

    with server.Session() as s:
        query = text("""
            INSERT INTO invites (group_id, invite_code)
            VALUES (:group_id, :invite_code)
        """)
        
        s.execute(query, {"group_id": group.id, "invite_code": invite_code})
        s.commit()

def get_invite(invite_code: str) -> Invite:
    with server.Session() as s:
        query = s.query(Invite).from_statement(text("""
            SELECT * FROM invites
            WHERE invite_code = :invite_code
        """))

        code = s.execute(query, {"invite_code": invite_code}).one_or_none()
        s.commit()
        return None if code == None else code[0]
    
def accept_invite(invite: Invite, user: User):
    with server.Session() as s:
        query = text("""
            DELETE FROM invites
            WHERE invite_code = :invite_code
        """)

        group = get_group_by_uuid(invite.group_id)
        group.add_member(user)
        s.execute(query, {"invite_code": invite.invite_code})
        s.commit()