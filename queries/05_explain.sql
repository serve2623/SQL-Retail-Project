--Top 10 purchased items (from 02_joins)

EXPLAIN ANALYZE
SELECT
    product.name,
    SUM(order_item.quantity) AS sum_of_quantity_ordered
FROM product
LEFT JOIN order_item ON product.product_id = order_item.product_id
GROUP BY product.name
ORDER BY sum_of_quantity_ordered DESC LIMIT 10;


--Month-over-month revenue trends (from 04.window_functions)

EXPLAIN ANALYZE
WITH month_cte AS (
    SELECT
        EXTRACT(YEAR FROM orders.order_date) AS OrderYear,
        EXTRACT(MONTH FROM orders.order_date) AS OrderMonth,
        SUM(order_item.quantity * order_item.unit_price) AS month_revenue
    FROM order_item
    INNER JOIN orders ON order_item.order_id = orders.order_id
    GROUP BY OrderYear, OrderMonth
)

SELECT
    *,
    month_revenue - previous_month_revenue AS monthly_trend
FROM (SELECT
        *,
        LAG(month_revenue) OVER (ORDER BY OrderYear ASC, OrderMonth ASC) AS previous_month_revenue
      FROM month_cte
) AS subquery_table
ORDER BY OrderYear ASC, OrderMonth ASC;