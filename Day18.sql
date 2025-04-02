SELECT * FROM user_data
-- cach1: su dung IQR/ BoxPLOT tìm ra outlier
-- buoc1: Tinh Q1, Q3, IQR
-- buoc2: xac dinh min = Q1-1.5*IQR; max=Q3+1.5*IQR

with twt_min_max_value as (
SELECT Q1-1.5*IQR AS min_value,
Q3+1.5*IQR AS max_value
FROM (
select 
percentile_cont(0.25) WITHIN GROUP (ORDER BY users) AS Q1,
percentile_cont(0.75) WITHIN GROUP (ORDER BY users) AS Q3,
percentile_cont(0.75) WITHIN GROUP (ORDER BY users) - percentile_cont(0.25) WITHIN GROUP (ORDER BY users) AS IQR
from user_data) AS a)

-- buoc3: xac dinh outlier < min hoac > max
SELECT * FROM user_data
WHERE users < (SELECT min_value FROM twt_min_max_value)
or users > (SELECT max_value FROM twt_min_max_value)



-- cach 2: sử dụng Z-SCORE = (users - avg) / stddev
select avg(users),
stddev(users)
from user_data

with cte AS (
select data_date,
		users,
(select avg(users)
from user_data) AS avgs,
(select stddev(users)
from user_data) AS stddev
from user_data)
,twt_outlier AS (
select data_date, users, (users-avgs)/stddev as z_score
from cte
where abs((users-avgs)/stddev) > 3)

UPDATE user_data
SET users = (select avg(users)
from user_data)
WHERE users IN (SELECT users from twt_outlier);


DELETE FROM user_data
WHERE users IN(SELECT users from twt_outlier)




