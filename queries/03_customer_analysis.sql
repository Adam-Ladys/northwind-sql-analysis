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

-- Business Question:
-- Which customers place the most orders but have a low average
-- basket size (many small orders rather than few large ones)?
-- Purpose: distinguish "volume" customers from "value" customers —
-- volume customers may respond well to loyalty offers, while
-- low-basket customers are good targets for cross-selling to
-- increase order size.
-- Note: sorted by order count (desc) then average basket (asc),
-- since this is a relative ranking rather than a fixed threshold —
-- no arbitrary cutoff for "high" order count or "low" basket exists.

WITH sum_amout AS (
    SELECT 
        c.id, 
        SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_amount
    FROM orders o
    INNER JOIN customers c ON c.id = o.customer_id 
    INNER JOIN order_details od ON o.id = od.order_id 
    GROUP BY c.id
),
count_orders AS (
    SELECT 
        c.id, 
        COUNT(o.id) AS nber_of_orders 
    FROM customers c 
    INNER JOIN orders o ON c.id = o.customer_id 
    GROUP BY c.id
)
SELECT 
    c.company, c.last_name, c.first_name, c.job_title, 
    -- Average basket per customer = total revenue / number of orders
    sa.total_amount / co.nber_of_orders AS average_buy
FROM customers c 
INNER JOIN sum_amout sa ON c.id = sa.id
INNER JOIN count_orders co ON co.id = c.id 
ORDER BY co.nber_of_orders DESC, average_buy ASC;