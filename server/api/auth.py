from fastapi import APIRouter, HTTPException, Request
from db.auth import *
from .models import *
from .mapper import *

app = APIRouter(prefix="/api/auth")

@app.post("")
async def login(credentials: Credentials) -> str:
    token = try_login(credentials.username, credentials.password)
    
    if token is None: raise HTTPException(401, "Login failed")
    return token

@app.delete("")
async def logout(req: Request) -> str:
    token = authenticate(req.headers["token"]).token

    if token is None: raise HTTPException(401, "Authentication failed")
    log_out(token)
    return "Logged out"