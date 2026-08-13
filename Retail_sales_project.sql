CREATE DATABASE IF NOT EXISTS Retail_sales;
USE Retail_sales;

-- Staging table: mirrors the raw CSV with no constraints, so every row (including incomplete ones) can be loaded and inspected before cleaning.
CREATE TABLE retail_sales_staging (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);
 
 
-- Final table: constraints reflect the columns every retained row must have.

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL,
    customer_id INT NOT NULL,
    gender VARCHAR(15) NOT NULL,
    age INT NULL,
    category VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10,2) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    total_sale DECIMAL(10,2) NOT NULL
);
 
-- 1. DATA CLEANING

-- Identify incomplete transactions in the raw staged data

SELECT *
FROM retail_sales_staging
WHERE quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
 
-- Decision: these 3 transactions (IDs 679, 746, 1225) have no usable sales
-- figures and cannot be reasonably imputed, so they are excluded from analysis.
-- Age is left nullable by design (10 rows) since it does not affect revenue.

INSERT INTO retail_sales
SELECT *
FROM retail_sales_staging
WHERE quantity IS NOT NULL
  AND price_per_unit IS NOT NULL
  AND cogs IS NOT NULL
  AND total_sale IS NOT NULL;
 
-- Staging table is no longer needed once the clean data has been moved over.
DROP TABLE retail_sales_staging;

-- 2. DATA VALIDATION & DATA QUALITY CHECKS

-- Total number of records
SELECT COUNT(*) AS total_records
FROM retail_sales;

-- Validate that total sales equals quantity × price per unit
SELECT *
FROM retail_sales
WHERE ABS(total_sale - (quantity * price_per_unit)) > 0.01;

-- Check available categories
SELECT DISTINCT category
FROM retail_sales
ORDER BY category;

-- Check date range
SELECT
    MIN(sale_date) AS first_sale_date,
    MAX(sale_date) AS last_sale_date
FROM retail_sales;

-- 3. DATA EXPLORATION

-- Total number of transactions
SELECT COUNT(*) AS total_transactions
FROM retail_sales;

-- Total unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales;

-- Number of unique categories
SELECT COUNT(DISTINCT category) AS unique_categories
FROM retail_sales;

-- Total revenue
SELECT ROUND(SUM(total_sale), 2) AS total_revenue
FROM retail_sales;

-- Total quantity sold
SELECT SUM(quantity) AS total_quantity_sold
FROM retail_sales;

-- Total cost of goods sold
SELECT ROUND(SUM(cogs), 2) AS total_cogs
FROM retail_sales;

-- Gross profit
SELECT
    ROUND(SUM(total_sale - cogs), 2) AS gross_profit
FROM retail_sales;

-- 4. BUSINESS ANALYSIS

-- Q1. Retrieve all transactions made on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Find Clothing transactions with quantity greater than 4 during November 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01'
  AND quantity > 4;

-- Q3. Calculate total sales and transaction count by category
SELECT
    category,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(total_sale), 2) AS total_revenue,
    ROUND(AVG(total_sale), 2) AS average_transaction_value
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4. Find the average customer age for Beauty purchases
SELECT
    ROUND(AVG(age), 2) AS average_customer_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. Find transactions with sales above 1,000
SELECT *
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;

-- Q6. Count transactions by gender and category
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions,
    ROUND(SUM(total_sale), 2) AS total_revenue
FROM retail_sales
GROUP BY category, gender
ORDER BY category, total_revenue DESC;

-- Q7. Find the best-performing month by average transaction value for each year using a window function
WITH monthly_sales AS (
    SELECT
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        ROUND(AVG(total_sale), 2) AS average_transaction_value
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),
ranked_months AS (
    SELECT
        sale_year,
        sale_month,
        average_transaction_value,
        RANK() OVER (
            PARTITION BY sale_year
            ORDER BY average_transaction_value DESC
        ) AS month_rank
    FROM monthly_sales
)
SELECT
    sale_year,
    sale_month,
    average_transaction_value
FROM ranked_months
WHERE month_rank = 1
ORDER BY sale_year;

-- Q8. Find the top 5 customers by total spending
SELECT
    customer_id,
    COUNT(*) AS total_transactions,
    ROUND(SUM(total_sale), 2) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Q9. Find the number of unique customers in each category
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- Q10. Analyze transaction volume by time-of-day shift
WITH shift_analysis AS (
    SELECT
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift,
        total_sale
    FROM retail_sales
)
SELECT
    shift,
    COUNT(*) AS total_transactions,
    ROUND(SUM(total_sale), 2) AS total_revenue,
    ROUND(AVG(total_sale), 2) AS average_transaction_value
FROM shift_analysis
GROUP BY shift
ORDER BY total_transactions DESC;

-- Q11. Category contribution to total revenue

SELECT
    category,
    ROUND(SUM(total_sale), 2) AS category_revenue,
    ROUND(
        100 * SUM(total_sale) / (SELECT SUM(total_sale) FROM retail_sales),
        2
    ) AS revenue_percentage
FROM retail_sales
GROUP BY category
ORDER BY category_revenue DESC;

-- Q12. Monthly revenue trend
SELECT
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    ROUND(SUM(total_sale), 2) AS monthly_revenue,
    COUNT(*) AS monthly_transactions
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY sale_year, sale_month;

-- Q13. Top category by gross profit
SELECT
    category,
    ROUND(SUM(total_sale - cogs), 2) AS gross_profit,
    ROUND(SUM(total_sale), 2) AS revenue
FROM retail_sales
GROUP BY category
ORDER BY gross_profit DESC;
