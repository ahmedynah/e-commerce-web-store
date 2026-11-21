# Mock CSV imports

These files form a single synthetic dataset of 1,000 rows per table. Import them
into an empty database after running
[`create-ecommerce-product-0203-21-01-2026.sql`](../sql/create-ecommerce-product-0203-21-01-2026.sql).
Do not also run the seed script: its IDs overlap with this dataset. Customer
passwords are nonfunctional placeholders and must not be used for authentication.

Start `psql` from this CSV folder, then run the following commands in order.
The quoted table name `"Order"` is
case-sensitive. The space before `.csv` in the order items filename is intentional.

```sql
\copy category FROM 'CAT_MOCK_DATA.csv' WITH (FORMAT csv, HEADER true)
\copy customer FROM 'CUSTOMER_MOCK_DATA.csv' WITH (FORMAT csv, HEADER true)
\copy product FROM 'PRODUCT_MOCK_DATA.csv' WITH (FORMAT csv, HEADER true)
\copy discount FROM 'DISCOUNT.csv' WITH (FORMAT csv, HEADER true)
\copy productcategory FROM 'ProductCategory_MOCK_DATA.csv' WITH (FORMAT csv, HEADER true)
\copy "Order" FROM 'ORDER_MOCK_DATA.csv' WITH (FORMAT csv, HEADER true)
\copy orderitem FROM 'ORDER_ITEMS_MOCK_DATA .csv' WITH (FORMAT csv, HEADER true)
\copy orderdiscount FROM 'ORDER_DISCOUNT_MOCK_DATA.csv' WITH (FORMAT csv, HEADER true)
\copy customerdiscount FROM 'CUSTOMER_DISCOUNT_MOCK_DATA.csv' WITH (FORMAT csv, HEADER true)
\copy comment FROM 'COMMENT.csv' WITH (FORMAT csv, HEADER true)
```

`\copy` reads files from the client machine, not the database server. Empty CSV
fields are imported as SQL `NULL`.
