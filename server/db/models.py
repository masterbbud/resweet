from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String, UUID, DateTime, func, text
from hashlib import sha256

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