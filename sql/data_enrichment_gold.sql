/*============================================================
From Clean Table to Gold Table
-- Warning: this query will drop any existing table with the same name.
=============================================================*/

-- Dimension Table
-- 1. gold_dim_customers 
IF OBJECT_ID('dbo.gold_dim_customers', 'U') IS NOT NULL 
	DROP TABLE dbo.gold_dim_customers;

SELECT
	customer_key,
	gender,
	full_name,
	birthday,
	DATEDIFF(YEAR, birthday, GETDATE()) age,
	CASE WHEN birthday IS NULL THEN 'Unknown'
		 WHEN DATEDIFF(YEAR, birthday, GETDATE()) BETWEEN 18 AND 24 THEN '18-24'
		 WHEN DATEDIFF(YEAR, birthday, GETDATE()) BETWEEN 25 AND 34 THEN '25-34'
		 WHEN DATEDIFF(YEAR, birthday, GETDATE()) BETWEEN 35 AND 44 THEN '35-44'
		 WHEN DATEDIFF(YEAR, birthday, GETDATE()) BETWEEN 45 AND 54 THEN '45-54'
		 WHEN DATEDIFF(YEAR, birthday, GETDATE()) BETWEEN 55 AND 64 THEN '55-64'
		 ELSE '65+'
	END age_group,
	city,
	state_code,
	state_name,
	zip_code,
	country,
	continent
INTO gold_dim_customers
FROM clean_customers;


-- 2. gold_dim_exchange 
IF OBJECT_ID('dbo.gold_dim_exchange', 'U') IS NOT NULL 
	DROP TABLE dbo.gold_dim_exchange;

SELECT
	exchange_date,
	currency,
	exchange_rate
INTO gold_dim_exchange
FROM clean_exchange;


-- 3. gold_dim_products
IF OBJECT_ID('dbo.gold_dim_products', 'U') IS NOT NULL 
	DROP TABLE dbo.gold_dim_products;

SELECT *
INTO gold_dim_products
FROM (
    SELECT
        product_key,
        product_name,
        brand,
        color,
        raw_type AS product_type,
        model,
        unit_cost_usd,
        unit_price_usd,
        CASE 
            WHEN NTILE(3) OVER (ORDER BY unit_price_usd) = 1 THEN 'Budget'
            WHEN NTILE(3) OVER (ORDER BY unit_price_usd) = 2 THEN 'Mid'
            ELSE 'Premium'
        END AS price_category,
        subcategory_key,
        subcategory,
        category_key,
        category
    FROM clean_products
) t;


-- 4. gold_dim_stores
IF OBJECT_ID('dbo.gold_dim_stores', 'U') IS NOT NULL 
	DROP TABLE dbo.gold_dim_stores;

SELECT
	store_key,
	country,
	state_name,
	square_meters,
	open_date,
	DATEDIFF(YEAR, open_date, GETDATE()) store_age
INTO gold_dim_stores
FROM clean_stores;


-- Fact Table
-- gold_fact_sales
IF OBJECT_ID('dbo.gold_fact_sales', 'U') IS NOT NULL 
	DROP TABLE dbo.gold_fact_sales;

SELECT
	s.order_number,
	s.line_item,
	s.order_date,
	s.delivery_date,
	s.customer_key,
	s.store_key,
	s.product_key,
	s.quantity,
	s.currency_code,
	e.exchange_rate,
	  -- convert unit price/cost first, then multiply quantity
	ROUND(s.quantity * (p.unit_price_usd / e.exchange_rate), 2) AS revenue_usd,
	ROUND(s.quantity * (p.unit_cost_usd / e.exchange_rate), 2) AS cogs_usd,
	ROUND(s.quantity * ((p.unit_price_usd - p.unit_cost_usd) / e.exchange_rate), 2) AS profit_usd,
	ROUND(
		((p.unit_price_usd - p.unit_cost_usd) / e.exchange_rate)
		/ NULLIF((p.unit_price_usd / e.exchange_rate), 0) * 100
	, 2) AS profit_margin_pct
INTO gold_fact_sales
FROM clean_sales s
LEFT JOIN clean_products p 
	ON s.product_key = p.product_key
LEFT JOIN clean_exchange e -- join for conversion
  ON s.currency_code = e.currency AND s.order_date = e.exchange_date;

