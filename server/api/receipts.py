from fastapi import APIRouter, HTTPException, Request
from db.groups import *
from db.receipts import *
from db.auth import *
from .mapper import *

app = APIRouter(prefix="/api/receipt")

@app.get("")
async def get(req: Request):
    user = authenticate(req.headers["token"])

    if user is None: raise HTTPException(401, "Authentication failed")
    user_group_id = get_user_group(user.id).id
    return [to_api_receipt(receipt) for receipt in get_all_in_group(user_group_id)]
 