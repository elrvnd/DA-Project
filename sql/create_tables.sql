/*
==================================================================
Creating All Raw Data Tables
Note: Data was imported using SQL Import Wizard (CSV source), 
      but this file documents the intended table structure.
Warning: this query will drop any existing table with the same name.
==================================================================
*/

-- Customers Table
IF OBJECT_ID ('raw_customers', 'U') IS NOT NULL
	DROP TABLE raw_customers;
CREATE TABLE raw_customers (
	customer_key INT,
	gender NVARCHAR(50),
	full_name NVARCHAR(50),
	city NVARCHAR(50),
	state_code NVARCHAR(50),
	state_name NVARCHAR(50),
	zip_code NVARCHAR(50),
	country NVARCHAR(50),
	continent NVARCHAR(50),
	birthdate NVARCHAR(50)
);

-- Exchange Rates Table
IF OBJECT_ID ('raw_exchange', 'U') IS NOT NULL
	DROP TABLE raw_exchange;
CREATE TABLE raw_exchange (
	exchange_date NVARCHAR(50),
	currency NVARCHAR(50),
	exchange_rate FLOAT
);

-- Products Table
IF OBJECT_ID ('raw_products', 'U') IS NOT NULL
	DROP TABLE raw_products;
CREATE TABLE raw_products (
	product_key INT,
	product_name NVARCHAR(100),
	brand NVARCHAR(50),
	color NVARCHAR(50),
	unit_cost_usd NVARCHAR(50),
	unit_price_usd NVARCHAR(50),
	subcategory_key NVARCHAR(50),
	subcategory NVARCHAR(50),
	category_key NVARCHAR(50),
	category NVARCHAR(50)
);

-- Sales Table
IF OBJECT_ID ('raw_sales', 'U') IS NOT NULL
	DROP TABLE raw_sales;
CREATE TABLE raw_sales (
	order_number INT,
	line_item INT,
	order_date NVARCHAR(50),
	delivery_date NVARCHAR(50),
	customer_key INT,
	store_key INT,
	product_key INT,
	quantity INT,
	currency_code NVARCHAR(50)
);

-- Stores Table
IF OBJECT_ID ('raw_stores', 'U') IS NOT NULL
	DROP TABLE raw_stores;
CREATE TABLE raw_stores (
	store_key INT,
	country NVARCHAR(50),
	country_state NVARCHAR(50),
	square_meters INT,
	open_date NVARCHAR(50)
);
