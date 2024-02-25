from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String, UUID, Numeric, DateTime, text
from hashlib import sha256
from datetime import datetime
import uuid
import server
# from ..server import Session

Base = declarative_base()


class User(Base):
    __tablename__ = "users"
    id = Column(UUID(as_uuid=True), primary_key=True)
    username = Column(String)
    display_name = Column(String)
    pass_hash = Column(String)
    token = Column(String)

    def __init__(self, username: str, display_name: str, password: str):
        self.username = username
        self.display_name = display_name
        self.pass_hash = sha256(password.encode("utf-8")).hexdigest()
        super().__init__()


class Group(Base):
    __tablename__ = "groups"
    id = Column(UUID(as_uuid=True), primary_key=True)
    name = Column(String)

    def __init__(self, name: str):
        self.name = name
        super().__init__()

    def get_members(self) -> list[User]:
        with server.Session() as s:
            query = s.query(User).from_statement(text("""
                SELECT users.* FROM users
                INNER JOIN users_groups
                ON users.id = users_groups.user_id
                INNER JOIN groups
                ON groups.id = users_groups.group_id
                WHERE groups.id = :id
            """))

            users = s.execute(query, {"id": self.id}).all()
            users = [user for (user,) in users]
            s.commit()
            return users


class ReceiptItem(Base):
    __tablename__ = "items"
    id = Column(UUID(as_uuid=True), primary_key=True)
    name = Column(String)
    price = Column(Numeric)

    def __init__(self, name: str, price: float):
        self.name = name
        self.price = price
        super().__init__()

    def users_paid(self) -> list[User]:
        pass
        

class Receipt(Base):
    __tablename__ = "receipts"
    id = Column(UUID(as_uuid=True), primary_key=True)
    name = Column(String)
    date_entered = Column(DateTime)
    user_paid_id = Column(UUID(as_uuid=True))

    def __init__(self, name: str, date_entered: str, user_paid_id: str):
        self.name = name
        self.date_entered = datetime.strptime(date_entered, "%Y-%m-%d").date()
        self.user_paid_id = uuid.UUID(user_paid_id)
        super().__init__()