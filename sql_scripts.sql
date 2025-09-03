-- Create Retail Sales Table
-- Description: Creates the main table structure for the retail sales data.
create table retail_sales
(
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(15),
age	INT,
category VARCHAR(15),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

-- Check for NULL Values in All Columns
-- Description: Identifies any rows containing NULL values that could affect analysis.
select * from retail_sales
where 
transactions_id	IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL 
OR
age	IS NULL 
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;

-- Delete Rows with NULL Values
-- Description: Removes incomplete records from the dataset to ensure data quality.
DELETE FROM retail_sales
where transactions_id	IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL 
OR
age	IS NULL 
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;

-- BASIC DATA EXPLORATION

-- Count Total Records
-- Description: Verifies the total number of rows in the table after cleaning.
select count(*) from retail_sales;

-- Count Total Sales Transactions
select count(*) from retail_sales;

-- Count Distinct Customers
SELECT count(distinct customer_id) from retail_sales;

-- List and Count Unique Product Categories
SELECT DISTINCT category from retail_sales;
SELECT count(DISTINCT category) from retail_sales;

-- BUSINESS PROBLEMS AND SOLUTIONS

-- Q1: write an sql query to retrive all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Write an sql query to retrive all transactions where the category is 'clothing' and 'quantity' sold is more than 4 and the month 'NOV-2022';
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
    AND
	TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'
	AND
	quantity >=4;

-- Q3: Write an sql query to calculate the total sales for each department
SELECT 
category,
SUM(total_sale) as Net_sale,
count(*) as allorders
FROM retail_sales
GROUP BY category;

-- Q4: Find the average age of the customers who purchased items from 'Beauty' category
SELECT 
ROUND(AVG(age))
FROM retail_sales
WHERE category = 'Beauty';

-- Q5: Find all transactions where the total_sale is greater than 1000.
Select *
from retail_sales
where total_sale>=1000;

-- Q6: Find total number of transactions (transactions_id) made by each gender by category.
SELECT
category,
gender,
count(transactions_id) as Total_trans
from retail_sales
Group by gender, category
order by category;


-- Q7: Write an sql query to calculate the avg sale for each month. Find out best selling month in each year.
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;

--Q8: Identify top 5 days with highest sale revenue. Show date & total sales for the day
SELECT 
    sale_date,
    SUM(total_sale) AS daily_revenue
FROM retail_sales
GROUP BY sale_date
ORDER BY daily_revenue DESC
LIMIT 5;


--Q9: Find the top 10 customers (by total spending) and list their customer_id, total amount spent, and the total number of transactions they made.
SELECT
    customer_id,
    ROUND(SUM(total_sale), 2) AS total_spent,
    COUNT(transactions_id) AS transaction_count
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Average Basket Value
-- Q:10 Calculate the average transaction value (ATV) for the entire dataset. ATV is the average total_sale per transaction.
SELECT
    ROUND(AVG(total_sale)::numeric, 1) AS avg_transaction_value
FROM retail_sales;

-- Q11: Average Basket Value
-- Calculate the average transaction value (ATV) for the entire dataset. ATV is the average total_sale per transaction.
SELECT
    ROUND(AVG(total_sale)::numeric, 1) AS avg_transaction_value
FROM retail_sales;

-- Q12: Hourly Sales Heatmap
-- Determine the total sales revenue for each hour of the day (e.g., 10:00, 11:00). This helps in staffing decisions.
SELECT
    EXTRACT(HOUR FROM sale_time) AS hour_of_day,
    ROUND(SUM(total_sale)::numeric, 2) AS total_revenue
FROM retail_sales
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- Q13: Gender-Based Purchasing Preferences
-- For each category, calculate the percentage of total quantity purchased by each gender.
WITH category_totals AS (
    SELECT
        category,
        SUM(quantity) AS total_category_quantity
    FROM retail_sales
    GROUP BY category
)
SELECT
    r.category,
    r.gender,
    SUM(r.quantity) AS quantity_by_gender
FROM retail_sales r
GROUP BY r.category, r.gender
ORDER BY r.category, r.gender;

-- Q14: Popular Items by Volume
-- Find the top 3 categories with the highest total quantity sold.
Select category,
sum(quantity) as quantity_by_volume
from retail_sales
group by category
order by quantity_by_volume desc
limit 3;

-- Q15: Identifying Big-Ticket Transactions
-- Find all transactions where the total_sale was more than 3 times the overall Average Transaction Value (ATV).
with atv as (
select avg(total_sale) as avg_sale from retail_sales
)
Select * 
from retail_sales s
cross join atv
where total_sale > (3 * atv.avg_sale);

-- Q16: Running Total of Sales
-- Show the cumulative running total of sales over time, ordered by date.
SELECT
    sale_date,
    total_sale,
    SUM(total_sale) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM retail_sales
ORDER BY sale_date;

-- Q17: Identifying High-Value New Customers
-- Find customers who made their first purchase in the last 30 days and have already spent more than $500.

WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(sale_date) AS first_purchase_date
    FROM retail_sales
    GROUP BY customer_id
    HAVING MIN(sale_date) >= CURRENT_DATE - INTERVAL '30 days'
)
SELECT
    r.customer_id,
    f.first_purchase_date,
    SUM(r.total_sale) AS total_spent
