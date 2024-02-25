from fastapi import APIRouter, HTTPException, Request
from db.groups import *
from db.auth import *
from .mapper import *

app = APIRouter(prefix="/api/ledger")

@app.get("")
async def get(req: Request):
    user = authenticate(req.headers["token"])

    if user is None: raise HTTPException(401, "Authentication failed")
    ledger = get_user_group(user.id).get_ledger()
    return [to_api_ledger_entry(entry) for entry in ledger]