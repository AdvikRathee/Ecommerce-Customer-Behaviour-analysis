-- ============================================
-- E-Commerce Customer Behavior Analysis
-- Author: Advik Rathee
-- Tools: SQL, Python, Power BI
-- ============================================


-- ============================================
-- 1. DATA EXPLORATION
-- ============================================

-- View first 10 rows
SELECT TOP 10 * FROM ecommerce;

-- Total records
SELECT COUNT(*) AS total_records FROM ecommerce;

-- Check for nulls in CustomerID
SELECT COUNT(*) AS null_customers 
FROM ecommerce 
WHERE CustomerID IS NULL;

-- Unique customers
SELECT COUNT(DISTINCT CustomerID) AS unique_customers 
FROM ecommerce;

-- Unique countries
SELECT COUNT(DISTINCT Country) AS unique_countries 
FROM ecommerce;

-- Date range of data
SELECT 
    MIN(InvoiceDate) AS start_date,
    MAX(InvoiceDate) AS end_date
FROM ecommerce;


-- ============================================
-- 2. DATA CLEANING
-- ============================================

-- Remove cancelled orders (InvoiceNo starting with C)
-- Remove null CustomerIDs
-- Remove negative quantities and prices
SELECT *
INTO cleaned_ecommerce
FROM ecommerce
WHERE 
    CustomerID IS NOT NULL
    AND Quantity > 0
    AND UnitPrice > 0
    AND InvoiceNo NOT LIKE 'C%';

-- Add TotalPrice column
ALTER TABLE cleaned_ecommerce 
ADD TotalPrice AS (Quantity * UnitPrice);

-- Verify cleaned data
SELECT COUNT(*) AS cleaned_records FROM cleaned_ecommerce;


-- ============================================
-- 3. REVENUE ANALYSIS
-- ============================================

-- Total Revenue
SELECT 
    ROUND(SUM(TotalPrice), 2) AS total_revenue
FROM cleaned_ecommerce;

-- Monthly Revenue Trend
SELECT 
    FORMAT(InvoiceDate, 'yyyy-MM') AS month,
    ROUND(SUM(TotalPrice), 2) AS monthly_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM cleaned_ecommerce
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY month;

-- Top 10 Countries by Revenue (excluding UK)
SELECT TOP 10
    Country,
    ROUND(SUM(TotalPrice), 2) AS total_revenue,
    COUNT(DISTINCT CustomerID) AS customers
FROM cleaned_ecommerce
WHERE Country != 'United Kingdom'
GROUP BY Country
ORDER BY total_revenue DESC;

-- Top 10 Best Selling Products
SELECT TOP 10
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(TotalPrice), 2) AS total_revenue
FROM cleaned_ecommerce
GROUP BY Description
ORDER BY total_quantity_sold DESC;


-- ============================================
-- 4. CUSTOMER ANALYSIS
-- ============================================

-- Total unique customers
SELECT COUNT(DISTINCT CustomerID) AS total_customers 
FROM cleaned_ecommerce;

-- Average Order Value
SELECT 
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT 
        InvoiceNo,
        SUM(TotalPrice) AS order_total
    FROM cleaned_ecommerce
    GROUP BY InvoiceNo
) AS orders;

-- Customer Purchase Frequency
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(TotalPrice), 2) AS total_spent
FROM cleaned_ecommerce
GROUP BY CustomerID
ORDER BY total_spent DESC;


-- ============================================
-- 5. RFM ANALYSIS
-- ============================================

-- RFM Calculation
-- Recency = Days since last purchase
-- Frequency = Number of orders
-- Monetary = Total amount spent

DECLARE @snapshot_date DATE = '2011-12-10';

SELECT 
    CustomerID,
    DATEDIFF(DAY, MAX(InvoiceDate), @snapshot_date) AS Recency,
    COUNT(DISTINCT InvoiceNo) AS Frequency,
    ROUND(SUM(TotalPrice), 2) AS Monetary
INTO rfm_table
FROM cleaned_ecommerce
GROUP BY CustomerID
ORDER BY Monetary DESC;

-- View RFM table
SELECT * FROM rfm_table;

-- RFM Summary Stats
SELECT 
    AVG(Recency) AS avg_recency,
    AVG(Frequency) AS avg_frequency,
    ROUND(AVG(Monetary), 2) AS avg_monetary,
    MIN(Recency) AS min_recency,
    MAX(Recency) AS max_recency
FROM rfm_table;


-- ============================================
-- 6. CHURN ANALYSIS
-- ============================================

-- Customers who haven't purchased in 90+ days = Churned
SELECT 
    COUNT(*) AS churned_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rfm_table), 2) AS churn_rate_percent
FROM rfm_table
WHERE Recency > 90;

-- Active vs Churned customers
SELECT 
    CASE 
        WHEN Recency <= 90 THEN 'Active'
        ELSE 'Churned'
    END AS customer_status,
    COUNT(*) AS customer_count,
    ROUND(AVG(Monetary), 2) AS avg_revenue
FROM rfm_table
GROUP BY 
    CASE 
        WHEN Recency <= 90 THEN 'Active'
        ELSE 'Churned'
    END;

-- 30-Day Retention Rate
SELECT 
    ROUND(
        COUNT(CASE WHEN Recency <= 30 THEN 1 END) * 100.0 / COUNT(*), 
        2
    ) AS retention_rate_30_days
FROM rfm_table;


-- ============================================
-- 7. COHORT ANALYSIS
-- ============================================

-- Get first purchase month for each customer
SELECT 
    CustomerID,
    FORMAT(MIN(InvoiceDate), 'yyyy-MM') AS cohort_month
INTO customer_cohorts
FROM cleaned_ecommerce
GROUP BY CustomerID;

-- Monthly Cohort Retention
SELECT 
    c.cohort_month,
    FORMAT(e.InvoiceDate, 'yyyy-MM') AS purchase_month,
    COUNT(DISTINCT e.CustomerID) AS active_customers
FROM cleaned_ecommerce e
JOIN customer_cohorts c ON e.CustomerID = c.CustomerID
GROUP BY c.cohort_month, FORMAT(e.InvoiceDate, 'yyyy-MM')
ORDER BY c.cohort_month, purchase_month;


-- ============================================
-- 8. CONVERSION FUNNEL (Simulated)
-- ============================================

-- Funnel stages based on customer behavior
SELECT 
    'Site Visits' AS stage, COUNT(DISTINCT CustomerID) * 12 AS customers FROM cleaned_ecommerce
UNION ALL
SELECT 
    'Product Views', COUNT(DISTINCT CustomerID) * 8 FROM cleaned_ecommerce
UNION ALL
SELECT 
    'Add to Cart', COUNT(DISTINCT CustomerID) * 5 FROM cleaned_ecommerce
UNION ALL
SELECT 
    'Checkout', COUNT(DISTINCT CustomerID) * 2 FROM cleaned_ecommerce
UNION ALL
SELECT 
    'Purchase', COUNT(DISTINCT CustomerID) FROM cleaned_ecommerce;


-- ============================================
-- KEY BUSINESS INSIGHTS
-- ============================================
-- 1. Only 20% of new customers return after 30 days
-- 2. Champions segment (top 28%) drives 61% of revenue  
-- 3. UK dominates revenue - international expansion opportunity
-- 4. November peak - seasonal campaign works well
-- 5. At Risk segment needs re-engagement campaign
-- ============================================
