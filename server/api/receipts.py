from fastapi import APIRouter, HTTPException, Request
from db.users import *
from db.groups import *
from db.receipts import *
from db.receipt_items import *
from db.auth import *
from .mapper import *
import api.models as api
import db.models as db

app = APIRouter(prefix="/api/receipt")

@app.post("")
async def create(req: api.ReceiptPost):
    items = [add_item(db.ReceiptItem(item.name, item.price)) for item in req.items]

    for i in range(len(items)):
        items[i].add_users_paid([get_user_by_uuid(user_id) for user_id in req.items[i].payer_ids]) 

    receipt = add_receipt(db.Receipt(req.name, req.date_entered, req.assignee_id))
    receipt.add_items(items)
    return to_api_receipt(receipt)

@app.get("")
async def get(req: Request):
    user = authenticate(req.headers["token"])

    if user is None: raise HTTPException(401, "Authentication failed")
    user_group_id = get_user_group(user.id).id
    return [to_api_receipt(receipt) for receipt in get_all_in_group(user_group_id)]
