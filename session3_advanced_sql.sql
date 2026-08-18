-- ============================================
-- Session 3 - Advanced SQL
-- Group: 6
-- Role: ETL Developer
-- Subsystem: Orders and Payments
-- ============================================


-- 1. ROW_NUMBER
SELECT
    order_id,
    total_amount,
    ROW_NUMBER() OVER (ORDER BY total_amount DESC) AS row_number
FROM orders;


-- 2. RANK
SELECT
    order_id,
    total_amount,
    RANK() OVER (ORDER BY total_amount DESC) AS order_rank
FROM orders;


-- 3. DENSE_RANK
SELECT
    order_id,
    total_amount,
    DENSE_RANK() OVER (ORDER BY total_amount DESC) AS dense_rank
FROM orders;


-- 4. LAG
SELECT
    order_id,
    total_amount,
    LAG(total_amount) OVER (ORDER BY order_id) AS previous_order_amount
FROM orders
ORDER BY order_id;


-- 5. LEAD
SELECT
    order_id,
    total_amount,
    LEAD(total_amount) OVER (ORDER BY order_id) AS next_order_amount
FROM orders
ORDER BY order_id;


-- 6. CTE #1
-- Orders above the average order amount
WITH avg_order AS (
    SELECT AVG(total_amount) AS avg_amount
    FROM orders
)
SELECT
    order_id,
    total_amount
FROM orders
WHERE total_amount > (SELECT avg_amount FROM avg_order);


-- 7. CTE #2
-- Total payments by payment status
WITH payment_summary AS (
    SELECT
        status,
        SUM(amount) AS total_payment
    FROM payments
    GROUP BY status
)
SELECT *
FROM payment_summary;


-- 8. CTE #3
-- Successful payments with their orders
WITH order_payments AS (
    SELECT
        o.order_id,
        o.total_amount AS order_amount,
        p.amount AS payment_amount,
        p.status AS payment_status
    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
)
SELECT *
FROM order_payments
WHERE payment_status = 'successful';


-- 9. ROLLUP
SELECT
    status,
    SUM(amount) AS total_amount
FROM payments
GROUP BY ROLLUP(status);


-- 10. EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT
    o.order_id,
    o.total_amount,
    p.amount,
    p.status
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id;