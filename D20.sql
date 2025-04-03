/* Bước 1: Khám phá & Làm sạch dữ liệu
- Chúng ta đang quan tâm đến trường nào?
- Check null
- chuyển đổi kiểu dữ liệu
- số tiền và số lượng > 0
- Check dup 
- 541909 bản ghi
- 135080 customerid bản ghi null
*/
WITH online_retail_convert AS (
select invoiceno,
stockcode,
description,
CAST(quantity AS int) as quantity,
invoicedate,
CAST(unitpeice AS numeric) as unitpeice,
customerid,
country
from online_retail
where customerid <> ''
AND CAST(quantity AS int) > 0 AND  CAST(unitpeice AS numeric) > 0)

,online_retail_main AS (
select * from (select *,
ROW_NUMBER() OVER(partition by invoiceno, stockcode, quantity ORDER BY invoicedate) as stt
from online_retail_convert) AS t
WHERE stt = 1)

/* Bước 2:
- Tìm ngày mua hàng đầu tiên của mỗi KH => cohort_date
- Tìm index=tháng (ngày mua hàng - ngày đầu tiên) + 1
- Count số lượng KH hoặc tổng doanh thu tại mỗi cohort_date và index tương ứng
- Pivot table
*/
, online_retail_index as (
select 
customerid, amount,
TO_CHAR(first_purchase_date,'yyyy-mm') AS cohort_date,
invoicedate,
(EXTRACT('year' FROM invoicedate) - EXTRACT('year' FROM first_purchase_date)) * 12 
+ (EXTRACT('month' FROM invoicedate) - EXTRACT('month' FROM first_purchase_date)) +1  as index
FROM (
select 
customerid,
unitpeice * quantity AS amount,
MIN(invoicedate) OVER(partition by customerid) AS first_purchase_date,
invoicedate
from online_retail_main) a)
, xxx AS (
SELECT
	cohort_date,
	index,
	COUNT(DISTINCT customerid) as cnt,
	SUM(amount) AS revenue
FROM online_retail_index
GROUP BY cohort_date, index)

/* Bước 3:
pivot table => cohort chart
*/

-- customer cohort
,customer_cohort AS (
SELECT 
cohort_date,
SUM(case when index = 1 then cnt else 0 end) as m1,
SUM(case when index = 2 then cnt else 0 end) as m2,
SUM(case when index = 3 then cnt else 0 end) as m3,
SUM(case when index = 4 then cnt else 0 end) as m4,
SUM(case when index = 5 then cnt else 0 end) as m5,
SUM(case when index = 6 then cnt else 0 end) as m6,
SUM(case when index = 7 then cnt else 0 end) as m7,
SUM(case when index = 8 then cnt else 0 end) as m8,
SUM(case when index = 9 then cnt else 0 end) as m9,
SUM(case when index = 10 then cnt else 0 end) as m10,
SUM(case when index = 11 then cnt else 0 end) as m11,
SUM(case when index = 12 then cnt else 0 end) as m12,
SUM(case when index = 13 then cnt else 0 end) as m13
FROM xxx
GROUP BY cohort_date
ORDER BY cohort_date)

-- retension cohort
select 
cohort_date,
(100 - round(100.00 * m1 / m1,2)) || '%' as m1,
(100 - round(100.00 * m2 / m1,2)) || '%' as m2,
(100 - round(100.00 * m3 / m1,2)) || '%' as m3,
(100 - round(100.00 * m4 / m1,2)) || '%' as m4,
round(100.00 * m5 / m1,2) || '%' as m5,
round(100.00 * m6 / m1,2) || '%' as m6,
round(100.00 * m7 / m1,2) || '%' as m7,
round(100.00 * m8 / m1,2) || '%' as m8,
round(100.00 * m9 / m1,2) || '%' as m9,
round(100.00 * m10 / m1,2) || '%' as m10,
round(100.00 * m11 / m1,2) || '%' as m11,
round(100.00 * m12 / m1,2) || '%' as m12
from customer_cohort
-- churn cohort


















