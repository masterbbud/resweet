from fastapi import APIRouter, HTTPException, Request
from db.users import *
from db.groups import *
from db.auth import *
from .mapper import *
import api.models as api
import db.models as db

app = APIRouter(prefix="/api/group")

@app.post("")
async def create(req: api.GroupPost):
    if get_group_by_name(req.name) is not None:
        raise HTTPException(409, f"Group {req.name} already exists")

    group = add_group(db.Group(req.name))
    return to_api_group(group)

@app.get("")
async def get(req: Request):
    user = authenticate(req.headers["token"])

    if user is None: raise HTTPException(401, "Authentication failed")
    return to_api_group(get_user_group(user.id))

@app.put("")
async def add_user(req: Request, body: api.GroupPut):
    user = authenticate(req.headers["token"])

    if user is None: raise HTTPException(401, "Authentication failed")
    group = get_user_group(user.id)
    group.add_member(get_user_by_username(body.username))
    return to_api_group(group)