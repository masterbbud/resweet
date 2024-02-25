import db.models as db
import api.models as api
import db.users as users

# Maps DB models to API models, if different
def to_api_user(db_user: db.User) -> api.User:
    return api.User(id=db_user.id, username=db_user.username, display_name=db_user.display_name)

def to_api_group(db_group: db.Group) -> api.Group:
    members = [to_api_user(member) for member in db_group.get_members()]
    return api.Group(id=db_group.id, name=db_group.name, members=members)

def to_api_receipt_item(db_item: db.ReceiptItem) -> api.ReceiptItem:
    payers = [to_api_user(payer) for payer in db_item.get_users_paid()]
    return api.ReceiptItem(id=db_item.id, name=db_item.name, price=db_item.price, payers=payers)

def to_api_receipt(db_receipt: db.Receipt) -> api.Receipt:
    assignee = to_api_user(users.get_by_uuid(db_receipt.user_paid_id))
    items = [to_api_receipt_item(item) for item in db_receipt.get_items()]

    return api.Receipt(
        id=db_receipt.id,
        name=db_receipt.name,
        date_entered=db_receipt.date_entered.strftime("%Y-%m-%d"),
        assignee=assignee,
        items=items
        )

def to_api_ledger_entry(db_entry: db.LedgerEntry) -> api.LedgerEntry:
    user = to_api_user(users.get_by_uuid(db_entry.user_id))
    return api.LedgerEntry(user=user, balance=db_entry.balance)