-- ============================================
-- Session 4 - Index Optimization
-- Group: 6
-- Role: ETL Developer
-- ============================================

-- 1. Indexes created

CREATE INDEX idx_payments_order_id
ON payments(order_id);

CREATE INDEX idx_invoices_order_id
ON invoices(order_id);

CREATE INDEX idx_orders_status
ON orders(status);

CREATE INDEX idx_payments_status
ON payments(status);

CREATE INDEX idx_order_items_order_id
ON order_items(order_id);

CREATE INDEX idx_orders_total_amount
ON orders(total_amount);

CREATE INDEX idx_orders_status_amount
ON orders(status, total_amount);

CREATE INDEX idx_payments_amount
ON payments(amount);

CREATE INDEX idx_order_items_product_id
ON order_items(product_id);

-- invoice_number already has a UNIQUE index,
-- so no duplicate index is required.


-- 2. Partial Index

CREATE INDEX idx_payments_successful_partial
ON payments(order_id)
WHERE status = 'successful';


-- 3. EXPLAIN ANALYZE results
--
-- Query 1: 2.230 ms -> 0.054 ms
-- Improvement: approximately 97.6%
--
-- Query 2: 0.349 ms -> 0.046 ms
-- Improvement: approximately 86.8%
--
-- Query 3: 0.121 ms -> 0.065 ms
-- Improvement: approximately 46.3%
--
-- Query 4: 0.034 ms -> 0.024 ms
-- Improvement: approximately 29.4%
--
-- Query 5: 1.023 ms -> 0.094 ms
-- Improvement: approximately 90.8%
--
-- Average improvement: approximately 70.2%