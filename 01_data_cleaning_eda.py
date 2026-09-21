import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
df = pd.read_excel("data/OnlineRetail.xlsx")
# print(df.head())
# print(df.shape)
# print(df.columns)
# print(df.dtypes)
# print(df.isnull().sum())
# print(df.duplicated().sum())
# print(df.describe())
# df.info()
df_clean=df.copy()
# print(df_clean.shape)
# print("Duplicate Before:",df_clean.duplicated().sum())
df_clean=df_clean.drop_duplicates()
# print("Duplicate After:",df_clean.duplicated().sum())
# print("New Shape:",df_clean.shape)
# print("Missing CustomrerID:",df_clean["CustomerID"].isnull().sum())
# print("Missing CustomerID %",round(df_clean["CustomerID"].isnull().mean()*100,2))
missing_customer = df_clean[df_clean["CustomerID"].isnull()]
# print("Rows with missing CustomerID:", len(missing_customer))
# print(missing_customer.head())
# print("Not Missing",df_clean["CustomerID"].notnull().sum())
# print("Missing",df_clean["CustomerID"].isnull().sum())
# print(df_clean.groupby(df_clean["CustomerID"].isnull())["Quantity"].sum())
df_clean["Revenue"] = df_clean["Quantity"] * df_clean["UnitPrice"]
# print(
#     df_clean.groupby(df_clean["CustomerID"].isnull())["Revenue"].sum()
# )
# print("Negative",(df_clean['UnitPrice'] < 0).sum())
# print("Positive",(df_clean['UnitPrice'] == 0).sum())
# print((df_clean['UnitPrice'] < 0).head())
negative_price=df_clean[df_clean['UnitPrice'] < 0]
# print(negative_price)
df_clean = df_clean[df_clean["UnitPrice"] >= 0]
# print("Negative UnitPrice after cleaning:",
#       (df_clean["UnitPrice"] < 0).sum())
# print("New shape:", df_clean.shape)
zero_price=df_clean[df_clean['UnitPrice'] == 0]
# print(len(zero_price))
# print(zero_price['Description'].value_counts().head(10))
# print(zero_price.head(10))
df_clean = df_clean[df_clean["UnitPrice"] > 0]
# print("Zero UnitPrice after cleaning:",
#       (df_clean["UnitPrice"] == 0).sum())
# print("New shape:", df_clean.shape)
negative_qty=df_clean[df_clean["Quantity"] < 0]
# print(len(negative_qty))
# print(negative_qty["InvoiceNo"].astype(str).str.startswith("C").sum())
# print(negative_qty["Revenue"].sum())
df_clean = df_clean[df_clean["Quantity"] > 0]
# print("Negative Quantity after cleaning:",
#       (df_clean["Quantity"] < 0).sum())
# print("New shape:", df_clean.shape)


# print("Final shape:", df_clean.shape)

# print("\nMissing values:")
# print(df_clean.isnull().sum())

# print("\nDuplicate rows:", df_clean.duplicated().sum())

# print("\nNegative Quantity:", (df_clean["Quantity"] < 0).sum())

# print("Negative UnitPrice:", (df_clean["UnitPrice"] < 0).sum())

# print("Zero UnitPrice:", (df_clean["UnitPrice"] == 0).sum())

# print("\nRevenue check:")
# print(df_clean["Revenue"].describe())


# df_clean.to_excel(
#     "Ecommerce_Customer_Analytics/data/OnlineRetail_Cleaned.xlsx",
#     index=False
# )

df_clean.to_csv(
    "data/OnlineRetail_Cleaned.csv",
    index=False,
    encoding="utf-8",
    na_rep="\\N"
)
print("MySQL-ready CSV created!")
print("Final shape:", df_clean.shape)

# print("Cleaned dataset saved successfully!")
# df_clean = pd.read_excel("data/OnlineRetail_Cleaned.xlsx")
total_revenue = df_clean["Revenue"].sum()
# print("Total Revenue:", total_revenue)
total_orders=df_clean['InvoiceNo'].nunique()
# print("Total Orders:",total_orders)
total_customers=df_clean['CustomerID'].nunique()
# print("Total Customers",total_customers)
aov=total_revenue/total_orders
# print("Average Order Value",aov)
df_clean['Month']=df_clean['InvoiceDate'].dt.to_period("M")
monthly_revenue=df_clean.groupby("Month")["Revenue"].sum()
# print(monthly_revenue)
# monthly_revenue.plot(kind="line",marker="o",figsize=(10,5))
# plt.xlabel("Month")
# plt.ylabel("Revenue")
# plt.title("Revenue By Month")
# plt.grid(True)
# plt.show()

# top_products=(
#     df_clean.groupby("Description")["Revenue"].sum().sort_values(ascending=False).head(10)
# )
# print(top_products)
product_data=df_clean[
    ~df_clean["Description"].str.upper().isin( ["DOTCOM POSTAGE", "POSTAGE", "MANUAL"])
]

top_products = (
    product_data.groupby("Description")["Revenue"].sum().sort_values(ascending=False).head(10)
)
# print(top_products)
top_quantity = (
    product_data.groupby("Description")["Quantity"].sum().sort_values(ascending=False).head(10)
)
# print(top_quantity)
# top_quantity.sort_values().plot(
#     kind="barh",figsize=(10,6)
#     )
# plt.title("Top 10 Product By Qunatity Sold")
# plt.xlabel("Quantity Sold")
# plt.ylabel("Product")
# plt.show()

customer_revenue=(
    df_clean.dropna(subset=["CustomerID"]).groupby("CustomerID")["Revenue"].sum().sort_values(ascending=False).head(10)    
)
# print(customer_revenue)
# customer_revenue.sort_values().plot(
#     kind="barh",
#     figsize=(10, 6)
# )
# plt.title("Top 10 Customers by Revenue")
# plt.xlabel("Revenue (£)")
# plt.ylabel("Customer ID")
# plt.show()

country_revenue=(
    df_clean.groupby("Country")["Revenue"].sum().sort_values(ascending=False).head(10))
# print(country_revenue)

# country_revenue.sort_values().plot(
#     kind="barh",
#     figsize=(10, 6)
# )

# plt.title("Top 10 Countries by Revenue")
# plt.xlabel("Revenue (£)")
# plt.ylabel("Country")

# plt.show()


# print("Total Revenue: £", round(total_revenue, 2))
# print("Total Orders:", total_orders)
# print("Unique Customers:", total_customers)
# print("Average Order Value: £", round(aov, 2))
# print("\nTop Product by Revenue:")
# print(top_products.index[0], "-> £", round(top_products.iloc[0], 2))
# print("\nTop Product by Quantity:")
# print(top_quantity.index[0], "->", top_quantity.iloc[0], "units")
# print("\nTop Customer by Revenue:")
# print(customer_revenue.index[0], "-> £", round(customer_revenue.iloc[0], 2))
# print("\nTop Country by Revenue:")
# print(country_revenue.index[0], "-> £", round(country_revenue.iloc[0], 2))

