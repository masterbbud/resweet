from fastapi import APIRouter, HTTPException
from db.auth import *
from .models import *
from .mapper import *

app = APIRouter(prefix="/api/auth")

@app.post("")
async def login(credentials: Credentials) -> str:
    token = try_login(credentials.username, credentials.password)
    
    if token is None: raise HTTPException(401, "Login failed")
    return token