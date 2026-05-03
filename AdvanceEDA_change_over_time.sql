-- Change over time 

SELECT
	YEAR(order_date) AS order_year,
	SUM(sales_amount) AS total_sale,
	COUNT(DISTINCT customer_key) AS customers,
	SUM(quantity) AS total_quantity
FROM Cash.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(order_date)
ORDER BY YEAR(order_date)

-- Change over time WITH PRODUCTS
SELECT
	YEAR(fs.order_date) AS order_year,
	SUM(fs.sales_amount) AS total_sale,
	COUNT(DISTINCT fs.customer_key) AS customers,
	SUM(fs.quantity) AS total_quantity,
	ds.category
FROM Cash.fact_sales fs
LEFT JOIN Cash.dim_products ds 
ON fs.product_key = ds.product_key
WHERE fs.order_date IS NOT NULL
GROUP BY 
	YEAR(fs.order_date),
    ds.category
ORDER BY YEAR(fs.order_date)

-- Change over time MONTH
SELECT
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sale,
	COUNT(DISTINCT customer_key) AS customers,
	SUM(quantity) AS total_quantity
FROM Cash.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY 
	MONTH(order_date)
ORDER BY MONTH(order_date)

-- Change over time MONTH & YEAR (this one i'm gonna use)
SELECT
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sale,
	COUNT(DISTINCT customer_key) AS customers,
	SUM(quantity) AS total_quantity
FROM Cash.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(order_date),
	MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)


-- Change over time MONTH IN YEAR
SELECT
	DATETRUNC (MONTH, order_date) AS order_year,
	SUM(sales_amount) AS total_sale,
	COUNT(DISTINCT customer_key) AS customers,
	SUM(quantity) AS total_quantity
FROM Cash.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (MONTH, order_date)
ORDER BY DATETRUNC (MONTH, order_date)

SELECT
	DATETRUNC (YEAR, order_date) AS order_year,
	SUM(sales_amount) AS total_sale,
	COUNT(DISTINCT customer_key) AS customers,
	SUM(quantity) AS total_quantity
FROM Cash.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (YEAR, order_date)
ORDER BY DATETRUNC (YEAR, order_date)

SELECT
	FORMAT (order_date, 'yyyy-MMM') AS order_year,
	SUM(sales_amount) AS total_sale,
	COUNT(DISTINCT customer_key) AS customers,
	SUM(quantity) AS total_quantity
FROM Cash.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY FORMAT (order_date, 'yyyy-MMM') 
ORDER BY FORMAT (order_date, 'yyyy-MMM') 