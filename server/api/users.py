from typing import Any, Dict
from fastapi import APIRouter, HTTPException, Request
from db.auth import *
from db.users import *
from .mapper import *
import api.models as api
import db.models as db

app = APIRouter(prefix="/api/user")

@app.post("")
async def register_user(req: api.UserPost):
    if get_user_by_username(req.username) is not None:
        raise HTTPException(409, f"User {req.username} already exists")
    
    user = db.User(req.username, req.display_name, req.password)
    return to_api_user(add_user(user))

@app.get("")
async def get_user(req: Request):
    user = authenticate(req.headers["token"])

    if user is None:
        raise HTTPException(404, f"User {id} not found")
    
    return to_api_user(user)