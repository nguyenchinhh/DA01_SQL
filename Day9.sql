-- EX1: datalemur-laptop-mobile-viewerhip
SELECT 
    SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
    SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

SELECT 
  COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
  COUNT(*) FILTER (WHERE device_type IN ('tablet', 'phone'))  AS mobile_views 
FROM viewership;


-- EX2: datalemur-Triangle Judgement
SELECT x, y, z,
    CASE 
        WHEN x > 0 AND y > 0 AND z > 0 AND x + y > z AND y + z > x AND x + z > y THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM Triangle

-- EX3: datalemur-Patient Support Analysis (Part 2)
SELECT 
  ROUND(CAST(SUM(CASE WHEN call_category IS NULL OR call_category = 'n/a' THEN 1 ELSE 0 END) AS DECIMAL) / COUNT(*) * 100.0,1) AS uncategorised_call_pct
FROM callers;
  
-- cách 2: 
SELECT 
  ROUND(100.0 * SUM(CASE WHEN call_category IS NULL OR call_category = 'n/a' THEN 1 ELSE 0 END) / COUNT(*),1) AS uncategorised_call_pct
FROM callers;



-- EX4:  datalemur Find Customer Referee
SELECT name
FROM customer
WHERE referee_id IS NULL or referee_id != 2

-- EX5: stratascratch Titanic Survivors and Non-Survivors
SELECT survived,
    SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic 
GROUP BY survived






























