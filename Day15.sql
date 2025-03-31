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


























































