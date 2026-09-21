import pandas as pd

df_clean = pd.read_excel("data/OnlineRetail_Cleaned.xlsx")

df_clean.to_csv(
    "data/OnlineRetail_Cleaned.csv",
    index=False,
    encoding="utf-8"
)

print("CSV file created successfully!")
print(df_clean.shape)