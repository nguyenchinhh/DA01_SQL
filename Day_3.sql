-- Ex1: Hackerank-revising-the-select-query
SELECT name
FROM city
WHERE population > 120000 
    AND countrycode = 'USA'


-- EX2: Hackerank-japanese-cities-attributes
SELECT *
FROM city
WHERE countrycode = 'JPN'

-- EX3: Hackerank-weather-observation-station-1
SELECT city, state
FROM station

-- EX4: Hackerank-weather-observation-station-6
SELECT city
FROM station
WHERE city LIKE 'e%'
    OR city LIKE 'a%'
    OR city LIKE 'u%'
    OR city LIKE 'o%'
    OR city LIKE 'i%'

-- EX5: Hackerank-weather-observation-station-7
SELECT DISTINCT city
FROM station
WHERE city LIKE '%e'
    OR city LIKE '%a'
    OR city LIKE '%u'
    OR city LIKE '%o'
    OR city LIKE '%i'

-- EX6: Hackerank-weather-observation-station-9
SELECT DISTINCT city
FROM station
WHERE NOT (city LIKE 'a%'
            OR city LIKE 'e%'
            OR city LIKE 'u%'
            OR city LIKE 'o%'
            OR city LIKE 'i%')

-- EX7: Hackerank-name-of-employees
SELECT name 
FROM employee
ORDER BY name ASC

-- EX8: Hackerank-salary-of-employees
SELECT name
FROM employee
WHERE salary > 2000
    AND months < 10
ORDER BY employee_id ASC

-- EX9: leetcode-recyclable-and-low-fat-products
SELECT product_id
FROM products
WHERE low_fats = 'Y'
    AND recyclable = 'Y'

-- EX10: leetcode-Find-Customer-Referee
SELECT name
FROM customer
WHERE referee_id IS NULL 
    OR referee_id != 2

-- EX11: leetcode-big-countries
SELECT name, population, area 
FROM world
WHERE area >= 3000000 OR population >= 25000000

-- EX12: leetcode-article-views-1
SELECT DISTINCT author_id AS id
FROM views 
WHERE author_id = viewer_id
ORDER BY author_id ASC

-- EX13: datalemur-tesla-Unfinished-Parts
SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL

-- EX14: datalemur-lyft-driver-wages
SELECT *
FROM lyft_drivers
WHERE yearly_salary < 30000
    OR yearly_salary >= 70000

-- EX15: datalemur-find-the-advertising-channel
SELECT *
FROM uber_advertising
WHERE money_spent > 100000
    AND year = 2019
    


























