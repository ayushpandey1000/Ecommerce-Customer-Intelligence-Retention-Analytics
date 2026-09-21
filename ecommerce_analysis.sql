-- ============================================================
-- E-COMMERCE CUSTOMER ANALYTICS
-- SQL ANALYSIS
-- Dataset: UCI Online Retail
-- ============================================================

CREATE DATABASE IF NOT EXISTS ecommerce_analytics;

USE ecommerce_analytics;


-- ============================================================
-- 1. TOTAL REVENUE
-- ============================================================

SELECT
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM online_retail;


-- ============================================================
-- 2. TOTAL ORDERS
-- ============================================================

SELECT
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail;


-- ============================================================
-- 3. UNIQUE CUSTOMERS
-- ============================================================

SELECT
    COUNT(DISTINCT CustomerID) AS unique_customers
FROM online_retail
WHERE CustomerID IS NOT NULL
  AND CustomerID != ''
  AND CustomerID != '\\N';


-- ============================================================
-- 4. AVERAGE ORDER VALUE
-- ============================================================

SELECT
    ROUND(
        SUM(Revenue) / COUNT(DISTINCT InvoiceNo),
        2
    ) AS average_order_value
FROM online_retail;


-- ============================================================
-- 5. MONTHLY REVENUE
-- ============================================================

SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS month,
    ROUND(SUM(Revenue), 2) AS monthly_revenue
FROM online_retail
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY month;


-- ============================================================
-- 6. TOP 10 PRODUCTS BY REVENUE
-- ============================================================

SELECT
    Description,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM online_retail
WHERE Description IS NOT NULL
  AND Description NOT IN (
      'DOTCOM POSTAGE',
      'POSTAGE',
      'Manual'
  )
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 7. TOP 10 PRODUCTS BY QUANTITY
-- ============================================================

SELECT
    Description,
    SUM(Quantity) AS total_quantity
FROM online_retail
WHERE Description IS NOT NULL
  AND Description NOT IN (
      'DOTCOM POSTAGE',
      'POSTAGE',
      'Manual'
  )
GROUP BY Description
ORDER BY total_quantity DESC
LIMIT 10;


-- ============================================================
-- 8. TOP 10 CUSTOMERS BY REVENUE
-- ============================================================

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM online_retail
WHERE CustomerID IS NOT NULL
  AND CustomerID != ''
  AND CustomerID != '\\N'
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 9. TOP 10 COUNTRIES BY REVENUE
-- ============================================================

SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM online_retail
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 10. RFM ANALYSIS
-- ============================================================

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,

    6 - NTILE(5) OVER (
        ORDER BY Recency ASC
    ) AS R_Score,

    6 - NTILE(5) OVER (
        ORDER BY Frequency DESC
    ) AS F_Score,

    6 - NTILE(5) OVER (
        ORDER BY Monetary DESC
    ) AS M_Score

FROM (
    SELECT
        CustomerID,

        DATEDIFF(
            (SELECT MAX(InvoiceDate) FROM online_retail),
            MAX(InvoiceDate)
        ) AS Recency,

        COUNT(DISTINCT InvoiceNo) AS Frequency,

        ROUND(SUM(Revenue), 2) AS Monetary

    FROM online_retail

    WHERE CustomerID IS NOT NULL
      AND CustomerID != ''
      AND CustomerID != '\\N'

    GROUP BY CustomerID

) AS rfm

ORDER BY Monetary DESC;


-- ============================================================
-- 11. RFM CUSTOMER SEGMENTATION
-- ============================================================

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,

    CASE

        WHEN R_Score >= 4
         AND F_Score >= 4
         AND M_Score >= 4
            THEN 'Champions'

        WHEN R_Score >= 3
         AND F_Score >= 4
            THEN 'Loyal Customer'

        WHEN R_Score >= 4
         AND F_Score <= 2
            THEN 'Recent Customers'

        WHEN R_Score <= 2
         AND F_Score >= 3
            THEN 'At Risk'

        ELSE 'Others'

    END AS Customer_Segment

