import pandas as pd
import mysql.connector
df = pd.read_csv("data/OnlineRetail_Cleaned.csv")
conn=mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="ecommerce_analytics"
)
cursor=conn.cursor()
sql = """
INSERT INTO online_retail
(InvoiceNo, StockCode, Description, Quantity, InvoiceDate,
 UnitPrice, CustomerID, Country, Revenue)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
"""
df=df.where(pd.notnull(df),None)
batch_size=5000

for start in range(0,len(df),batch_size):
    batch=df.iloc[start:start+batch_size]
    data=[
        tuple(row)
        for row in batch.itertuples(index=False,name=None)

    ]
    cursor.executemany(sql,data)
    conn.commit()
    print(f"Imported {min(start + batch_size, len(df))} / {len(df)} rows")
cursor.close()
conn.close()    
print("Import Complete Successfull")