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

















