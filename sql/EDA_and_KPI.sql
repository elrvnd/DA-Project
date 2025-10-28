/*============================================================================
Retail Sales Data Analysis (EDA + KPI)
Description: This SQL script explores the retail sales database and computes 
             key performance metrics (KPIs) for business insight purposes.
============================================================================*/

---------------------------------------------------------------
-- 1. EXPLORE DATABASE STRUCTURE
---------------------------------------------------------------

-- Explore all objects in database
SELECT * FROM INFORMATION_SCHEMA.TABLES;
-- Explore all columns in database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;


---------------------------------------------------------------
-- 2. EXPLORATORY DATA ANALYSIS (EDA)
-- Goal: to understand the characteristics of the data
---------------------------------------------------------------

-- Explore Dimensions
-- Explore all countries where the customers come from
SELECT DISTINCT country FROM gold_dim_customers;

-- Explore all categories from brands
SELECT DISTINCT 
  brand,
  category,
  subcategory
FROM gold_dim_products
ORDER BY brand;

-- Date Exploration
-- Find the date of the first and the last order
-- Find how many years of sales are available
SELECT 
  MIN(order_date) first_order_date,
  MAX(order_date) last_order_date,
  DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) order_range_years
FROM gold_fact_sales;

-- Find the youngest and the oldest customer
SELECT 
  MIN(birthday) oldest_birthday,
  MAX(age) oldest_age,
  MAX(birthday) youngest_birthdate,
  MIN(age) youngest_age
FROM gold_dim_customers;

-- Dimension table: gold_dim_customers
-- Find average customer age
SELECT AVG(age) avg_customer_age FROM gold_dim_customers;

-- Find the top customer age group
SELECT 
  age_group,
  COUNT(age_group) number_of_cust
FROM gold_dim_customers
GROUP BY age_group
ORDER BY number_of_cust DESC;

-- Find customer segmentation by gender
SELECT 
  gender,
  COUNT(*) number_of_cust
FROM gold_dim_customers
GROUP BY gender;

-- Find customer segmentation by country
SELECT 
  country,
  COUNT(*) number_of_cust
FROM gold_dim_customers 
GROUP BY country;

-- Dimension table: gold_dim_products
-- Find average unit price & unit cost
SELECT 
  ROUND(AVG(unit_price_usd), 2) avg_unit_price_usd,
  ROUND(AVG(unit_cost_usd), 2) avg_unit_cost_usd
FROM gold_dim_products;

-- Find categories with the highest avg price
SELECT
  category,
  ROUND(AVG(unit_price_usd), 2) avg_price_usd
FROM gold_dim_products
GROUP BY category
ORDER BY avg_price_usd DESC;

-- Find categories with highest avg cost
SELECT
  category,
  ROUND(AVG(unit_cost_usd), 2) avg_cost_usd
FROM gold_dim_products
GROUP BY category
ORDER BY avg_cost_usd DESC;

-- Dimension table: gold_dim_stores
-- Find the total number of stores
SELECT COUNT(*) number_of_stores
FROM gold_dim_stores;

-- Find the average store years
SELECT AVG(store_age) avg_years_open
FROM gold_dim_stores;

-- Find the largest store
SELECT 
  country,
  AVG(square_meters) avg_sq_meters
FROM gold_dim_stores
GROUP BY country
ORDER BY avg_sq_meters DESC;

-- Dimension table: gold_dim_exchange
-- Find the average exchange rate per currency
SELECT 
  currency,
  ROUND(AVG(exchange_rate), 2) avg_exchange_rate
FROM gold_dim_exchange
GROUP BY currency;

-- Find the average exchange rate volatility per currency
SELECT 
  currency,
  ROUND(STDEV(exchange_rate), 2) stdev_exchange_rate
FROM gold_dim_exchange
GROUP BY currency;


---------------------------------------------------------------
-- 3. KPI AND BUSINESS PERFORMANCE METRICS
-- Goal: to find key measures for business insights
---------------------------------------------------------------

