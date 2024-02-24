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