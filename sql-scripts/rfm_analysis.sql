/*
Project: Customer Segmentation with RFM Analysis
Dataset: Online Retail II (UCI)
Author: Cristina Andres
Description: End-to-end SQL script to clean data, calculate RFM metrics, 
and segment customers for marketing actions.
*/

-- ==============================================================================
-- 1. DATA EXPLORATION & CLEANING
-- ==============================================================================

-- 1.1 Check original row count (Optional, just for reference)
-- SELECT COUNT(*) FROM online_retail_II;

-- 1.2 Clean data: Remove nulls, returns, and free items
-- We expect the row count to drop significantly here.

-- SELECT COUNT(*) AS total_valid_rows
-- FROM online_retail_II 
-- WHERE 
--     "Customer ID" IS NOT NULL  
--     AND Quantity > 0           
--     AND Price > 0;
-- (Result: 1,041,671 valid rows)


-- ==============================================================================
-- 2. CALCULATE RAW RFM METRICS
-- ==============================================================================

WITH MaxDatasetDate AS (
    -- Get the most recent date in the dataset to use as a reference for Recency
    SELECT MAX(InvoiceDate) AS max_date 
    FROM online_retail_II
),
RFM_Raw AS (
    SELECT 
        "Customer ID" AS customer_id,
        -- Recency: Days between the last purchase of the customer and the max date of the dataset
        CAST(julianday((SELECT max_date FROM MaxDatasetDate)) - julianday(MAX(InvoiceDate)) AS INTEGER) AS recency_days,
        -- Frequency: Number of unique invoices per customer
        COUNT(DISTINCT Invoice) AS frequency,
        -- Monetary: Total money spent (Quantity * Price)
        ROUND(SUM(Quantity * Price), 2) AS monetary_value
    FROM online_retail_II
    WHERE 
        "Customer ID" IS NOT NULL 
        AND Quantity > 0 
        AND Price > 0
    GROUP BY "Customer ID"
),

-- ==============================================================================
-- 3. ASSIGN RFM SCORES (1 to 5)
-- ==============================================================================

RFM_Scores AS (
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary_value,
        -- Recency: Lower days = better score (5)
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        -- Frequency: Higher = better score (5)
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        -- Monetary: Higher = better score (5)
        NTILE(5) OVER (ORDER BY monetary_value ASC) AS m_score
    FROM RFM_Raw
)

-- ==============================================================================
-- 4. FINAL SEGMENTATION
-- ==============================================================================

SELECT 
    customer_id,
    recency_days,
    frequency,
    monetary_value,
    r_score,
    f_score,
    m_score,
    CASE 
        -- VIP: Bought recently, often, and spent a lot
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'VIP'
        
        -- At Risk: Used to buy often and spent a lot, but haven't bought recently
        WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'At Risk'
        
        -- Lost: Haven't bought in a long time and low frequency
        WHEN r_score = 1 AND f_score <= 2 THEN 'Lost'
        
        -- New/Promising: Bought very recently, but only once
        WHEN r_score >= 4 AND f_score = 1 THEN 'New'
        
        -- Everyone else
        ELSE 'Regular / Needs Attention'
    END AS customer_segment
FROM RFM_Scores
ORDER BY monetary_value DESC;