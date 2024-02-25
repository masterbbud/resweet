from typing import Any, Dict
from fastapi import APIRouter, HTTPException
from db.users import *
from .mapper import *

app = APIRouter(prefix="/api/user")

@app.post("")
async def register_user(req: Dict[Any, Any]):
    username = req["username"]
    display_name = req["display_name"]
    password = req["password"]

    if get_by_username(username) is not None:
        raise HTTPException(409, f"User {username} already exists")
    
    user = User(username, display_name, password)
    return add(user)

@app.get("")
async def get_user(id: str):
    user = get_by_uuid(id)

    if user is None:
        raise HTTPException(404, f"User {id} not found")
    
    return to_api_user(user)