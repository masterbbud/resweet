import server
from sqlalchemy.sql.expression import text

from .models import Receipt

def add(receipt: Receipt) -> Receipt:
    with server.Session() as s:
        query = text("""
            INSERT INTO receipts (name, date_entered, user_paid_id)
            VALUES (:name, :date, :assignee)
        """)

        s.execute(query, {"name": receipt.name, "date": receipt.date_entered.strftime("%Y-%m-%d"), "assignee": receipt.user_paid_id})
        s.commit()
        return receipt
    
def get_by_uuid(id: str) -> Receipt:
    with server.Session() as s:
        query = s.query(Receipt).from_statement(text("""
            SELECT * FROM receipts
            WHERE id = :id
        """))

        receipt = s.execute(query, {"id": id}).one_or_none()
        s.commit()
        return None if receipt == None else receipt[0]