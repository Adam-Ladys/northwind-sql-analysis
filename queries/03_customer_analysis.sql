-- SECTION 03: Customer Analysis


-- Business Question:
-- Who are the top 10 customers by revenue generated?
-- Purpose: identify key accounts that deserve priority attention
-- from sales and account management teams.

SELECT 
    c.id, 
    c.company, 
    c.last_name, 
    c.first_name, 
    -- Net revenue per customer = (qty * unit price) minus the discount percentage applied
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_amount
FROM customers c 
INNER JOIN orders o 
    ON c.id = o.customer_id 
INNER JOIN order_details od 
    ON od.order_id = o.id 
GROUP BY c.id 
ORDER BY total_amount DESC
LIMIT 10;

-- Business Question:
-- How many customers have never placed an order?
-- Purpose: identify inactive customers — useful for re-engagement
-- campaigns or cleaning/qualifying the customer database.

SELECT COUNT(*) AS inactive_clients
FROM customers c 
LEFT JOIN orders o ON c.id = o.customer_id 
WHERE o.customer_id IS NULL;

-- Business Question:
-- What is the average number of orders placed per customer?
-- Purpose: understand customer purchase frequency — a customer who
-- orders often carries more long-term value, even with a smaller basket.

WITH count_orders AS (
    SELECT 
        c.id, 
        COUNT(o.id) AS total_orders
    FROM customers c
    INNER JOIN orders o 
        ON c.id = o.customer_id 
    GROUP BY c.id, c.company, c.last_name, c.first_name, c.job_title
) 
SELECT AVG(total_orders) AS average_total_order
FROM count_orders;

-- Business Question:
-- Which customers have placed no orders in the last 12 months
-- (relative to the most recent order date in the dataset)?
-- Purpose: identify previously active customers who have gone
-- quiet — priority targets for re-engagement, unlike Q2 which
-- targets customers who never ordered at all.

SELECT c.id, c.company, c.last_name, c.first_name, MAX(o.order_date) AS last_order_date
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.company, c.last_name, c.first_name
HAVING MAX(o.order_date) < (SELECT DATE_SUB(MAX(order_date), INTERVAL 12 MONTH) FROM orders);