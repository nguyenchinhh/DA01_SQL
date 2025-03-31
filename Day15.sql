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



-- EX5: datalumer - rolling-average-tweets
SELECT user_id,
      tweet_date,
      ROUND(AVG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS avg_rank_3d
FROM tweets

--  EX6: datalumer- repeated-payments
WITH payments AS (
SELECT transaction_id,
      merchant_id, 
      credit_card_id,
      amount,
      EXTRACT(
      EPOCH FROM 
      transaction_timestamp - LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount 
      ORDER BY transaction_timestamp)
) / 60 AS minute_diff
FROM transactions )

SELECT COUNT(merchant_id) AS payment_count
FROM payments
WHERE minute_diff <= 10


-- EX7: datalumer-sql-highest-grossing
WITH product AS (
SELECT category,
        product,
        SUM(spend) AS total_spend, RANK() OVER(
          PARTITION BY category ORDER BY SUM(spend) DESC) AS ranking
FROM product_spend 
WHERE EXTRACT(year FROM date(transaction_date)) = 2022
GROUP BY 1, 2)

SELECT category, 
        product, total_spend
FROM product
WHERE ranking <= 2




-- EX8: datalumer-top-fans-rank
WITH top_10 AS (
SELECT a.artist_name,
    DENSE_RANK() OVER(ORDER BY COUNT(s.song_id) DESC) AS rank1
FROM artists AS a 
JOIN songs AS s ON a.artist_id = s.artist_id
JOIN global_song_rank AS g ON g.song_id = s.song_id
WHERE g.rank <= 10
GROUP BY 1
)

SELECT artist_name,
      rank1
FROM top_10
WHERE  rank1 <= 5



















































