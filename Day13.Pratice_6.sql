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


-- EX7: 












































