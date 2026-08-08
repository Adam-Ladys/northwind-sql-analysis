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

