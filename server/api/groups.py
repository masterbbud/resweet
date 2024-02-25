from fastapi import APIRouter, HTTPException
from db.groups import *
from .mapper import *

app = APIRouter(prefix="/api/group")

@app.get("")
async def get_user(id: str):
    group = get_by_uuid(id)

    if group is None:
        raise HTTPException(404, f"Group {id} not found")
    
    return group