-- Order Item

CREATE INDEX IF NOT EXISTS idx_order_id_product_id
ON order_item(product_id);

-- Customer ID

CREATE INDEX IF NOT EXISTS idx_orders_customer_id
ON orders(customer_id);

-- Order Dates

CREATE INDEX IF NOT EXISTS idx_orders_order_date
ON orders(order_date);