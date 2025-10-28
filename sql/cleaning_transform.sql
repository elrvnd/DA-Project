/*
=======================================================
Raw Table to Clean Table
Warning: this query will drop any existing table with the same name.
=======================================================
*/

-- Clean Customers Table
IF OBJECT_ID('dbo.clean_customers', 'U') IS NOT NULL
    DROP TABLE dbo.clean_customers;

SELECT
	CustomerKey AS customer_key,
	Gender AS gender,
	Name AS full_name,
	TRY_CAST(birthday as DATE) AS birthday,
	(SELECT STRING_AGG(UPPER(LEFT(value,1)) + LOWER(SUBSTRING(value,2,LEN(value))), ' ') FROM STRING_SPLIT(city, ' ')) AS city,
	state_code,
	state AS state_name,
	TRY_CAST(zip_code AS INT) AS zip_code,
	country,
	continent
INTO dbo.clean_customers
FROM dbo.raw_customers
WHERE CustomerKey IS NOT NULL;


-- Clean Exchange Table
IF OBJECT_ID('dbo.clean_exchange', 'U') IS NOT NULL
   DROP TABLE dbo.clean_exchange;

SELECT
	TRY_CAST(date as DATE) AS exchange_date,
	currency,
	exchange AS exchange_rate
INTO dbo.clean_exchange
FROM dbo.raw_exchange;


-- Clean Products Table 
IF OBJECT_ID('dbo.clean_products', 'U') IS NOT NULL
   DROP TABLE dbo.clean_products;

WITH parsed AS (
    SELECT
        *,
        -- Take last word
        RIGHT(product_name, CHARINDEX(' ', REVERSE(product_name)) - 1) AS last_word,

        -- Take second last word
        REVERSE(
            LEFT(
                REVERSE(
                    LEFT(product_name, LEN(product_name) - CHARINDEX(' ', REVERSE(product_name)))
                ),
                CHARINDEX(' ', REVERSE(
                    LEFT(product_name, LEN(product_name) - CHARINDEX(' ', REVERSE(product_name)))
                )) - 1
            )
        ) AS second_last_word
    FROM raw_products
)
SELECT
    productkey AS product_key,
    product_name,
    brand,

    -- model name: if last word is color, then model is second last word
    CASE 
        WHEN last_word IN ('Red', 'Blue', 'Green', 'Black', 'White', 'Yellow', 'Silver', 'Gray', 'Grey',
                           'Purple', 'Orange', 'Pink', 'Brown', 'Gold', 'Azure', 'Transparent')
            THEN second_last_word
        ELSE last_word
    END AS model,

    -- color name: if product_name has color info, take color from there, if not, take from color column
    CASE 
        WHEN last_word IN ('Red', 'Blue', 'Green', 'Black', 'White', 'Yellow', 'Silver', 'Gray', 'Grey',
                           'Purple', 'Orange', 'Pink', 'Brown', 'Gold', 'Azure', 'Transparent')
            THEN last_word
        WHEN color IS NOT NULL AND color <> ''
            THEN color
        ELSE NULL
    END AS color,

    -- raw_type: remove model and color from product_name
    LTRIM(RTRIM(
        REPLACE(
            REPLACE(product_name,
                CASE 
                    WHEN last_word IN ('Red', 'Blue', 'Green', 'Black', 'White', 'Yellow', 'Silver', 'Gray', 'Grey',
                                       'Purple', 'Orange', 'Pink', 'Brown', 'Gold', 'Azure', 'Transparent')
                        THEN second_last_word
                    ELSE last_word
                END, ''
            ),
            last_word, ''
        )
    )) AS raw_type,
	-- remove dollar sign from unit pice and cost, then cast to float
    TRY_CAST(REPLACE(SUBSTRING(unit_cost_usd, 2, LEN(unit_cost_usd)), ',', '') AS FLOAT) AS unit_cost_usd,
    TRY_CAST(REPLACE(SUBSTRING(unit_price_usd, 2, LEN(unit_price_usd)), ',', '') AS FLOAT) AS unit_price_usd,
    TRY_CAST(subcategorykey AS INT) AS subcategory_key,
    subcategory,
    TRY_CAST(categorykey AS INT) AS category_key,
    category
INTO dbo.clean_products
FROM parsed;


-- Clean Stores Table 
IF OBJECT_ID('dbo.clean_stores', 'U') IS NOT NULL
   DROP TABLE dbo.clean_stores;

SELECT
	StoreKey AS store_key,
	country,
	state AS state_name,
	CASE WHEN square_meters IS NULL AND country = 'Online' 
		 THEN 0
		 ELSE square_meters
	END AS square_meters,
	TRY_CAST(open_date AS DATE) AS open_date
INTO dbo.clean_stores
FROM dbo.raw_stores;


-- Clean Sales Table
IF OBJECT_ID('dbo.clean_sales', 'U') IS NOT NULL
   DROP TABLE dbo.clean_sales;

SELECT 
	order_number,
	line_item,
	TRY_CAST(order_date AS DATE) AS order_date,
	TRY_CAST(MAX(delivery_date) OVER (PARTITION BY order_number) AS DATE) AS delivery_date,
	CustomerKey AS customer_key,
	StoreKey AS store_key,
	ProductKey AS product_key,
	quantity, 
	currency_code,
	-- data quality flag: majority of orders don't have delivery date
	CASE 
		WHEN MAX(delivery_date) OVER (PARTITION BY order_number) IS NOT NULL 
		THEN 1 ELSE 0 
	END AS has_delivery_date
INTO dbo.clean_sales
FROM dbo.raw_sales;
