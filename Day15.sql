-- EX1: datalemur - yoy-growth-rate
SELECT EXTRACT(YEAR FROM transaction_date) AS year,
      product_id,
      spend AS current_year_spend,
      LAG(spend) OVER(PARTITION BY product_id) AS prev_year_spend,
      ROUND((spend - LAG(spend) OVER(PARTITION BY product_id)) / LAG(spend) OVER(PARTITION BY product_id) * 100,2) AS yoy_rate
FROM user_transactions 


-- EX2: datalemur -card-launch-success

WITH twt_card AS (
    SELECT card_name, issued_amount,
        RANK() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS stt
    FROM monthly_cards_issued 

)
SELECT card_name, issued_amount
FROM twt_card 
WHERE stt = 1
ORDER BY 	issued_amount DESC

-- EX3: datalemur - sql-third-transaction
-- subquert
SELECT user_id, spend, transaction_date
FROM (
  SELECT user_id, spend, transaction_date,
  ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS total
  FROM transactions 
) AS c 
WHERE c.total = 3


-- CTE
WITH twt_user AS (
SELECT user_id, spend, transaction_date,
      ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS total
FROM transactions 
) 
SELECT user_id, spend, transaction_date
FROM twt_user 
WHERE total = 3


-- EX4: datalumer - histogram-users-purchases
WITH ex1 AS (
SELECT transaction_date, user_id, 
      product_id,
      RANK() OVER(PARTITION BY user_id  ORDER BY transaction_date DESC) AS rank1
FROM user_transactions 
)
SELECT transaction_date, user_id, 
      COUNT(product_id) AS purcharse_id
FROM ex1
WHERE rank1 = 1
GROUP BY 1, 2
ORDER BY 1

























