FROM (

    SELECT
        CustomerID,
        Recency,
        Frequency,
        Monetary,

        6 - NTILE(5) OVER (
            ORDER BY Recency ASC
        ) AS R_Score,

        6 - NTILE(5) OVER (
            ORDER BY Frequency DESC
        ) AS F_Score,

        6 - NTILE(5) OVER (
            ORDER BY Monetary DESC
        ) AS M_Score

    FROM (

        SELECT
            CustomerID,

            DATEDIFF(
                (SELECT MAX(InvoiceDate) FROM online_retail),
                MAX(InvoiceDate)
            ) AS Recency,

            COUNT(DISTINCT InvoiceNo) AS Frequency,

            ROUND(SUM(Revenue), 2) AS Monetary

        FROM online_retail

        WHERE CustomerID IS NOT NULL
          AND CustomerID != ''
          AND CustomerID != '\\N'

        GROUP BY CustomerID

    ) AS rfm

) AS scored

ORDER BY Monetary DESC;


-- ============================================================
-- 12. CUSTOMER SEGMENT SUMMARY
-- ============================================================

SELECT
    Customer_Segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(Monetary), 2) AS total_revenue,
    ROUND(AVG(Monetary), 2) AS avg_customer_value

FROM (

    SELECT
        CustomerID,
        Monetary,

        CASE

            WHEN R_Score >= 4
             AND F_Score >= 4
             AND M_Score >= 4
                THEN 'Champions'

            WHEN R_Score >= 3
             AND F_Score >= 4
                THEN 'Loyal Customer'

            WHEN R_Score >= 4
             AND F_Score <= 2
                THEN 'Recent Customers'

            WHEN R_Score <= 2
             AND F_Score >= 3
                THEN 'At Risk'

            ELSE 'Others'

        END AS Customer_Segment

    FROM (

        SELECT
            CustomerID,
            Monetary,

            6 - NTILE(5) OVER (
                ORDER BY Recency ASC
            ) AS R_Score,

            6 - NTILE(5) OVER (
                ORDER BY Frequency DESC
            ) AS F_Score,

            6 - NTILE(5) OVER (
                ORDER BY Monetary DESC
            ) AS M_Score

        FROM (

            SELECT
                CustomerID,

                DATEDIFF(
                    (SELECT MAX(InvoiceDate) FROM online_retail),
                    MAX(InvoiceDate)
                ) AS Recency,

                COUNT(DISTINCT InvoiceNo) AS Frequency,

                ROUND(SUM(Revenue), 2) AS Monetary

            FROM online_retail

            WHERE CustomerID IS NOT NULL
              AND CustomerID != ''
              AND CustomerID != '\\N'

            GROUP BY CustomerID

        ) AS rfm

    ) AS scored

) AS segmented

GROUP BY Customer_Segment
ORDER BY total_revenue DESC;


-- ============================================================
-- 13. REPEAT VS ONE-TIME CUSTOMERS
-- ============================================================

SELECT

    CASE
        WHEN order_count = 1
            THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS Customer_Type,

    COUNT(*) AS customer_count

FROM (

    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count

    FROM online_retail

    WHERE CustomerID IS NOT NULL
      AND CustomerID != ''
      AND CustomerID != '\\N'

    GROUP BY CustomerID

) AS customer_orders

GROUP BY Customer_Type
ORDER BY customer_count DESC;


-- ============================================================
-- 14. CUSTOMER RETENTION RATE
-- ============================================================

SELECT

    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_count > 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_customer_rate

FROM (

    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count

    FROM online_retail

    WHERE CustomerID IS NOT NULL
      AND CustomerID != ''
      AND CustomerID != '\\N'

    GROUP BY CustomerID

) AS customer_orders;


-- ============================================================
-- END OF ANALYSIS
-- ============================================================