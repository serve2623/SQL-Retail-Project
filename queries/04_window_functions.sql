--Month-over-month revenue trends

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

--Largest orders (by value or item count) — RANK() 

WITH value_cte AS (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS total_revenue
    FROM order_item
    GROUP BY order_id
),

item_cte AS (
    SELECT
        order_id,
        SUM(quantity) AS total_quantity_items
    FROM order_item
    GROUP BY order_id
)

SELECT
    value_cte.order_id,
    value_cte.total_revenue,
    RANK() OVER( ORDER BY value_cte.total_revenue DESC) AS value_rank,
    item_cte.total_quantity_items,
    RANK() OVER( ORDER BY item_cte.total_quantity_items DESC) AS quantity_rank
FROM value_cte
INNER JOIN item_cte ON value_cte.order_id = item_cte.order_id;

--How new products are performing versus others in their category 

WITH six_months_cte AS (
    SELECT
        subquery_6_months.name,
        categories.category_name,
        subquery_6_months.created_at,
        SUM(order_item.quantity * order_item.unit_price) AS total_revenue_by_product
    FROM (SELECT
            *
            FROM product
        WHERE created_at > NOW() - interval '6 months') AS subquery_6_months
    INNER JOIN categories ON subquery_6_months.category_id = categories.category_id
    INNER JOIN order_item ON subquery_6_months.product_id = order_item.product_id
    GROUP BY subquery_6_months.name, categories.category_name, subquery_6_months.created_at
),

average_category_performance AS (
    SELECT
        subquery_total_revenue.category_name,
        (total_revenue_in_category / total_number_products_in_category) AS avg_revenue_in_category
    FROM (SELECT
            COUNT(DISTINCT order_item.product_id) AS total_number_products_in_category,
            categories.category_name,
            SUM(order_item.quantity * order_item.unit_price) AS total_revenue_in_category
          FROM order_item
          INNER JOIN product ON order_item.product_id = product.product_id
          INNER JOIN categories ON product.category_id = categories.category_id
          GROUP BY categories.category_name) AS subquery_total_revenue
)

SELECT
    six_months_cte.name,
    six_months_cte.total_revenue_by_product,
    average_category_performance.avg_revenue_in_category,
    six_months_cte.total_revenue_by_product - average_category_performance.avg_revenue_in_category AS product_performance_vs_category
FROM six_months_cte
INNER JOIN average_category_performance ON six_months_cte.category_name = average_category_performance.category_name
ORDER BY product_performance_vs_category DESC;

--Which customers buy most frequently — good candidate for RANK() within groups (e.g. by city)

with purchase_cte AS(
    SELECT
        orders.customer_id,
        customer_addresses.city,
        COUNT(DISTINCT orders.order_id) AS total_number_of_orders
    FROM orders
    INNER JOIN customer_addresses ON orders.address_id = customer_addresses.address_id
    GROUP BY orders.customer_id, customer_addresses.city
)

SELECT
    purchase_cte.customer_id,
    purchase_cte.city,
    purchase_cte.total_number_of_orders,
    RANK() OVER (ORDER BY purchase_cte.total_number_of_orders DESC) AS order_rank
FROM purchase_cte
ORDER BY order_rank ASC;


