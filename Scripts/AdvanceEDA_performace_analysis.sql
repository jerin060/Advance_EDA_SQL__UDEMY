-- Analyze the yearly performance of products by comparing their sales 
-- to both the average sales performance of the product and the previous year's sales

-- product sale by year
SELECT 
	YEAR (f.order_date) as order_year,
	p.product_name,
	SUM(f.sales_amount) AS current_sale
FROM Cash.fact_sales f
LEFT JOIN Cash.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR (f.order_date),
	p.product_name;



-- average sale performance by year
WITH yearly_product_sale AS(
	SELECT 
		YEAR (f.order_date) as order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sale
	FROM Cash.fact_sales f
	LEFT JOIN Cash.dim_products p
		ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY 
		YEAR (f.order_date),
		p.product_name
)

SELECT
order_year,
product_name,
current_sale,
AVG(current_sale) OVER (PARTITION BY product_name) AS avg_sale,
current_sale - AVG(current_sale) OVER (PARTITION BY product_name) AS diff_avg,
CASE WHEN current_sale - AVG(current_sale) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
	WHEN current_sale - AVG(current_sale) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
	ELSE 'AVG'
END avg_change
FROM yearly_product_sale
ORDER BY product_name, order_year;

-- pervious year comparision
WITH yearly_product_sale AS(
	SELECT 
		YEAR (f.order_date) as order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sale
	FROM Cash.fact_sales f
	LEFT JOIN Cash.dim_products p
		ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY 
		YEAR (f.order_date),
		p.product_name
)

SELECT
order_year,
product_name,
current_sale,
AVG(current_sale) OVER (PARTITION BY product_name) AS avg_sale,
current_sale - AVG(current_sale) OVER (PARTITION BY product_name) AS diff_avg,
CASE WHEN current_sale - AVG(current_sale) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
	WHEN current_sale - AVG(current_sale) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
	ELSE 'AVG'
END avg_change,
LAG (current_sale) OVER ( PARTITION BY product_name ORDER BY order_year) AS previous_sale,
current_sale - LAG (current_sale) OVER ( PARTITION BY product_name ORDER BY order_year) AS diff_py_sale,
CASE WHEN current_sale - LAG (current_sale) OVER ( PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increse'
	WHEN current_sale - LAG (current_sale) OVER ( PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrese'
	ELSE 'No Change'
END py_sale_change
FROM yearly_product_sale
ORDER BY product_name, order_year;