/*====================================================
Data Overview
Check all tables after importing raw data using SQL Wizard
====================================================*/

-- Table 1: raw_customers
SELECT * FROM raw_customers;

-- Table 2: raw_exchange
SELECT * FROM raw_exchange;

-- Table 3: raw_products
SELECT * FROM raw_products;

-- Table 4: raw_sales
SELECT * FROM raw_sales;

-- Table 5: raw_stores
SELECT * FROM raw_stores;


/*====================================================
 Locate issues
- Inconsistent data formats
- Inconsistent spellings or categorizations
- Nulls
- Invalid values
- etc
====================================================*/

-- TABLE 1: raw_customers
SELECT * FROM raw_customers;

-- Check for duplicates & NULLs
SELECT 
customerkey,
COUNT(customerkey) 
FROM raw_customers
GROUP BY customerkey
HAVING COUNT(*) > 1 OR customerkey IS NULL;

-- Check for data type
SELECT customerkey
FROM raw_customers
WHERE TRY_CAST(customerkey AS INT) IS NULL AND customerkey IS NOT NULL;

-- Check for trailing and leading
SELECT gender
FROM raw_customers
WHERE gender != TRIM(gender);

SELECT name 
FROM raw_customers
WHERE name != TRIM(name);

SELECT city
FROM raw_customers
WHERE city != TRIM(city);

SELECT state_code
FROM raw_customers
WHERE state_code != TRIM(state_code);

SELECT state
FROM raw_customers
WHERE state != TRIM(state);

SELECT country
FROM raw_customers
WHERE country != TRIM(country);

SELECT zip_code -- change type
FROM raw_customers
WHERE zip_code != TRIM(zip_code);

SELECT continent
FROM raw_customers
WHERE continent != TRIM(continent);

-- Check for zero or negative values
SELECT customerkey
FROM raw_customers
WHERE customerkey <= 0;

-- Check for data standardization & consistency
SELECT DISTINCT gender
FROM raw_customers;

SELECT DISTINCT city -- issues detected
FROM raw_customers
ORDER BY 1 ASC;
-- check duplicates for the formatted city name
WITH formatted_city AS (
	SELECT DISTINCT
	City AS before_city,
	(SELECT STRING_AGG(UPPER(LEFT(value,1)) + LOWER(SUBSTRING(value,2,LEN(value))), ' ')
	FROM STRING_SPLIT(city, ' ')) AS after_city
	FROM raw_customers)
SELECT 
after_city, 
COUNT(after_city)
FROM formatted_city
GROUP BY after_city
HAVING COUNT(*) > 1 OR after_city IS NULL;
-- no duplicate after fix.

SELECT DISTINCT -- issues detected
state_code,
state,
country,
LEN(state_code) characters_length
FROM raw_customers 
WHERE LEN(state_code) >= 4
ORDER BY LEN(state_code), country;

SELECT DISTINCT country
FROM raw_customers;

SELECT DISTINCT continent
FROM raw_customers;

-- Check for invalid date
-- Look for customer age range
SELECT 
MIN(TRY_CAST(birthday AS DATE)) earliest_bdate,
DATEDIFF(YEAR, MIN(TRY_CAST(birthday AS DATE)), GETDATE()) earliest_age,
MAX(TRY_CAST(birthday AS DATE)) latest_bdate,
DATEDIFF(YEAR, MAX(TRY_CAST(birthday AS DATE)), GETDATE()) latest_age
FROM raw_customers;

-- TABLE 2: raw_exchange
SELECT * FROM raw_exchange;

-- Check for duplicates & NULLs
SELECT
TRY_CAST(date AS DATE) date,
currency,
COUNT(*) duplicate
FROM raw_exchange
GROUP BY TRY_CAST(date AS DATE), currency
HAVING COUNT(*) > 1;

SELECT *
FROM raw_exchange
WHERE exchange IS NULL OR TRY_CAST(date AS DATE) IS NULL;

-- Check for trailing and leading
SELECT currency
FROM raw_exchange
WHERE currency != TRIM(currency);

-- Check for data standardization & consistency
SELECT DISTINCT currency
FROM raw_exchange;

-- Check for zero or negative values
SELECT exchange
FROM raw_exchange
WHERE exchange <= 0;

-- Check for invalid date
SELECT 
MIN(TRY_CAST(date AS DATE)) earliest_date,
MAX(TRY_CAST(date AS DATE)) latest_date
FROM raw_exchange;

-- TABLE 3: raw_products
SELECT * FROM raw_products;

-- Check for duplicates & NULLs
SELECT 
productkey,
COUNT(productkey)
FROM raw_products
GROUP BY productkey
HAVING COUNT(*) > 1 OR productkey IS NULL;

SELECT *
FROM raw_products
WHERE product_name IS NULL 
	OR brand IS NULL
	OR unit_cost_usd IS NULL 
	OR unit_price_usd IS NULL
	OR subcategory IS NULL
	OR category IS NULL;

SELECT * -- change type
FROM raw_products
WHERE TRY_CAST(subcategorykey AS INT) IS NULL OR TRY_CAST(categorykey AS INT) IS NULL;

-- Check for trailing and leading
SELECT product_name
FROM raw_products
WHERE product_name != TRIM(product_name);

SELECT brand
FROM raw_products
WHERE brand != TRIM(brand); 

