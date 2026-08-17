CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    store_id INTEGER NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    discount NUMERIC(12,2) DEFAULT 0 CHECK (discount >= 0)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    payment_method VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    transaction_code VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0),
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO orders
(user_id, store_id, total_amount, status)
VALUES
(1, 1, 125000, 'pending'),
(2, 1, 85000, 'paid'),
(3, 2, 240000, 'processing'),
(4, 2, 175000, 'shipped'),
(5, 3, 99000, 'delivered'),
(6, 3, 310000, 'paid'),
(7, 1, 45000, 'cancelled'),
(8, 2, 180000, 'pending'),
(9, 3, 275000, 'processing'),
(10, 1, 120000, 'delivered');


INSERT INTO order_items
(order_id, product_id, quantity, unit_price, discount)
VALUES
(1, 1, 2, 50000, 0),
(2, 2, 1, 85000, 5000),
(3, 3, 3, 80000, 10000),
(4, 4, 1, 175000, 0),
(5, 5, 2, 55000, 11000),
(6, 6, 2, 160000, 10000),
(7, 7, 1, 45000, 0),
(8, 8, 2, 90000, 0),
(9, 9, 1, 275000, 25000),
(10, 10, 2, 60000, 0);


INSERT INTO payments
(order_id, amount, payment_method, status, transaction_code)
VALUES
(1, 125000, 'card', 'successful', 'TXN1001'),
(2, 85000, 'card', 'successful', 'TXN1002'),
(3, 240000, 'online', 'successful', 'TXN1003'),
(4, 175000, 'card', 'successful', 'TXN1004'),
(5, 99000, 'online', 'successful', 'TXN1005'),
(6, 310000, 'card', 'successful', 'TXN1006'),
(7, 45000, 'online', 'failed', 'TXN1007'),
(8, 180000, 'card', 'pending', 'TXN1008'),
(9, 275000, 'online', 'successful', 'TXN1009'),
(10, 120000, 'card', 'successful', 'TXN1010');


INSERT INTO invoices
(order_id, invoice_number, total_amount)
VALUES
(1, 'INV-1001', 125000),
(2, 'INV-1002', 85000),
(3, 'INV-1003', 240000),
(4, 'INV-1004', 175000),
(5, 'INV-1005', 99000),
(6, 'INV-1006', 310000),
(7, 'INV-1007', 45000),
(8, 'INV-1008', 180000),
(9, 'INV-1009', 275000),
(10, 'INV-1010', 120000);

SELECT
    o.order_id,
    o.total_amount AS order_amount,
    p.amount AS payment_amount,
    p.status AS payment_status,
    i.invoice_number
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
JOIN invoices i
    ON o.order_id = i.order_id;