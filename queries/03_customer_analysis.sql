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