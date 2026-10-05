--Which product categories generate the most revenue

SELECT
    SUM(order_item.unit_price * order_item.quantity) AS total_product_revenue,
    categories.category_name
FROM order_item
INNER JOIN product ON order_item.product_id = product.product_id
INNER JOIN categories on product.category_id = categories.category_id
GROUP BY categories.category_name
ORDER BY total_product_revenue DESC;

--Customers who haven't ordered recently (or at all)

SELECT
    customers.customer_id,
    COUNT(orders.order_id) AS num_of_orders
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id AND orders.order_date >= NOW() - INTERVAL '6 months'
GROUP BY customers.customer_id
ORDER BY num_of_orders ASC;

--Top 10 purchased items

SELECT
    product.name,
    SUM(order_item.quantity) AS sum_of_quantity_ordered
FROM product
LEFT JOIN order_item ON product.product_id = order_item.product_id
GROUP BY product.name
ORDER BY sum_of_quantity_ordered DESC LIMIT 10;

-- Highest revenue generating product

SELECT
    total_product_revenue AS highest_revenue,
    product_name
FROM (
    SELECT
        product.name AS product_name,
        SUM(order_item.unit_price * order_item.quantity) AS total_product_revenue
    FROM order_item
    INNER JOIN product ON order_item.product_id = product.product_id
    GROUP BY product.name
    ORDER BY total_product_revenue DESC
    ) AS subquery_table
ORDER BY highest_revenue DESC
LIMIT 1;

