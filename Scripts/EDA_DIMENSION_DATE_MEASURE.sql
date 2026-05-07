-- DIMENSION EXPLORATION (DISTINCT)
SELECT DISTINCT country FROM Cash.dim_customers

SELECT DISTINCT category, subcategory, product_name FROM Cash.dim_products
WHERE subcategory IS NOT NULL
ORDER BY 1,2,3 

-- DATE EXPLORATION (MIN/MAX)
SELECT 
	MAX(order_date) as LAST_order_date,
	MIN(order_date) as FIRST_order_date
	from Cash.fact_sales


SELECT 
	MAX(order_date) as LAST_order_date,
	MIN(order_date) as FIRST_order_date,
	DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) as YEARS_BETWEEN
	from Cash.fact_sales


SELECT 
	MAX(birthdate) as yOUNGEST_Customer,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) as Age,
	MIN(birthdate) as OLDEST_Customer,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) as Age
	from Cash.dim_customers

-- MEASURE EXPLORATION (SUM/AVG)

-- Total Sales Amount
SELECT SUM (sales_amount) as total_sale from Cash.fact_sales

-- FIND HOW MANY ITEM ARE SOLD
SELECT SUM (quantity) as total_items from Cash.fact_sales

-- FIND THE AVG SELLING PRICE
SELECT AVG (price) as avg_price from Cash.fact_sales

-- FIND THE TOTAL NUMBER OF ORDERS
SELECT COUNT (order_number) as total_order from Cash.fact_sales
 -- cutting duplicates
SELECT COUNT (DISTINCT order_number) AS total_orders from Cash.fact_sales

-- FIND THE TOTAL NUMBER OF PRODUCTS
SELECT COUNT (product_key) as total_products from Cash.dim_products
SELECT * FROM Cash.dim_products

-- FIND THE TOTAL NUMBER OF CUSTOMERS
SELECT * FROM Cash.dim_customers
SELECT COUNT (customer_key) as total_customers from Cash.dim_customers

-- FIND THE TOTAL NUMBER OF CUSTOMERS THAT HAS PLACED ORDER
SELECT COUNT (DISTINCT customer_key) as total_customers from Cash.fact_sales

-- generate report table
SELECT 'Total Sale' as Measure_Name, SUM (sales_amount) as measure_value from Cash.fact_sales
UNION ALL
SELECT 'Total items' as Measure_Name, SUM (quantity) as measure_value from Cash.fact_sales
UNION ALL
SELECT 'Avg selling price' as Measure_Name, AVG (price) as measure_value from Cash.fact_sales
UNION ALL
SELECT 'Total order' as Measure_Name, COUNT (DISTINCT order_number) as measure_value from Cash.fact_sales
UNION ALL
SELECT 'Total products' as Measure_Name, COUNT (DISTINCT product_key) as measure_value from Cash.dim_products
UNION ALL
SELECT 'Total Customers' as Measure_Name, COUNT (customer_key) as measure_value from Cash.dim_customers
UNION ALL
SELECT 'Total Customers Orderd ' as Measure_Name, COUNT (customer_key) as measure_value from Cash.fact_sales