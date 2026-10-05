
SELECT gender, COUNT(customer_id) AS gender_count
FROM customers
GROUP BY gender
ORDER BY gender_count DESC;

SELECT 
    EXTRACT(YEAR FROM NOW()) - EXTRACT(YEAR FROM date_of_birth) AS customer_age, COUNT(customer_id) AS customer_count
FROM customers
GROUP BY customer_age
ORDER BY customer_count DESC;

SELECT
    COUNT(orders.order_id) AS num_of_orders,
    Customer_Addresses.city
FROM Orders
INNER JOIN Customer_Addresses ON orders.address_id = Customer_Addresses.address_id
GROUP BY Customer_Addresses.city
ORDER BY num_of_orders DESC;

SELECT
    AVG(order_total) AS avg_revenue,
    subquery_table.payment_method
FROM (SELECT
        SUM(order_item.unit_price * order_item.quantity) AS order_total,
        orders.payment_method
    FROM orders
    INNER JOIN Order_Item ON orders.order_id = Order_Item.order_id
    GROUP BY orders.order_id
    ) AS subquery_table
GROUP BY subquery_table.payment_method;
