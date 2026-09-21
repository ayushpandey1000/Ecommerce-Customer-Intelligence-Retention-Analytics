# 🛒 E-Commerce Customer Intelligence & Retention Analytics

An end-to-end **Data Analytics project** that analyzes e-commerce transactions to understand sales performance, customer behavior, product performance, geographic revenue, RFM segments, and customer retention.

## 📊 Dashboard

![Power BI Dashboard](images/dashboard.png)

## 🎯 Objectives

- Analyze revenue and order trends
- Identify high-performing products
- Identify high-value customers
- Analyze revenue by country
- Perform RFM customer segmentation
- Measure repeat-customer retention
- Build an interactive Power BI dashboard
- Generate business recommendations

## 📌 Key Results

| KPI | Result |
|---|---:|
| 💰 Total Revenue | **£10.64M** |
| 🛒 Total Orders | **19,960** |
| 👥 Unique Customers | **4,338** |
| 💵 Average Order Value | **£533.17** |
| 🔁 Repeat Customer Rate | **65.58%** |

## 🗂️ Dataset

The project uses the **Online Retail** transactional dataset from the UCI Machine Learning Repository.

**Period:** December 1, 2010 – December 9, 2011

Main fields:
- `InvoiceNo`
- `StockCode`
- `Description`
- `Quantity`
- `InvoiceDate`
- `UnitPrice`
- `CustomerID`
- `Country`

A calculated `Revenue` field was created:

`Revenue = Quantity × UnitPrice`

## 🛠️ Tech Stack

- **Python** — Data cleaning & EDA
- **Pandas / NumPy** — Data analysis
- **Matplotlib** — Visualization
- **MySQL / SQL** — Business analysis & RFM segmentation
- **Power BI** — Interactive dashboard
- **Excel / CSV** — Data handling

## 🔄 Project Workflow

```text
Raw Dataset
    ↓
Data Cleaning
    ↓
Exploratory Data Analysis
    ↓
MySQL Database
    ↓
SQL Business Analysis
    ↓
RFM Customer Segmentation
    ↓
Customer Retention Analysis
    ↓
Power BI Dashboard
    ↓
Business Insights
```

## 🧹 Data Cleaning

- Removed **5,268 duplicate records**
- Removed invalid/zero UnitPrice records
- Removed cancelled/returned transactions
- Created the Revenue column
- Retained valid transactions with missing CustomerID in the master dataset
- Excluded missing CustomerID records from customer-level analysis

**Final cleaned dataset:** 524,878 transaction records

## 📈 Key Analysis

### Sales Analysis
- Total revenue: **£10.64M**
- Total orders: **19,960**
- Average order value: **£533.17**
- November 2011 recorded the highest full-month revenue.

### Product Analysis
Top revenue-generating products included:
- REGENCY CAKESTAND 3 TIER
- PAPER CRAFT, LITTLE BIRDIE
- WHITE HANGING HEART T-LIGHT HOLDER
- PARTY BUNTING
- JUMBO BAG RED RETROSPOT

### Geographic Analysis
The **United Kingdom** was the largest revenue-generating market at approximately **£9.00M**.

## 🎯 RFM Segmentation

Customers were segmented using **Recency, Frequency, and Monetary value**.

| Segment | Customers | Revenue |
|---|---:|---:|
| Champions | 1,000 | £5.84M |
| Loyal Customer | 441 | £929.70K |
| At Risk | 659 | £844.80K |
| Recent Customers | 305 | £129.11K |
| Others | 1,933 | £1.14M |

## 🔁 Customer Retention

- Repeat Customers: **2,845**
- One-Time Customers: **1,493**
- Repeat Customer Rate: **65.58%**
- One-Time Customer Rate: **34.42%**

## 💡 Business Recommendations

- Develop loyalty programs for repeat customers
- Re-engage At Risk customers with targeted campaigns
- Provide personalized experiences for high-value customers
- Use product performance for inventory and promotional planning
- Evaluate growth opportunities in international markets
- Monitor KPIs regularly through the Power BI dashboard

## 📁 Project Structure

```text
Ecommerce_Customer_Analytics/
│
├── data/
│   ├── OnlineRetail.xlsx
│   └── OnlineRetail_Cleaned.csv
├── python/
│   └── EDA_and_Cleaning.py
├── sql/
│   └── ecommerce_analysis.sql
├── powerbi/
│   └── Ecommerce_Customer_Analytics.pbix
├── images/
│   └── dashboard.png
├── requirements.txt
└── README.md
```

## 🚀 Skills Demonstrated

- Data Cleaning
- Exploratory Data Analysis
- Python & Pandas
- SQL & MySQL
- RFM Customer Segmentation
- Customer Retention Analysis
- Power BI Dashboard Development
- Data Visualization
- Business Intelligence
- Business Recommendations

## 📌 Note

December 2011 contains data only through **December 9**, so it should not be compared directly with complete months.

---

### 👨‍💻 Project Type

**End-to-End Data Analytics Portfolio Project**

**Domain:** E-Commerce / Customer Analytics

**Tools:** Python • MySQL • SQL • Power BI • Excel
