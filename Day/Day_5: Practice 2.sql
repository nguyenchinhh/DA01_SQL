-- EX1: hackerank-weather-observation-station-3
SELECT DISTINCT city
FROM station 
WHERE MOD(ID, 2) = 0

-- EX2: hackerank-weather-observation-station-4
SELECT COUNT(city) - COUNT(DISTINCT city)
FROM station

-- EX3: hackerank-the-blunder
SELECT CEIL(AVG(salary) - AVG(REPLACE(salary, 0, '')))
FROM employees

-- EX4: datalemur-alibaba-compressed-mean
SELECT ROUND(SUM(item_count::DECIMAL * order_occurrences) / SUM(order_occurrences),1) AS mean
FROM items_per_order


-- EX5: datalemur-matching-skills
SELECT DISTINCT candidate_id
FROM candidates
WHERE skill IN ('Pyhon', 'Tabluau', 'PostgreSQL')
 
-- EX6: datalemur-verage-post_hiatus_1
SELECT DISTINCT user_id,
      DATE_PART('day', MAX(post_date) - MIN(post_date)) AS days_between
FROM posts
WHERE EXTRACT(YEAR FROM post_date) = 2021
GROUP BY user_id 
HAVING count(*) > 1

-- EX7: datalemur-cards-issued-difference.
SELECT DISTINCT card_name, 
        MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued 
GROUP BY card_name


-- EX8: datalemur-non-profitable-drugs
SELECT manufacturer,
      COUNT(drug),
      ABS(SUM(cogs - total_sales)) AS total_Loss
FROM pharmacy_sales 
WHERE total_sales - cogs <= 0
GROUP BY manufacturer
ORDER BY total_loss DESC 

-- EX9: leetcode-not-boring-movies
SELECT *
FROM cinema
WHERE id % 2 != 0 AND description != 'boring'
ORDER BY id DESC


-- EX10: leetcode-number-of-unique-subject 
SELECT DISTINCT teacher_id, COUNT( DISTINCT subject_id) AS cnt
FROM teacher 
GROUP BY teacher_id


-- EX11: leetcode-find-followers-count
SELECT DISTINCT user_id, COUNT(follower_id) AS followers_count
FROM followers 
GROUP BY user_id 

-- EX12: leetcode-Classes More Than 5 Students
SELECT  class
FROM courses
GROUP BY class
HAVING COUNT(student) > 5














