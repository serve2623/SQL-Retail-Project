-- Do customers make repeat purchases of the same items

WITH repeat_purchase_cte AS (
    SELECT
        COUNT(DISTINCT order_item.order_id) AS product_order_count,
        orders.customer_id,
        order_item.product_id
    FROM order_item
    INNER JOIN orders ON order_item.order_id = orders.order_id
    GROUP BY orders.customer_id, order_item.product_id
)    

SELECT
    *
FROM repeat_purchase_cte
WHERE product_order_count >= 2
ORDER BY customer_id ASC;

-- Are there discontinued products worth reviving, based on sales data 

WITH product_status_cte AS (
    SELECT
        product.product_id,
        product.product_status,
        SUM(order_item.quantity) AS total_units_ordered,
        SUM(order_item.quantity * order_item.unit_price) AS total_revenue
    FROM product
    LEFT JOIN order_item on product.product_id = order_item.product_id
    GROUP BY product.product_id
),

rank_discounted_cte AS (
    SELECT
        *,
        RANK() OVER(PARTITION BY product_status_cte.product_status ORDER BY total_revenue DESC) AS rank_discontinued_revenue
    FROM product_status_cte
    WHERE product_status_cte.product_status = 'discontinued'
)

SELECT
    product_status_cte.product_id,
    product.name,
    product_status_cte.product_status,
    product.unit_price,
    product_status_cte.total_units_ordered,
    product_status_cte.total_revenue,
    RANK() OVER(ORDER BY product_status_cte.total_revenue DESC) AS rank_total_revenue,
    rank_discounted_cte.rank_discontinued_revenue
FROM product_status_cte
INNER JOIN product ON product_status_cte.product_id = product.product_id
LEFT JOIN rank_discounted_cte ON product_status_cte.product_id = rank_discounted_cte.product_id
WHERE product_status_cte.total_revenue > (SELECT AVG(product_status_cte.total_revenue) FROM product_status_cte)
ORDER BY rank_total_revenue ASC;