-- Explore Measures
-- Fact table: gold_fact_sales
-- Find total revenue, cost_of goods, profit, and profit margin percentage
SELECT 
  ROUND(SUM(revenue_usd), 2) total_sales_usd,
  ROUND(SUM(cogs_usd), 2) total_cogs_usd,
  ROUND(SUM(profit_usd), 2) total_profit_usd,
  ROUND(SUM(profit_usd) / SUM(revenue_usd) * 100, 2) profit_margin_pct
FROM gold_fact_sales;

-- Find total number of orders
SELECT COUNT(DISTINCT order_number) AS total_orders
FROM gold_fact_sales;

-- Yearly total orders
SELECT 
  YEAR(order_date) AS order_year,
  COUNT(DISTINCT order_number) AS total_orders
FROM gold_fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Find order_number with the most item quantity per order
SELECT TOP 5
  order_number,
  COUNT(line_item) AS items_per_order,
  SUM(quantity) AS total_quantity_per_order
FROM gold_fact_sales
GROUP BY order_number
ORDER BY total_quantity_per_order DESC;

-- Find total number of items sold
SELECT SUM(quantity) total_quantity
FROM gold_fact_sales;

-- Find average items per order (AIPO)
SELECT 
  ROUND(CAST(SUM(quantity) AS FLOAT)/CAST(COUNT(DISTINCT order_number) AS FLOAT), 2) avg_items_per_order
FROM gold_fact_sales;

-- AIPO per year
SELECT
  YEAR(order_date) order_year,
  ROUND(CAST(SUM(quantity) AS FLOAT)/CAST(COUNT(DISTINCT order_number) AS FLOAT), 2) avg_items_per_order
FROM gold_fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Find Average Order Value (AOV)
SELECT ROUND(SUM(revenue_usd)/COUNT(DISTINCT order_number), 2) aov_usd
FROM gold_fact_sales;

-- AOV per year
SELECT 
  YEAR(order_date) AS order_year,
  ROUND(SUM(revenue_usd)/COUNT(DISTINCT order_number), 2) AS aov_usd
FROM gold_fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;


---------------------------------------------------------------
-- 4. CATEGORY, BRAND, AND PRODUCT PERFORMANCE
---------------------------------------------------------------

-- Top selling items/products
SELECT TOP 5
  p.product_type,
  SUM(s.quantity) total_sold
FROM gold_fact_sales s
JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_type
ORDER BY total_sold DESC;

-- Top selling brands
SELECT TOP 5
  p.brand,
  SUM(s.quantity) total_sold
FROM gold_fact_sales s
JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.brand
ORDER BY total_sold DESC;

-- Top revenue per brand
SELECT TOP 5
  p.brand,
  SUM(s.revenue_usd) total_revenue
FROM gold_fact_sales s
JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.brand
ORDER BY total_revenue DESC;

-- Top selling categories
SELECT TOP 5
  p.category,
  SUM(s.quantity) total_sold
FROM gold_fact_sales s
JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sold DESC;

-- Top selling subcategories
SELECT TOP 5
  p.subcategory,
  SUM(s.quantity) total_sold
FROM gold_fact_sales s
JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_sold DESC;

-- Top profitable categories
SELECT TOP 5
  p.category,
  SUM(s.profit_usd) total_profit
FROM gold_fact_sales s
JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_profit DESC;

-- Top profitable subcategories
SELECT TOP 5
  p.subcategory,
  SUM(s.profit_usd) total_profit
FROM gold_fact_sales s
JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_profit DESC;


---------------------------------------------------------------
-- 5. GEOGRAPHICAL AND STORE PERFORMANCE
---------------------------------------------------------------

-- Top selling countries
SELECT 
  r.country,
  SUM(s.quantity) total_sold
FROM gold_fact_sales s
JOIN gold_dim_stores r
ON s.store_key = r.store_key
GROUP BY r.country
ORDER BY total_sold DESC;

-- Top performing stores
SELECT TOP 10
  s.store_key,
  r.state_name,
  r.country,
  r.store_age,
  ROUND(SUM(s.profit_usd), 2) AS total_profit
FROM gold_fact_sales s
JOIN gold_dim_stores r 
  ON s.store_key = r.store_key
