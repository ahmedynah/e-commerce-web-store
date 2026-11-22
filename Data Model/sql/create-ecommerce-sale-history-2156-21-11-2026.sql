CREATE TABLE IF NOT EXISTS sale_history (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    customer_address VARCHAR(255) NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_quantity INT NOT NULL,
    product_price NUMERIC(10, 2) NOT NULL
);

INSERT INTO sale_history (order_date, customer_id, customer_name, customer_address, product_id, product_name, product_quantity, product_price)
SELECT o.order_date, c.customer_id, c.customer_name, c.customer_address, p.product_id, p.product_name, oi.product_quantity, p.product_price 
FROM orders o
        INNER JOIN order_item oi USING (order_id)
        INNER JOIN product p USING (product_id)
        INNER JOIN customer c USING (customer_id);