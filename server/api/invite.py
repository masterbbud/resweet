from fastapi import APIRouter, HTTPException, Request
from db.invite import *
from db.groups import *
from db.auth import *
from .mapper import *
import api.models as api
import db.models as db

app = APIRouter(prefix="/invite")

@app.post("")
async def create(req: api.InvitePost):
    create_invite(get_group_by_uuid(req.group_id))

@app.get("/{invite_code}")
async def accept(invite_code: str, req: Request):
    user = authenticate(req.headers["token"])

    if user is None: raise HTTPException(401, "Authentication failed")

    invite = get_invite(invite_code)

    if invite is None:
        raise HTTPException(401, "Invite has already been used or does not exist")
    
    accept_invite(invite, user)