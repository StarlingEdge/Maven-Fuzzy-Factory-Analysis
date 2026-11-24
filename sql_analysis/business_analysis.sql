--- Business Analysis SQL Queries --
SELECT *
FROM read_csv_auto('../data/orders.csv')
LIMIT 5;

-- Revenue and Gross Profit Analysis --
 SELECT
    SUM(price_usd) AS total_revenue,
    SUM(cogs_usd) AS total_cogs,
    SUM(price_usd) - SUM(cogs_usd) AS gross_profit
FROM read_csv_auto('../data/orders.csv');

-- Product performance--
SELECT
    primary_product_id,
    COUNT(order_id) AS total_orders,
    SUM(price_usd) AS revenue,
    SUM(cogs_usd) AS total_cogs,
    SUM(price_usd) - SUM(cogs_usd) AS gross_profit
FROM read_csv_auto('../data/orders.csv')
GROUP BY primary_product_id
ORDER BY revenue DESC;

-- Customer segmentation analysis --
SELECT
    COUNT(DISTINCT user_id) AS total_customers,
    COUNT(order_id) AS total_orders
FROM read_csv_auto('../data/orders.csv');

--Monthly revenue trend--
SELECT
    DATE_TRUNC('month', created_at) AS month,
    SUM(price_usd) AS monthly_revenue
FROM read_csv_auto('../data/orders.csv')
GROUP BY month
ORDER BY month;

--Average order value (AOV) analysis--
SELECT
    AVG(price_usd) AS average_order_value
FROM read_csv_auto('../data/orders.csv');

-- Customer retention analysis --
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        user_id,
        COUNT(order_id) AS total_orders
    FROM read_csv_auto('../data/orders.csv')
    GROUP BY user_id
    HAVING COUNT(order_id) > 1
) AS customer_orders;

--Website traffic and conversion analysis--
SELECT
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.website_session_id) AS converted_sessions,
    ROUND(
        COUNT(DISTINCT o.website_session_id) * 100.0 /
        COUNT(DISTINCT ws.website_session_id), 2
    ) AS conversion_rate

FROM read_csv_auto('../data/website_sessions.csv') AS ws

LEFT JOIN read_csv_auto('../data/orders.csv') AS o
    ON ws.website_session_id = o.website_session_id;
