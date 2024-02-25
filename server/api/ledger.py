from fastapi import APIRouter, HTTPException, Request
from db.receipts import *
from db.auth import *
from .mapper import *

app = APIRouter(prefix="/api/ledger")

@app.get("")
async def get(req: Request):
    user = authenticate(req.headers["token"])

    if user is None: raise HTTPException(401, "Authentication failed")
    