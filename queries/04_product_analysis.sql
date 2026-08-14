-- Business Question:
-- What are the top 10 products by revenue generated?
-- Purpose: identify star products that drive the most business —
-- useful for prioritizing restocking or marketing focus.

SELECT 
    p.id, 
    p.product_name, 
    p.standard_cost, 
    p.category, 
    -- Net revenue per product = (qty * unit price) minus the discount percentage applied
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_amount
FROM products p 
INNER JOIN order_details od 
    ON p.id = od.product_id 
GROUP BY p.id, p.product_name, p.standard_cost, p.category
ORDER BY total_amount DESC
LIMIT 10;