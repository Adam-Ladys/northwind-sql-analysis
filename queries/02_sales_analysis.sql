--- SECTION 02: Sales Analysis


-- Business Question:
-- What are the 5 highest-value orders (net of discounts)?
-- Purpose: identify Northwind's biggest single transactions, 
-- useful for spotting VIP orders or key account patterns.

SELECT 
    o.id,
    -- Net revenue per order = (qty * unit price) minus the discount percentage applied
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_amount
FROM orders o 
INNER JOIN order_details od 
    ON o.id = od.order_id 
GROUP BY o.id
ORDER BY total_amount DESC
LIMIT 5;


-- Business Question:
-- How has revenue evolved month by month, across all years?
-- Purpose: identify sales trends and seasonality over time —
-- useful for spotting growth periods, slow months, or seasonal patterns.

SELECT 
    -- Net revenue per order = (qty * unit price) minus the discount percentage applied
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_amount,
    -- Format as YYYY-MM: numeric format ensures chronological sort order
    -- (unlike month names, e.g. "August" would sort before "July" alphabetically)
    DATE_FORMAT(o.order_date, '%Y-%m') AS period
FROM orders o 
INNER JOIN order_details od 
    ON o.id = od.order_id 
GROUP BY period 
ORDER BY period;

-- Business Question:
-- Which country generates the most revenue for Northwind Traders?
-- Purpose: identify the top-performing geographic market,
-- useful for prioritizing regional sales/marketing efforts.

SELECT 
    c.country_region, 
    -- Net revenue = (qty * unit price) minus the discount percentage applied
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_amount
FROM customers c  
INNER JOIN orders o 
    ON c.id = o.customer_id 
INNER JOIN order_details od
    ON od.order_id = o.id 
GROUP BY c.country_region
ORDER BY total_amount DESC 
LIMIT 1;

-- Business Question:
-- What is the average order value (basket size)?
-- Purpose: understand typical transaction value — helps decide whether
-- commercial efforts should target more customers or bigger baskets.

WITH total AS (
    SELECT 
        o.id,
        -- Net revenue per order = (qty * unit price) minus the discount percentage applied
        SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_amount
    FROM orders o 
    INNER JOIN order_details od 
        ON o.id = od.order_id 
    GROUP BY o.id 
) 
SELECT AVG(total_amount) AS average_amount 
FROM total;