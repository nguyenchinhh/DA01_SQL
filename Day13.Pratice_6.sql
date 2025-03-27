-- EX1. datalumer-duplicate-job-listings
SELECT COUNT(*) -  COUNT(DISTINCT company_id || description)
FROM job_listings  

-- EX2. datalumer-srql-highest-grossing
WITH product AS (
SELECT category, product,
      SUM(spend) AS total_spend,
      RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS ranking
FROM product_spend 
WHERE EXTRACT(year from DATE(transaction_date)) = 2022
GROUP BY 1, 2)

SELECT category, product, total_spend
FROM product
WHERE ranking <= 2


-- EX3: datalemur-frequent-callers
WITH ex1 AS (
    SELECT policy_holder_id 
    FROM callers 
    GROUP BY policy_holder_id
    HAVING COUNT(DISTINCT case_id) >= 3
)
SELECT COUNT(policy_holder_id) AS remember
FROM ex1


-- EX4: datalemur-sql-page-with-no-likes
SELECT a.page_id
FROM pages AS a 
LEFT JOIN page_likes AS b
ON a.page_id = b.page_id
WHERE b.page_id IS NULL
GROUP BY a.page_id
ORDER BY a.page_id ASC


-- EX5: datalemur-user-retention
SELECT EXTRACT(month from event_date),
        COUNT(DISTINCT user_id)
FROM user_actions
WHERE EXTRACT(month from event_date) = 7
      AND user_id IN (SELECT user_id FROM user_actions WHERE EXTRACT(MONTH from event_date) = 6)
GROUP BY 1
ORDER BY 1, 2


-- EX6: leetcode - monthly-transactions      
SELECT 
    CONCAT(EXTRACT(YEAR FROM trans_date), '-', LPAD(EXTRACT(MONTH FROM trans_date), 2, '0')) AS month,
    country,
    COUNT(*) AS trans_count,
    COUNT(CASE WHEN state = 'approved' THEN 1 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY 1, 2;


-- EX7:leetcode - product-sales-analysis
-- SELECT s.product_id, s.year AS first_year, s.quantity, s.price
-- FROM product AS p
-- INNER JOIN sales AS s
-- ON  s.product_id = p.product_id 
-- GROUP BY s.product_id

SELECT 
  product_id, 
  year AS first_year, 
  quantity, 
  price 
FROM Sales 
WHERE (product_id, year) IN (
    SELECT 
      product_id, 
      MIN(year) AS year 
    FROM Sales 
    GROUP BY  product_id
);


-- EX8: leetcode-customers-who-bought-all-products
SELECT customer_id
FROM customer 
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT count(*) from product)

-- EX9: leetcode - employees-whose-manager-left-the-company
SELECT employee_id
FROM Employees 
WHERE salary < 30000 AND manager_id NOT IN(
    SELECT employee_id FROM Employees
)
GROUP BY employee_id
ORDER BY employee_id ASC

-- EX10: datalemur - duplicate-job-listings 
SELECT COUNT(*) - COUNT(DISTINCT company_id || description) AS duplicate_companies
FROM job_listings 


-- EX11: leetcode-movie-rating
-- 1 nửa đầu
WITH ex AS (
    SELECT u.name,
        COUNT(*) AS total
    FROM users AS u
    INNER JOIN MovieRating  AS m
    ON u.user_id = m.user_id      
    GROUP BY u.name
)

SELECT name AS results
FROM ex
WHERE total = (
    SELECT MAX(total) FROM ex
)
GROUP BY name
ORDER BY name
LIMIT 1



-- đúng
(
SELECT name AS results
FROM users 
INNER JOIN MovieRating 
using (user_id)
GROUP BY user_id
ORDER BY COUNT(rating) DESC, name
LIMIT 1
)

UNION ALL 

(
SELECT title AS results
FROM movies AS m
INNER JOIN MovieRating
USING (movie_id)
WHERE MONTH(created_at) = '02' AND YEAR(created_at) = '2020'
GROUP BY title
ORDER BY avg(rating) DESC, title 
LIMIT 1

)


-- EX12: leetcode-friend-requests-ii-who-has-the-most-friends
SELECT id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL 
    SELECT accepter_id  FROM RequestAccepted
) AS AllFriends
GROUP BY id
ORDER BY num DESC 
LIMIT 1
















































