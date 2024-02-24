import db.models as db
import api.models as api

# Maps DB models to API models, if different
def to_api_user(db_user : db.User) -> api.User:
    return api.User(id=db_user.id, username=db_user.username, display_name=db_user.display_name)