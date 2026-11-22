-- Adjacency list approach to select subcategories for a given category
SELECT cat.*
FROM category_subcategory cs
INNER JOIN category cat
    ON cs.subcategory_id = cat.category_id;
WHERE cs.category_id = :category_id;

-- Self-referencing approach to select subcategories for a given category
SELECT cat.*
FROM category parent
Inner join category child
ON parent.category_id = child.category_parent_id
WHERE parent.category_id = :category_id;

-- Recursive CTE approach to select subcategories for all categories
WITH RECURSIVE category_tree AS (
    SELECT cat.category_id, cat.category_name, 1 as "Level", cat.category_name::TEXT as "Path" 
    FROM category cat
    WHERE cat.category_parent_id is null
    
    UNION ALL

    SELECT sub.category_id, sub.category_name, ct."Level" + 1, CONCAT(ct."Path", ' > ', sub.category_name :: TEXT) 
    FROM category sub
    INNER JOIN category_tree ct
    on ct.category_id = sub.category_parent_id
)
SELECT * FROM category_tree order by "Level", "Path";