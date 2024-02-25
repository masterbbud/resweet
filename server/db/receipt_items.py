import server
from sqlalchemy.sql.expression import text

from .models import ReceiptItem

def add_item(item: ReceiptItem) -> ReceiptItem:
    print(item)
    with server.Session() as s:
        query = s.query(ReceiptItem).from_statement(text("""
            INSERT INTO items (name, price)
            VALUES (:name, :price)
            RETURNING *
        """))

        item = s.execute(query, {"name": item.name, "price": item.price}).one_or_none()[0]
        s.commit()
        return item
    
def get_item_by_uuid(id: str) -> ReceiptItem:
    with server.Session() as s:
        query = s.query(ReceiptItem).from_statement(text("""
            SELECT * FROM items
            WHERE id = :id
        """))

        item = s.execute(query, {"id": id}).one_or_none()
        s.commit()
        return None if item == None else item[0]