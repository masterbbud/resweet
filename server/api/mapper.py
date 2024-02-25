import db.models as db
import api.models as api

# Maps DB models to API models, if different
def to_api_user(db_user: db.User) -> api.User:
    return api.User(id=db_user.id, username=db_user.username, display_name=db_user.display_name)

def to_api_group(db_group: db.Group) -> api.Group:
    members = [to_api_user(member) for member in db_group.get_members()]
    return api.Group(id=db_group.id, name=db_group.name, members=members)