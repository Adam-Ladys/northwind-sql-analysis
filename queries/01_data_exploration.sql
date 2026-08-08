--          Northwind SQL Business Analysis 
--          SECTION 01: Data Exploration  


-- Business Question:
-- Identify customers where the main contact is the company owner.

SELECT id, last_name, first_name, job_title, business_phone, city
FROM customers
WHERE job_title = 'Owner';

-- Count all customers.

SELECT COUNT(*) AS Total_Customers
FROM customers;

-- Total orders (Count all orders).

SELECT COUNT(*) AS Total_Orders
FROM orders;

-- Number of products by category.

SELECT category, COUNT(*) AS total_products
FROM products 
GROUP BY category;

-- Identify customers in Seattle.

SELECT first_name, last_name, company, job_title, address, city
FROM customers 
WHERE city = 'Seattle';

-- Count all customers by city.

SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city;