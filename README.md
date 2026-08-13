# 🛍️ Retail Sales SQL Analysis

A MySQL-based retail sales analysis project focused on data cleaning, sales performance, customer behavior, time-based trends, and profitability.

## 📌 Project Overview

This project analyzes **2,000 raw retail transactions** using MySQL.

The dataset contains transaction dates, customer information, product categories, quantities, prices, cost of goods sold (COGS), and total sales.

**Workflow:** Raw Data → Data Cleaning → Data Validation → Business Analysis → Insights

After identifying and excluding **3 transactions with missing core sales fields**, the final analysis contains **1,997 valid transactions**. The 10 missing age values were retained because age is not required for revenue or profitability calculations.

## 🎯 Business Objectives

- Identify the highest-revenue product categories
- Analyze customer purchasing behavior
- Find high-value customers
- Analyze monthly sales trends
- Compare transaction performance by gender and category
- Identify the strongest time-of-day period
- Calculate category revenue contribution and gross profit

## 🗂️ Dataset

| Metric | Value |
|---|---:|
| Raw Transactions | 2,000 |
| Valid Transactions | 1,997 |
| Unique Customers | 155 |
| Categories | 3 |
| Time Period | 2022–2023 |
| Missing Age Values | 10 |

**Categories:** Electronics, Clothing, Beauty

### Data Cleaning

Three transactions were excluded because they were missing core sales fields: quantity, price per unit, COGS, and total sale. These values could not be reliably imputed.

The 10 missing age values were retained as NULL because age is not required for the financial calculations in this project.

## 🛠️ Tools & SQL Skills

**Database:** MySQL

**SQL techniques:**

- Data cleaning and validation
- Filtering and aggregation
- GROUP BY, ORDER BY and LIMIT
- CASE statements
- CTEs
- Subqueries
- Window functions
- RANK() and PARTITION BY
- Date and time functions
- Revenue and gross-profit analysis

## 🔍 Analysis Performed

The project contains **13 business analysis questions**, covering date-based analysis, category performance, customer demographics, high-value transactions, gender analysis, monthly trends, top customers, customer-category analysis, time-of-day analysis, revenue contribution, and gross profit.

## 📊 Key Insights

### Category Performance

| Category | Transactions | Quantity Sold | Revenue |
|---|---:|---:|---:|
| Electronics | 684 | 1,698 | 313,810 |
| Clothing | 701 | 1,785 | 311,070 |
| Beauty | 612 | 1,535 | 286,840 |

**Electronics generated the highest revenue**, while Clothing recorded the highest transaction volume and quantity sold.

### Best Performing Month

Using a CTE and `RANK()` window function:

- **2022:** July — average transaction value **541.34**
- **2023:** February — average transaction value **535.53**

### Top Customer

Customer **3** was the highest-spending customer with **76 transactions** and total spending of **38,440**.

### Time-of-Day Analysis

| Shift | Transactions | Revenue | Avg. Transaction Value |
|---|---:|---:|---:|
| Evening | 1,062 | 475,940 | 448.15 |
| Morning | 558 | 259,900 | 465.77 |
| Afternoon | 377 | 175,880 | 466.53 |

**Evening generated the highest transaction volume and revenue**, while Afternoon had the highest average transaction value.

## 💡 Business Recommendations

- Prioritize inventory and promotional strategies for **Electronics**, the highest-revenue category.
- Investigate opportunities to improve **Beauty** category revenue.
- Consider targeted retention strategies for high-value customers.
- Ensure sufficient operational capacity during the **Evening**, when transaction volume is highest.
- Study high-value Morning and Afternoon transactions to identify opportunities to increase average transaction value.
- Use monthly sales patterns to support inventory and promotional planning.

## 📸 Analysis Screenshots

### Category Performance

![Category Analysis](screenshots/category-analysis.png)

### Best Performing Month

![Best Performing Month](screenshots/best-performing-month.png)

### Top 5 Customers

![Top 5 Customers](screenshots/top-5-customers.png)

### Time-of-Day Analysis

![Shift Analysis](screenshots/shift-analysis.png)

## 📁 Repository Structure

```text
retail-sales-sql-analysis/
│
├── README.md
├── data/
│   └── retail_sales_data.csv
├── sql/
│   └── retail_sales_analysis.sql
└── screenshots/
    ├── category-analysis.png
    ├── best-performing-month.png
    ├── top-5-customers.png
    └── shift-analysis.png
```

## 🚀 Key Takeaway

This project demonstrates how SQL can move from **raw transactional data to validated data, business analysis, and actionable insights**, with practical use of CTEs, window functions, subqueries, aggregations, CASE statements, and date/time analysis.

## 👤 Author

**Rajan Kumar**  
Data Analyst | SQL | Power BI | Excel | Python

Open to Data Analyst, Business Analyst, and BI Analyst opportunities.