FROM retail_sales r
JOIN first_purchase f ON r.customer_id = f.customer_id
GROUP BY r.customer_id, f.first_purchase_date
HAVING SUM(r.total_sale) > 500
ORDER BY total_spent DESC;

-- Q18: Customer Age Demographics
-- Categorize customers into age groups (e.g., '18-25', '26-35', '36-45', '46+') and count the number of unique customers in each group.
SELECT 
  CASE 
    WHEN age BETWEEN 18 AND 25 THEN '18-25' 
	WHEN age BETWEEN 26 AND 35 THEN '26-35'
	WHEN age BETWEEN 36 AND 25 THEN '36-45'
	else '45+'
  END AS age_group,
  COUNT(DISTINCT customer_id) as unique_customers
  from retail_sales
  group by age_group
  order by age_group;


-- Q19: Monthly Sales Growth Rate
-- Calculate the Month-over-Month (MoM) growth percentage in total sales. (This is a classic time-series analysis).
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS sales_month,
        SUM(total_sale) AS total_revenue
    FROM retail_sales
    GROUP BY sales_month
)
SELECT
    sales_month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY sales_month) AS prev_month_revenue,
    ROUND(
        ((total_revenue - LAG(total_revenue) OVER (ORDER BY sales_month)) /
        LAG(total_revenue) OVER (ORDER BY sales_month)) * 100
    ) AS mom_growth_percentage
FROM monthly_sales
ORDER BY sales_month;

-- Q20: Cohort Analysis
-- Create a monthly cohort analysis showing how many customers from their first purchase month (cohort) returned in subsequent months.
WITH first_purchase AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(sale_date)) AS cohort_month
    FROM retail_sales
    GROUP BY customer_id
),
activity AS (
    SELECT
        r.customer_id,
        DATE_TRUNC('month', r.sale_date) AS activity_month,
        f.cohort_month
    FROM retail_sales r
    JOIN first_purchase f ON r.customer_id = f.customer_id
    GROUP BY r.customer_id, activity_month, f.cohort_month
)
SELECT
    cohort_month,
    COUNT(DISTINCT customer_id) AS cohort_size,
    COUNT(DISTINCT CASE WHEN activity_month = cohort_month + INTERVAL '1 month' THEN customer_id END) AS month_1,
    COUNT(DISTINCT CASE WHEN activity_month = cohort_month + INTERVAL '2 months' THEN customer_id END) AS month_2,
    COUNT(DISTINCT CASE WHEN activity_month = cohort_month + INTERVAL '3 months' THEN customer_id END) AS month_3
FROM activity
GROUP BY cohort_month
ORDER BY cohort_month;
