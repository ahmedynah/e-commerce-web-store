-- Table structure for storing e-commerce product details
CREATE TABLE IF NOT EXISTS product (
  product_id BIGINT PRIMARY KEY,
  product_name VARCHAR(255) NOT NULL,
  product_short_description VARCHAR(255) NOT NULL,
  product_long_description TEXT NOT NULL,
  product_size VARCHAR(50),
  product_color VARCHAR(50),
  product_image_url VARCHAR(255),
  product_weight DECIMAL(10,2),
  product_quantity_on_hand INT Check (product_quantity_on_hand >= 0) NOT NULL,
  product_shipping_cost DECIMAL(10,2) Check (product_shipping_cost >= 0) NOT NULL,
  product_price DECIMAL(10,2) NOT NULL,
  product_status VARCHAR(20) CHECK (product_status IN ('active', 'deleted')) NOT NULL
);

-- Table structure for storing product categories
CREATE TABLE IF NOT EXISTS category (
  category_id BIGINT PRIMARY KEY,
  category_name VARCHAR(255) NOT NULL,
  category_description TEXT,
  category_parent_id BIGINT,
  FOREIGN KEY (category_parent_id) REFERENCES category(category_id)
);

-- Table structure for storing product-category relationships
CREATE TABLE IF NOT EXISTS product_category (
  product_category_id BIGINT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  category_id BIGINT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES product(product_id),
  FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- Table structure for storing customer details
CREATE TABLE IF NOT EXISTS customer (
  customer_id BIGINT PRIMARY KEY,
  customer_name VARCHAR(255) NOT NULL,
  customer_email VARCHAR(255) NOT NULL UNIQUE,
  customer_password VARCHAR(255) NOT NULL,
  customer_address TEXT,
  customer_phone VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS discount (
  discount_id BIGINT PRIMARY KEY,
  discount_code VARCHAR(50) NOT NULL UNIQUE,
  discount_description TEXT,
  discount_amount DECIMAL(10,2) Check (discount_amount >= 0),
  discount_percentage DECIMAL(5,2) Check (discount_percentage >= 0 AND discount_percentage <= 100),
  discount_start_date DATE NOT NULL,
  discount_end_date DATE NOT NULL
);


CREATE TABLE IF NOT EXISTS orders (
  order_id BIGINT PRIMARY KEY,
  order_customer_id BIGINT,
  order_total_shipping_cost DECIMAL(10,2) Check (order_total_shipping_cost >= 0) NOT NULL,
  order_taxes DECIMAL(10,2) Check (order_taxes >= 0),
  order_total_cost DECIMAL(10,2) Check (order_total_cost >= 0) NOT NULL,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE IF NOT EXISTS order_item (
  order_item_id BIGINT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  product_quantity INT Check (product_quantity >= 0) NOT NULL, -- Denormalized approach for storing product quantity at the time of order making use of the fact that orders rarely change historical product quantities.
  product_price DECIMAL(10,2) Check (product_price >= 0) NOT NULL, -- Denormalized approach for storing product price at the time of order making use of the fact that orders rarely change historical product prices.
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Denormalized approach for storing order date at the time of order making use of the fact that orders rarely change historical order dates.
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE IF NOT EXISTS order_discount (
  order_discount_id BIGINT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  discount_id BIGINT NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (discount_id) REFERENCES discount(discount_id)
);

CREATE TABLE IF NOT EXISTS customer_discount (
  customer_id BIGINT NOT NULL,
  discount_id BIGINT NOT NULL,
  PRIMARY KEY (customer_id, discount_id),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY (discount_id) REFERENCES discount(discount_id)
);

-- Table structure for storing product comments
CREATE TABLE IF NOT EXISTS comment (
  comment_id BIGINT PRIMARY KEY,
  comment_product_id BIGINT NOT NULL,
  comment_customer_id BIGINT NOT NULL,
  comment_text TEXT NOT NULL,
  comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (comment_product_id) REFERENCES product(product_id),
  FOREIGN KEY (comment_customer_id) REFERENCES customer(customer_id)
);

-- Indexes for foreign key columns to improve query performance
CREATE INDEX idx_order_item_order_id ON order_item(order_id);
CREATE INDEX idx_order_customer_id ON orders(order_customer_id);
CREATE INDEX idx_order_item_product_id ON order_item(product_id);
CREATE INDEX idx_comment_product_id ON comment(comment_product_id);
CREATE INDEX idx_order_discount_order_id ON order_discount(order_id);
CREATE INDEX idx_comment_customer_id ON comment(comment_customer_id);
CREATE INDEX idx_order_discount_discount_id ON order_discount(discount_id);
CREATE INDEX idx_product_category_product_id ON product_category(product_id);
CREATE INDEX idx_product_category_category_id ON product_category(category_id);
CREATE INDEX idx_customer_discount_discount_id ON customer_discount(discount_id);
CREATE INDEX idx_customer_discount_customer_id ON customer_discount(customer_id);
-- Index for order_item order_date to improve query performance for date-based queries, and the INCLUDE clause helps cover additional columns for faster access, without needing to read the full table rows.
CREATE INDEX idx_order_item_order_date ON order_item(order_date) INCLUDE (product_quantity, product_price);