SELECT color
FROM raw_products
WHERE color != TRIM(color);

SELECT subcategory
FROM raw_products
WHERE subcategory != TRIM(subcategory);

SELECT category
FROM raw_products
WHERE category != TRIM(category);

SELECT subcategorykey
FROM raw_products
WHERE subcategorykey != TRIM(subcategorykey);

SELECT categorykey
FROM raw_products
WHERE categorykey != TRIM(categorykey);

-- Check for data standardization & consistency
SELECT unit_cost_usd, unit_price_usd  -- issues detected
FROM raw_products;

SELECT DISTINCT product_name -- issues detected
FROM raw_products;

SELECT DISTINCT brand
FROM raw_products;

SELECT DISTINCT color
FROM raw_products;

SELECT DISTINCT subcategory, subcategorykey
FROM raw_products;

SELECT DISTINCT category, categorykey -- issues detected
FROM raw_products;

-- Check for zero or negative values
SELECT unit_cost_usd, unit_price_usd
FROM raw_products
WHERE TRY_CAST(REPLACE(REPLACE(unit_cost_usd, '$', ''), ',', '') AS FLOAT) <= 0 
OR TRY_CAST(REPLACE(REPLACE(unit_price_usd, '$', ''), ',', '') AS FLOAT) <= 0;

-- TABLE 4: raw_sales
SELECT * FROM raw_sales; 

-- Check for duplicates & NULLs
SELECT order_number,
COUNT(order_number)
FROM raw_sales
GROUP BY order_number, line_item
HAVING COUNT(*) > 1 OR order_number IS NULL;

SELECT * -- issues detected
FROM raw_sales
WHERE TRY_CAST(order_date AS DATE) IS NULL 
	OR TRY_CAST(delivery_date AS DATE) IS NULL
	OR customerkey IS NULL 
	OR storekey IS NULL
	OR productkey IS NULL
	OR quantity IS NULL
	OR currency_code IS NULL;

SELECT 
order_number,
MAX(TRY_CAST(delivery_date AS DATE))
FROM raw_sales
GROUP BY order_number

SELECT -- check for missing delivery dates (Nulls)
order_number,
MAX(TRY_CAST(delivery_date AS DATE)) AS order_delivery_date
FROM raw_sales
GROUP BY order_number
HAVING MAX(TRY_CAST(delivery_date AS DATE)) IS NULL;

SELECT -- this gives the summary and count of line items missing delivery dates
order_number, 
COUNT(*) total_line_items, -- how many products were in the order. uses COUNT(*) to include the null (using COUNT(line_item) ignores the null in line_item column)
SUM(CASE WHEN TRY_CAST(delivery_date AS DATE) IS NULL THEN 1 ELSE 0 END) null_delivery_item, -- how many of those line items are missing a delivery date
MAX(TRY_CAST(delivery_date AS DATE)) order_delivery_date
FROM raw_sales
GROUP BY order_number
HAVING MAX(TRY_CAST(delivery_date AS DATE)) IS NULL;

-- Check for trailing and leading
SELECT currency_code
FROM raw_sales
WHERE currency_code != TRIM(currency_code);

-- Check for data standardization & consistency
SELECT DISTINCT storekey
FROM raw_sales
ORDER BY 1 ASC;

SELECT DISTINCT currency_code
FROM raw_sales;

-- Check for zero or negative values
SELECT quantity
FROM raw_sales
WHERE quantity <= 0;

-- Check for Invalid Date Orders (delivery date < order_date)
SELECT *
FROM raw_sales
WHERE TRY_CAST(delivery_date AS DATE) < TRY_CAST (order_date AS DATE);

SELECT
MIN(TRY_CAST(order_date AS DATE)) earliest_order_date,
MAX(TRY_CAST(order_date AS DATE)) latest_order_date,
MIN(TRY_CAST(delivery_date AS DATE)) earliest_delivery_date,
MAX(TRY_CAST(delivery_date AS DATE)) latest_delivery_date
FROM raw_sales;

-- TABLE 5: raw_stores
SELECT * FROM raw_stores;

-- Check for duplicates & NULLs
SELECT 
storekey,
COUNT(storekey) 
FROM raw_stores
GROUP BY storekey
HAVING COUNT(*) > 1 OR storekey IS NULL;

SELECT * -- issues detected
FROM raw_stores
WHERE country IS NULL
	OR state IS NULL
	OR square_meters IS NULL
	OR TRY_CAST(open_date AS DATE) IS NULL;

-- Check for trailing and leading
SELECT country, state
FROM raw_stores
WHERE country != TRIM(country) OR state != TRIM(state);

-- Check for data standardization & consistency
SELECT DISTINCT country
FROM raw_stores;

SELECT DISTINCT state
FROM raw_stores;

-- Check for zero or negative values
SELECT square_meters
FROM raw_stores
WHERE square_meters <= 0;

SELECT
MIN(TRY_CAST(open_date AS DATE)) earliest_open_date,
MAX(TRY_CAST(open_date AS DATE)) latest_open_date,
DATEDIFF(YEAR, MIN(TRY_CAST(open_date AS DATE)), GETDATE()) oldest_store_age,
DATEDIFF(YEAR, MAX(TRY_CAST(open_date AS DATE)), GETDATE()) newest_store_age
FROM raw_stores;

/*====================================================
All issues are documented in an issue log (Excel File)
======================================================*/




