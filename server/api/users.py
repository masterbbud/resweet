from fastapi import APIRouter, HTTPException
from db.users import *
from .mapper import *

app = APIRouter(prefix="/api/user")

@app.get("/{id}")
async def get_user(id: str):
    user = get_by_uuid(id)

    if user is None:
        raise HTTPException(404, f"User {id} not found")
    
    return to_api_user(user)