-- EX1: leetcode - immediate-food-delivery-ii
SELECT round(avg(order_date = customer_pref_delivery_date) * 100 , 2) AS immediate_percentage
FROM Delivery 
WHERE (customer_id, order_date) in (
    SELECT customer_id, min(order_date)
    FROM delivery
    group by customer_id
)

-- EX2: leetcode-game-play-analysis-iv
SELECT round(count(distinct player_id) / (select count(distinct player_id) from activity), 2) AS fraction
FROM activity
WHERE (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
IN (SELECT player_id, min(event_date) AS first_long 
    FROM activity 
    group by player_id)

-- EX3: leetcode - exchange-seats
SELECT 
    CASE 
        WHEN id % 2 = 1 AND id + 1 IN (SELECT id FROM seat) THEN id + 1
        WHEN id % 2 = 0 THEN id - 1
        ELSE id
    END AS id, student
FROM seat
ORDER BY id


-- EX4: leetcode - restaurant-growth
SELECT DISTINCT 
        visited_on,
        SUM(amount) OVER(ORDER BY visited_on RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW) AS amount,
        ROUND(SUM(amount) OVER(ORDER BY visited_on RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW) / 7, 2) average_amount 
FROM customer
LIMIT 1000000
OFFSET 6

-- EX5: leetcode -investments-in-2016
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance 
WHERE tiv_2015 in (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
) and (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    group by lat, lon
    HAVING count(*) = 1 
)













