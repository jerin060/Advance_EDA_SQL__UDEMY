-- Which catagories contributes the most to overall sales?
WITH Category_per_sale AS (
	SELECT 
		ps.category,
		SUM(fs.sales_amount) AS total_sale
	FROM Cash.fact_sales fs
	LEFT JOIN Cash.dim_products ps
	ON fs.product_key = ps.product_key
	GROUP BY ps.category
	)

SELECT 
category,
total_sale,
SUM(total_sale) OVER () AS overall_sales,
CONCAT(ROUND((CAST(total_sale AS FLOAT) / SUM(total_sale) OVER ()) * 100, 2), '%') AS percentage_of_sale
FROM Category_per_sale
ORDER BY total_sale DESC