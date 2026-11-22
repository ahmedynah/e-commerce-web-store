CREATE TABLE IF NOT EXISTS category_subcategory (
  category_subcategory_id BIGINT PRIMARY KEY,
  category_id BIGINT NOT NULL,
  subcategory_id BIGINT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES category(category_id),
  FOREIGN KEY (subcategory_id) REFERENCES category(category_id)
);

CREATE INDEX IF NOT EXISTS idx_category_subcategory_category_id ON category_subcategory(category_id);
CREATE INDEX IF NOT EXISTS idx_category_subcategory_subcategory_id ON category_subcategory(subcategory_id);