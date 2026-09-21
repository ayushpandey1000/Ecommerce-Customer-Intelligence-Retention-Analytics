import mysql.connector
conn=mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="ecommerce_analytics",

)
if conn.is_connected():
    print("MySQL Connection Succesfull")
conn.close()    