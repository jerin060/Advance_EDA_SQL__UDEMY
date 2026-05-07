/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
CREATE VIEW Cash.product_report AS
WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from sales and product table
---------------------------------------------------------------------------*/
SELECT
f.order_number,
f.customer_key,
f.order_date,
f.quantity,
f.sales_amount,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM Cash.fact_sales f
LEFT JOIN Cash.dim_products p
ON f.product_key = p.product_key
WHERE F.order_date is not null),

product_aggregation AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        count(distinct order_number) AS total_order,
        SUM(sales_amount) AS total_sale,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customer,
        
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY 
        product_key,
        product_name,
        category,
        subcategory,
        cost)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_month,
    CASE
        WHEN total_sale >= 5000 THEN 'High-Performers'
        WHEN total_sale >= 1000 THEN 'Mid-Range'
        ELSE 'low'
    END AS product_segment,
    lifespan,
    total_order,
    total_sale,
    total_quantity,
    total_customer,
    avg_selling_price,
    -- Average Order Revenue (AOR)
    CASE
        WHEN total_order = 0 THEN 0
        ELSE total_sale / total_order
    END AS avg_order_revenue,
    -- Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sale
        ELSE total_sale / lifespan
    END AS avg_monthly_revenue
FROM product_aggregation