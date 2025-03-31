-- EX1: datalemur - yoy-growth-rate
SELECT EXTRACT(YEAR FROM transaction_date) AS year,
      product_id,
      spend AS current_year_spend,
      LAG(spend) OVER(PARTITION BY product_id) AS prev_year_spend,
      ROUND((spend - LAG(spend) OVER(PARTITION BY product_id)) / LAG(spend) OVER(PARTITION BY product_id) * 100,2) AS yoy_rate
FROM user_transactions 





























































