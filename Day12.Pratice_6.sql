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















































