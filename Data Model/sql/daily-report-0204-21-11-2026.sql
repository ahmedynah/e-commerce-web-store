-- An SQL query to generate a daily report of the total revenue for a specific date.
SELECT ord.order_date as "Day", COUNT(*) as "#", SUM(ord.order_total_cost) AS total_revenue
FROM "Order" AS ord
GROUP BY ord.order_date
HAVING ord.order_date between '2026-12-26' and '2026-12-31'
ORDER BY ord.order_date DESC;

-- An SQL query to generate a monthly report of the top-selling products in a given month.
SELECT prod.product_name, SUM(oi.product_quantity) as sold_quantity, SUM(oi.product_quantity * prod.product_price) as revenue
FROM product prod
INNER JOIN orderitem oi
using product_id 
group by prod.product_name, prod.product_id
order by revenue DESC, sold_quantity DESC;


-- An SQL query to retrieve a list of customers who have placed orders totaling more than $500 in the past month, 
-- include customer names and their total order amounts.
SELECT cst.customer_name, SUM(ord.order_total_cost) AS total_spent
FROM "Order" ord
INNER JOIN Customer cst
    ON ord.order_customer_id = cst.customer_id
WHERE ord.order_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY cst.customer_id, cst.customer_name
HAVING SUM(ord.order_total_cost) > 500;