GROUP BY s.store_key, r.state_name, r.country, r.store_age
ORDER BY total_profit DESC;	


---------------------------------------------------------------
-- 6. CUSTOMER INSIGHTS
---------------------------------------------------------------

-- Total customers vs customers who have placed orders
SELECT 
  COUNT(DISTINCT c.customer_key) AS total_customers,
  COUNT(DISTINCT s.customer_key) AS total_cust_ordered,
  COUNT(DISTINCT c.customer_key) - COUNT(DISTINCT s.customer_key) AS total_cust_not_ordered
FROM gold_dim_customers AS c
LEFT JOIN gold_fact_sales AS s
	ON c.customer_key = s.customer_key;

-- Top revenue by customer age group
SELECT TOP 5
  c.age_group,
  ROUND(SUM(s.revenue_usd), 2) total_revenue
FROM gold_fact_sales s
JOIN gold_dim_customers c
	ON s.customer_key = c.customer_key
GROUP BY c.age_group
ORDER BY total_revenue DESC;

-- Top revenue by customers' country
SELECT
  c.country customers_country,
  ROUND(SUM(s.revenue_usd), 2) AS total_revenue
FROM gold_fact_sales s
JOIN gold_dim_customers c ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_revenue DESC;


---------------------------------------------------------------
-- 7. CROSS-TABLE INSIGHTS & ADVANCED KPI
---------------------------------------------------------------

-- Customer behavior by age group and category
SELECT TOP 10
  c.age_group,
  p.category,
  ROUND(SUM(s.revenue_usd), 2) AS total_revenue
FROM gold_fact_sales s
JOIN gold_dim_customers c ON s.customer_key = c.customer_key
JOIN gold_dim_products p ON s.product_key = p.product_key
GROUP BY c.age_group, p.category
ORDER BY total_revenue DESC;

-- Store efficiency analysis by store type
SELECT 
  CASE 
    WHEN r.country = 'Online' THEN 'Online'
    WHEN r.square_meters > 1500 THEN 'Large Physical'
    WHEN r.square_meters BETWEEN 800 AND 1500 THEN 'Medium Physical'
      ELSE 'Small Physical'
  END AS store_type,
  ROUND(SUM(s.revenue_usd), 2) AS total_revenue,
  ROUND(SUM(s.profit_usd), 2) AS total_profit,
  ROUND(SUM(s.profit_usd) / SUM(s.revenue_usd) * 100, 2) AS profit_margin_pct
FROM gold_fact_sales s
JOIN gold_dim_stores r 
    ON s.store_key = r.store_key
GROUP BY 
  CASE 
    WHEN r.country = 'Online' THEN 'Online'
    WHEN r.square_meters > 1500 THEN 'Large Physical'
    WHEN r.square_meters BETWEEN 800 AND 1500 THEN 'Medium Physical'
      ELSE 'Small Physical'
  END
  ORDER BY total_revenue DESC;

-- Regional profit margin
SELECT 
  st.country,
  ROUND(SUM(s.revenue_usd), 2) AS total_revenue,
  ROUND(SUM(s.profit_usd), 2) AS total_profit,
  ROUND(SUM(s.profit_usd) / SUM(s.revenue_usd) * 100, 2) AS profit_margin_pct
FROM gold_fact_sales s
JOIN gold_dim_stores st 
  ON s.store_key = st.store_key
GROUP BY st.country
ORDER BY profit_margin_pct DESC;

-- Yearly revenue growth (YoY)
WITH yearly_revenue AS (
  SELECT 
		YEAR(order_date) AS order_year,
		ROUND(SUM(revenue_usd), 2) AS total_revenue
	FROM gold_fact_sales
	GROUP BY YEAR(order_date)
)
SELECT
	order_year,
	total_revenue,
	ROUND(
		(total_revenue - LAG(total_revenue) OVER (ORDER BY order_year))
		/ NULLIF(LAG(total_revenue) OVER (ORDER BY order_year), 0) * 100, 2
	) AS yoy_growth_pct
FROM yearly_revenue
ORDER BY order_year;

