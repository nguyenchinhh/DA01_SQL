-- EX1: hackerrank-more-than-75-markds
SELECT name
FROM students
WHERE Marks > 75
ORDER BY RIGHT(name, 3),
ID ASC

-- EX2: leetcode Fix Names in a Table
SELECT user_id, 
    CONCAT(UPPER(LEFT(name,1)),LOWER(SUBSTRING(name FROM 2))) AS name
FROM users

-- EX3: datalemur-total-drugs-sales
SELECT manufacturer,
     '$' || ROUND(SUM(total_sales) / 1000000,0) || ' ' || 'million' AS sale
FROM pharmacy_sales 
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC


-- EX4: datalemur-Avg-review-ratings
SELECT EXTRACT(month FROM submit_date) AS mth,
      product_id AS product,
      ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(month FROM submit_date), product_id
ORDER BY EXTRACT(month FROM submit_date), product_id

-- EX5: datalemur Teams Power Users
SELECT sender_id ,
    COUNT(*) AS message_count
FROM messages
WHERE sent_date >= '2022-08-01' AND sent_date < '2023-09-01'
GROUP BY sender_id 
ORDER BY message_count DESC
LIMIT 2


-- EX6: leetcode invalid tweets
SELECT tweet_id
FROM tweets
WHERE length(content) > 15

-- EX7:leetcode User Activity for the Past 30 Days I
SELECT activity_date AS day,
        COUNT(DISTINCT user_id) AS active_users
FROM activity
WHERE activity_date >= '2019-06-27'
     AND activity_date <= '2019-07-27'
     AND activity_type IN ( 'open_session' ,'send_message','scrolll_down', 'end_session')
GROUP BY activity_date


-- EX8: strataScratch Number of Hires During Specific Time Period
SELECT count(*)
FROM employees
WHERE joining_date >= '2022-01-01' AND joining_date <= '2022-07-01'

-- EX9: strataScratch position-of-letter-a.















































