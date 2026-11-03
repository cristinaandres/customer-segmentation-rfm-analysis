# Customer Segmentation & RFM Analysis

## 📌 Project Overview
A data-driven project aimed at solving a common e-commerce problem: "The company has thousands of customers, but doesn't know how to differentiate them." Using transactional data, this project segments customers based on their purchasing behavior to help the marketing team allocate budget efficiently, retain VIPs, and reactivate at-risk customers.

## 📊 Dataset
The dataset used is the **Online Retail II** dataset from the UCI Machine Learning Repository, containing transactions from a UK-based online retail store between 2009 and 2011.

## 🛠️ Tools & Technologies
*   **SQL (SQLite via DBeaver):** Data cleaning, exploratory analysis, and RFM calculation.
*   **Power BI:** Data modeling, DAX measures, and interactive dashboard design.

## ⚙️ Methodology
1.  **Data Cleaning:** Excluded null customer IDs, negative quantities (returns/cancellations), and zero-price items.
2.  **RFM Calculation:** Calculated Recency (days since last purchase), Frequency (number of unique purchases), and Monetary (total spend) for over 5,800 unique customers.
3.  **Scoring:** Assigned a score from 1 to 5 for each metric using SQL `NTILE(5)` window functions.
4.  **Segmentation:** Grouped customers into actionable business segments based on their scores:
    *   **VIP:** Bought recently, often, and spent a lot.
    *   **At Risk:** High historical spend/frequency, but haven't bought recently.
    *   **Lost:** Low frequency and haven't bought in a long time.
    *   **New:** Recent first-time buyers.
    *   **Regular / Needs Attention:** The rest of the customer base.

## 💡 Key Insights
*   **Total Revenue Analyzed:** ~€20.9M across 5,879 active customers.
*   **VIP Concentration:** The store has **1,349 VIP customers**, who represent the most valuable segment for retention campaigns.
*   **Churn Risk:** There are **693 "At Risk" customers** who used to spend significant amounts but haven't purchased recently. They require immediate reactivation campaigns.
*   **Average Recency:** The average customer hasn't purchased in about 200 days, indicating an opportunity to increase engagement.

## 📂 Repository Structure
*   `rfm_analysis.sql`: End-to-end SQL script for cleaning and segmenting the data.
*   `rfm_segments_export.csv`: Cleaned and segmented data ready for visualization.
*   `rfm-dashboard.pdf`: PDF export of the final Power BI dashboard.

## 🖼️ Dashboard Preview
*(You can view the full dashboard in the `rfm-dashboard.pdf` file)*
*   **KPIs:** Total Revenue, Active Customers, Average Recency.
*   **Scatter Plot:** Visualizing VIPs vs. At-Risk customers (Frequency vs. Monetary).
*   **Bar Chart:** Distribution of customers across segments.
