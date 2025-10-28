/*================================================
Checking the Quality of Gold Tables
=================================================*/

-- Overall table
SELECT * FROM gold_dim_customers;
SELECT * FROM gold_dim_products;
SELECT * FROM gold_dim_stores;
SELECT * FROM gold_dim_exchange;
SELECT * FROM gold_fact_sales;

-- Check row count
SELECT COUNT(*) FROM gold_fact_sales;

-- Check before and after row count for each table
SELECT 'gold_dim_customers' AS table_name, COUNT(*) AS row_count FROM gold_dim_customers
UNION ALL
SELECT 'clean_customers', COUNT(*) AS row_ount FROM clean_customers
UNION ALL
SELECT 'gold_dim_products', COUNT(*) FROM gold_dim_products
UNION ALL
SELECT 'clean_products', COUNT(*) FROM clean_products
UNION ALL
SELECT 'gold_dim_stores', COUNT(*) FROM gold_dim_stores
UNION ALL
SELECT 'clean_stores', COUNT(*) FROM clean_stores
UNION ALL
SELECT 'gold_dim_exchange', COUNT(*) FROM gold_dim_exchange
UNION ALL
SELECT 'clean_exchange', COUNT(*) FROM clean_exchange
UNION ALL
SELECT 'gold_fact_sales', COUNT(*) FROM gold_fact_sales
UNION ALL
SELECT 'clean_sales', COUNT(*) FROM clean_sales;

-- Check for duplicates
SELECT 
	order_number, 
	line_item, 
	COUNT(*) 
FROM gold_fact_sales 
GROUP BY order_number, line_item
HAVING COUNT(*) > 1;

-- Check for NULLs in key fields
SELECT COUNT(*) AS null_order_number
FROM gold_fact_sales
WHERE order_number IS NULL OR line_item IS NULL;

SELECT COUNT(*) AS null_keys
FROM gold_fact_sales
WHERE customer_key IS NULL OR store_key IS NULL OR product_key IS NULL;

-- Simple aggregation test
SELECT 
	COUNT(DISTINCT order_number) AS total_orders,
	ROUND(SUM(revenue_usd), 2) AS total_revenue_usd,
	ROUND(SUM(profit_usd), 2) AS total_profit_usd,
	ROUND(AVG(profit_margin_pct), 2) AS avg_profit_margin_pct
FROM gold_fact_sales;

SELECT 
	YEAR(order_date) AS year, 
	COUNT(DISTINCT order_number) AS orders
FROM gold_fact_sales
GROUP BY YEAR(order_date)
ORDER BY year;

-- Check revenue and profit calculations
SELECT 
	ROUND(SUM(revenue_usd), 2) AS total_revenue, 
	ROUND(SUM(profit_usd), 2) AS total_profit
FROM gold_fact_sales;

-- Check for profit margin consistency
SELECT 
	MIN(profit_margin_pct), 
	MAX(profit_margin_pct)
FROM gold_fact_sales;

-- Check for price and quantiity
SELECT 
	MIN(p.unit_price_usd) max_unit_price,
	MAX(p.unit_price_usd) min_unit_price,
	MIN(s.quantity) min_quantity, 
	MAX(s.quantity) max_quantity
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
	ON s.product_key = p.product_key;

-- Check for invalid dates
SELECT COUNT(*) AS invalid_dates
FROM gold_fact_sales
WHERE delivery_date < order_date AND delivery_date IS NOT NULL;

-- Check order amount per year
SELECT YEAR(order_date) AS year, COUNT(DISTINCT order_number) AS orders
FROM gold_fact_sales
GROUP BY YEAR(order_date)
ORDER BY year;

SELECT 
	SUM(ABS(s.revenue_usd - ROUND((p.unit_price_usd / s.exchange_rate) * s.quantity, 2))) AS mismatch_revenue_amount
FROM gold_fact_sales s
JOIN gold_dim_products p
	ON s.product_key = p.product_key;

SELECT 
	SUM(ABS(s.cogs_usd - ROUND((p.unit_cost_usd / s.exchange_rate) * s.quantity, 2))) AS mismatch_cogs_amount
FROM gold_fact_sales s
JOIN gold_dim_products p
	ON s.product_key = p.product_key;

