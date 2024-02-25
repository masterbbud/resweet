from fastapi import APIRouter, HTTPException, Request
from db.groups import *
from db.auth import *
from .mapper import *

app = APIRouter(prefix="/api/group")

@app.get("")
async def get(req: Request):
    user = authenticate(req.headers["token"])

    if user is None: raise HTTPException(401, "Authentication failed")
    return to_api_group(get_user_group(user.id))