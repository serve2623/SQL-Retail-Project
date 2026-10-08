--Order totals

CREATE VIEW order_totals AS
SELECT 
    order_id,
    SUM(quantity * unit_price) AS total_value,
    SUM(quantity) AS total_units_purchased
FROM order_item
GROUP BY order_id;


--Order details

CREATE VIEW order_details AS
SELECT
    order_item.order_item_id,
    order_item.order_id,
    order_item.product_id,
    order_item.quantity,
    order_item.unit_price AS price_at_purchase,
    orders.customer_id,
    orders.order_date,
    orders.address_id,
    orders.delivery_status,
    orders.payment_status,
    orders.payment_method,
    product.name,
    product.category_id,
    product.product_status,
    product.created_at,
    product.unit_price AS current_unit_price,
    categories.category_name
FROM order_item
INNER JOIN orders ON order_item.order_id = orders.order_id
INNER JOIN product ON order_item.product_id = product.product_id
INNER JOIN categories ON product.category_id = categories.category_id;


--Product revenue

CREATE OR REPLACE VIEW product_revenue AS
SELECT
    product.product_id,
    product.name,
    product.product_status,
    COALESCE(SUM(order_item.quantity * order_item.unit_price), 0) AS total_product_revenue,
    COALESCE(SUM(order_item.quantity), 0) AS units_sold
FROM product
LEFT JOIN order_item ON product.product_id = order_item.product_id
GROUP BY product.product_id, product.name, product.product_status;