from pydantic import BaseModel
from uuid import UUID

class User(BaseModel):
    id: UUID
    username: str
    display_name: str

class Group(BaseModel):
    id: UUID
    name: str
    members: list[User]

class ReceiptItem(BaseModel):
    id: UUID
    name: str
    price: float
    payers: list[User]

class Receipt(BaseModel):
    id: UUID
    name: str
    date_entered: str
    assignee: User
    items: list[ReceiptItem]

class LedgerEntry(BaseModel):
    user: User
    balance: float


# classes that represent POST request bodies
    
class Credentials(BaseModel):
    username: str
    password: str

class UserPost(BaseModel):
    username: str
    display_name: str
    password: str

class ReceiptItemPost(BaseModel):
    name: str
    price: float
    payer_ids: list[str]

class ReceiptPost(BaseModel):
    name: str
    date_entered: str
    assignee_id: str
    items: list[ReceiptItemPost]

class GroupPost(BaseModel):
    name: str

class InvitePost(BaseModel):
    group_id: str


# classes that represent PUT request bodies
class GroupPut(BaseModel):
    username: str