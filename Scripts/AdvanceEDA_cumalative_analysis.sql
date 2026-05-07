-- Calculate the total sale per month
-- and the running of sale over time

SELECT 
	order_date,
	sales_amount
FROM Cash.fact_sales

SELECT 
	DATETRUNC(month, order_date) as order_month,
	sum(sales_amount) as sale_year
FROM Cash.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)

-- and the running of sale over time

SELECT 
	order_date, 
	total_sale,
	SUM(total_sale) OVER( ORDER BY order_date) AS running_total_sale
FROM(
	SELECT 
		DATETRUNC(month, order_date) as order_date,
		sum(sales_amount) as total_sale
	FROM Cash.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
	)t

-- each year sales check
SELECT 
	order_date, 
	total_sale,
	SUM(total_sale) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_sale
FROM(
	SELECT 
		DATETRUNC(month, order_date) as order_date,
		sum(sales_amount) as total_sale
	FROM Cash.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
	)t


-- BY YEAR
SELECT 
	order_date, 
	total_sale,
	SUM(total_sale) OVER( ORDER BY order_date) AS running_total_sale
FROM(
	SELECT 
		DATETRUNC(YEAR, order_date) as order_date,
		sum(sales_amount) as total_sale
	FROM Cash.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR, order_date)
	)t

-- AVERAGE PRICE CHECK BY YEAR
SELECT 
	order_date, 
	total_sale,
	SUM(total_sale) OVER( ORDER BY order_date) AS running_total_sale,
	AVG(avg_price) OVER( ORDER BY order_date) AS moving_avg_price
FROM(
	SELECT 
		DATETRUNC(YEAR, order_date) as order_date,
		sum(sales_amount) as total_sale,
		AVG(price) as avg_price
	FROM Cash.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR, order_date)
	)t