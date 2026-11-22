-- An SQL query to generate a daily report of the total revenue for a specific date.
SELECT :start_date::date as "Day", COUNT(1) as "Quantity Sold", SUM(ord.order_total_cost) AS "Total Revenue"
FROM orders AS ord
WHERE ord.order_date >= :start_date::timestamp and ord.order_date < :start_date + INTERVAL '1 day';

--==============================================

-- An SQL query to generate a monthly report of the top-selling products in a given month.

SELECT DENSE_RANK() OVER (ORDER BY SUM(oi.product_quantity * prod.product_price) DESC, SUM(oi.product_quantity) DESC) as "Rank", prod.product_name, SUM(oi.product_quantity) as "Quantity Sold", SUM(oi.product_quantity * prod.product_price) as "Total Revenue"
FROM product prod
INNER JOIN order_item oi
USING (product_id) 
WHERE oi.order_date >= :start_date::timestamp AND oi.order_date < :start_date + INTERVAL '1 month'
GROUP BY prod.product_id, prod.product_name
ORDER BY "Rank";

-- The below approach is clearly more readable and maintainable as it uses a CTE to pre-aggregate the top-selling products for the month.
-- This CTE approach helps in breaking down the query into logical steps, making it easier to understand and maintain.
With top_selling_products as (
SELECT oi.product_id, sum(oi.product_quantity) as "Quantity Sold", sum(oi.product_quantity * oi.product_price) as "Total Revenue"
FROM order_item oi
WHERE oi.order_date >= :start_date::timestamp AND oi.order_date < :start_date + INTERVAL '1 month' -- BETWEEN :start_date AND :start_date + INTERVAL '1 month' can lead to double counting orders on the boundary date for the next months when reporting monthly totals.
GROUP BY oi.product_id
)
SELECT DENSE_RANK() OVER (ORDER BY tsp."Total Revenue" DESC, tsp."Quantity Sold" DESC) as "Rank", p.product_id, p.product_name, tsp."Quantity Sold", tsp."Total Revenue"
FROM product p
INNER JOIN top_selling_products tsp
USING(product_id)
ORDER BY "Rank";

--==============================================

-- An SQL query to retrieve a list of customers who have placed orders totaling more than $500 in the past month, 
-- include customer names and their total order amounts.
SELECT cst.customer_name, ord.total_spent
FROM (
    -- Subquery to calculate total spent per customer in the past month, note this is a standard query not a correlated one.
    SELECT o.order_customer_id, sum(o.order_total_cost) as total_spent
    FROM orders o
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 month'
    GROUP BY o.order_customer_id
    HAVING SUM(o.order_total_cost) > 500
) ord
INNER JOIN customer cst
    ON ord.order_customer_id = cst.customer_id;
--- This is a more readable and maintainable approach using a CTE (Common Table Expression) to pre-aggregate the order totals per customer for the past month, while giving equal performance benefits as the subquery approach.
WITH monthly_customer_totals AS (
    SELECT o.order_customer_id, SUM(o.order_total_cost) AS total_spent
    FROM orders o
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 month'
    GROUP BY o.order_customer_id
    HAVING SUM(o.order_total_cost) > 500
)
SELECT cst.customer_name, mct.total_spent
FROM monthly_customer_totals mct
INNER JOIN customer cst
    ON mct.order_customer_id = cst.customer_id;

-- The above query can be optimized if a materialized view or a temporary table is used to pre-aggregate the order totals per customer for the past month.
-- For example, a materialized view could be created as follows:
-- CREATE MATERIALIZED VIEW monthly_customer_totals AS
-- SELECT o.customer_id, SUM(o.order_total_cost) AS total_spent
-- FROM orders o
-- WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 month'
-- GROUP BY o.customer_id
-- HAVING SUM(o.order_total_cost) > 500;

-- Denormalized approach can also be used, where the order totals per customer for the past month are calculated on the fly without using a materialized view.
SELECT sh.customer_name, SUM(sh.product_quantity) as "Quantity Sold", SUM(sh.product_quantity * sh.product_price) as "Total Revenue", CURRENT_DATE as "Report Date"
FROM sale_history sh
WHERE sh.order_date >= (CURRENT_DATE - INTERVAL '1 MONTH')::date AND sh.order_date < CURRENT_DATE
GROUP BY sh.order_id, sh.customer_name
HAVING SUM(sh.product_quantity * sh.product_price) > 0;

--==============================================
-- List the number of orders placed by each customer in the past month, including customer names and order counts, handle cash customers whose data may not be in the customer table.
-- This query is not best option for performance with large datasets as it checks the orders table twice, and can lead to subtle errors when a month with no cash customers exists.
SELECT 
    cst.customer_name,
    COUNT(*) AS order_count,
    SUM(ord.order_total_cost) AS total_spent
FROM orders ord
Inner join customer cst
    ON ord.order_customer_id = cst.customer_id
WHERE ord.order_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY cst.customer_name, ord.order_customer_id
UNION ALL
SELECT 
    'Cash Customer' AS customer_name,
    COUNT(*) AS order_count,
    SUM(ord.order_total_cost) AS total_spent
FROM orders ord
WHERE ord.order_customer_id IS NULL
  AND ord.order_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY 'Cash Customer';

-- SAFER and more accurate approach to include cash customers in the order count and total spent report.
SELECT COALESCE(cst.customer_name, 'Cash Customer') AS customer_name, COUNT(*) AS order_count, SUM(ord.order_total_cost) AS total_spent
FROM orders ord
LEFT JOIN customer cst
    ON ord.order_customer_id = cst.customer_id
WHERE ord.order_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY customer_name, ord.order_customer_id
order by total_spent DESC;