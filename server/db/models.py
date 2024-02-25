from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String, UUID, Numeric, DateTime, text
from hashlib import sha256
from datetime import datetime
import uuid
import server

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


class LedgerEntry():
    user_id : uuid.UUID
    balance : float

    def __init__(self, user_id: str, balance: float):
        self.user_id = uuid.UUID(user_id)
        self.balance = balance


class Group(Base):
    __tablename__ = "groups"
    id = Column(UUID(as_uuid=True), primary_key=True)
    name = Column(String)

    def __init__(self, name: str):
        self.name = name
        super().__init__()

    def add_member(self, user: User):
        with server.Session() as s:
            query = text("""
                INSERT INTO users_groups (user_id, group_id)
                VALUES (:user_id, :group_id)
            """)

            s.execute(query, {"user_id": user.id, "group_id": self.id})
            s.commit()


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
        
    def get_ledger(self) -> list[LedgerEntry]:
        with server.Session() as s:
            query = text("""DROP VIEW totals""")
            s.execute(query)
            s.commit()

            query = text("""
                CREATE VIEW totals AS
                SELECT
                    receipts_items.receipt_id AS receipt_id,
                    SUM(items.price) AS total
                FROM receipts_items
                INNER JOIN items
                ON receipts_items.item_id = items.id
                GROUP BY receipts_items.receipt_id
            """)
            s.execute(query)
            s.commit()

            # i will not be able to tell you how this works after i've gone to sleep...it does work though :)
            # dan, 2/25/2024 3:13 am
            query = text("""
                SELECT
                    users_groups.user_id,
                    COALESCE(amount_spent, 0) + COALESCE(paid, 0) AS balance
                FROM (
                    SELECT
                    DISTINCT ON (user_amounts_spent.user_id)
                        user_amounts_spent.user_id,
                        CASE
                            WHEN(user_amounts_spent.amount_spent IS NULL) THEN 0
                            ELSE ROUND(user_amounts_spent.amount_spent, 2)
                        END AS amount_spent,
                        CASE
                            WHEN(receipts.user_paid_id = user_amounts_spent.user_id) THEN totals.total
                            ELSE 0
                        END AS paid
                    FROM (
                        SELECT
                            users.id AS user_id,
                            SUM(-user_paid_counts.item_price / user_paid_counts.user_count) AS amount_spent
                        FROM (
                            SELECT
                                items.id AS item_id,
                                items.name AS item_name,
                                items.price AS item_price,
                                COUNT(items_users.user_paid_id) AS user_count
                            FROM items
                            INNER JOIN items_users
                            ON items_users.item_id = items.id
                            INNER JOIN users_groups
                            ON items_users.user_paid_id = users_groups.user_id
                            WHERE users_groups.group_id = :id
                            GROUP BY items.id
                        ) AS user_paid_counts

                        INNER JOIN items_users
                        ON user_paid_counts.item_id = items_users.item_id
                        RIGHT JOIN users
                        ON items_users.user_paid_id = users.id
                        INNER JOIN users_groups
                        ON users_groups.user_id = users.id
                        WHERE users_groups.group_id = :id
                        GROUP BY users.id, users.display_name
                    ) AS user_amounts_spent

                    RIGHT JOIN items_users
                    ON user_id = items_users.user_paid_id
                    INNER JOIN users_groups
                    ON users_groups.user_id = items_users.user_paid_id
                    INNER JOIN receipts_items
                    ON items_users.item_id = receipts_items.item_id
                    INNER JOIN receipts
                    ON receipts_items.receipt_id = receipts.id
                    INNER JOIN totals
                    ON receipts.id = totals.receipt_id
                    WHERE users_groups.group_id = :id
                    ORDER BY user_amounts_spent.user_id ASC, paid DESC
                ) AS amounts_spent_with_paid
                RIGHT JOIN users_groups
                ON users_groups.user_id = amounts_spent_with_paid.user_id
                WHERE users_groups.group_id = :id
                ORDER BY users_groups.group_id ASC;
            """)

            entries = s.execute(query, {"id": self.id}).all()
            entries = [LedgerEntry(str(id), balance) for (id, balance) in entries]
            s.commit()
            return entries


class ReceiptItem(Base):
    __tablename__ = "items"
    id = Column(UUID(as_uuid=True), primary_key=True)
    name = Column(String)
    price = Column(Numeric)

    def __init__(self, name: str, price: float):
        self.name = name
        self.price = price
        super().__init__()

    def add_users_paid(self, users: list[User]):
        with server.Session() as s:
            for user in users:
                print(user.username)
                query = text("""
                    INSERT INTO items_users (item_id, user_paid_id)
                    VALUES (:item_id, :user_id)
                """)

                s.execute(query, {"item_id": self.id, "user_id": user.id})
                s.commit()

    def get_users_paid(self) -> list[User]:
        with server.Session() as s:
            query = s.query(User).from_statement(text("""
            SELECT users.* FROM users
            INNER JOIN items_users
            ON users.id = items_users.user_paid_id
            WHERE items_users.item_id = :id
            """))

            users = s.execute(query, {"id": self.id}).all()
            users = [user for (user,) in users]
            s.commit()
            return users
        

class Receipt(Base):
    __tablename__ = "receipts"
    id = Column(UUID(as_uuid=True), primary_key=True)
    name = Column(String)
    date_entered = Column(DateTime)
    user_paid_id = Column(UUID(as_uuid=True))

    def __init__(self, name: str, date_entered: str, user_paid_id: str):
        self.name = name
        self.date_entered = datetime.strptime(date_entered, "%Y-%m-%d").date()
        self.user_paid_id = user_paid_id
        super().__init__()

    def add_items(self, items: list[ReceiptItem]) -> None:
        for item in items:
            with server.Session() as s:
                query = text("""
                    INSERT INTO receipts_items (receipt_id, item_id)
                    VALUES (:receipt_id, :item_id)
                """)

                s.execute(query, {"receipt_id": self.id, "item_id": item.id})
                s.commit()

    def get_items(self) -> list[ReceiptItem]:
        with server.Session() as s:
            query = s.query(ReceiptItem).from_statement(text("""
                SELECT items.* FROM items
                INNER JOIN receipts_items
                ON items.id = receipts_items.item_id
                WHERE receipts_items.receipt_id = :id
            """))

            items = s.execute(query, {"id": self.id}).all()
            items = [item for (item,) in items]
            s.commit()
            return items
        

class Invite(Base):
    __tablename__ = "invites"
    id = Column(Numeric, primary_key=True)
    group_id = Column(UUID(as_uuid=True))
    invite_code = Column(String)

    def __init__(self, group_id: str, invite_code: str):
        self.group_id = group_id
        self.invite_code = invite_code
        super().__init__()