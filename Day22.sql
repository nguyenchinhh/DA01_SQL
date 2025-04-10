with ex1 as (
select format_timestamp('%Y-%m',a.created_at) AS year_month,
       EXTRACT(YEAR FROM a.created_at) AS year,
       SUM(b.sale_price) AS TPV, -- tổng doanh thu mỗi tháng
       COUNT(b.order_id) as TPO, -- tổng số đơn hàng mỗi tháng
       SUM(c.cost) as total_cost,  -- tông chi phí    
       SUM(c.retail_price) AS total_retail_price, -- tổng doanh thu  
       SUM(c.retail_price) - SUM(c.cost) AS total_profit -- tổng lợi nhuận

from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.order_id = b.order_id
join bigquery-public-data.thelook_ecommerce.products as c 
on c.id = b.id
group by 1 ,2)

, vw_ecommerce_analyst AS (
select year_month,
       year,
       TPV,
       round(LAG(TPV) OVER(order by year_month),2) as pre_month_TPV,
       round(SAFE_DIVIDE(TPV - LAG(TPV) OVER(ORDER BY year_month), LAG(TPV) OVER(ORDER BY year_month)),2) || '%' AS revenue_growth,
       TPO,
       LAG(TPO) OVER (order by year_month) as pre_month_TPO,
       round(SAFE_DIVIDE(TPO - LAG(TPO) OVER (order by year_month), LAG(TPO) OVER (order by year_month)),2) || '%' AS order_growth,
       total_cost,
       total_retail_price,
       total_profit,
       ROUND(SAFE_DIVIDE(total_profit,total_cost),2) AS profit_to_cost_ratio
from ex1
order by year_month )



 -- 2.Tạo retention cohort analysis.

WITH online_retail_convert AS (
select invoiceno,
stockcode,
description,
CAST(quantity AS int) as quantity,
CAST(invoicedate AS timestamp) as invoicedate,
CAST(unitpeice AS numeric) as unitpeice,
customerid,
country
from online_retail
where customerid <> ''
and CAST(quantity AS int) > 0
and CAST(unitpeice AS numeric) > 0)

, online_retail_main AS (
select * from (
select *,
ROW_NUMBER() OVER(PARTITION BY invoiceno, stockcode, quantity ORDER BY invoicedate) as stt
from online_retail_convert) as t
where stt = 1 )


, online_retail_index AS (
select 
customerid,
amount,
TO_CHAR(first_purchase_date, 'yyyy-mm') as cohort_date,
invoicedate,
(extract('year' from invoicedate) - extract('year' from first_purchase_date)) * 12
+ (extract('month' from invoicedate) - extract('month' from first_purchase_date)) + 1 as index

from (
select 
customerid,
unitpeice * quantity as amount,
MIN(invoicedate) OVER(PARTITION BY customerid) as first_purchase_date,
invoicedate
from online_retail_main) as a)

, xxx AS (
select 
cohort_date,
index,
COUNT(DISTINCT customerid) as cnt,
SUM(amount) as revenue
from online_retail_index
group by cohort_date, index)

/*Bước 3:
pivot table ==> cohort chart
*/

-- customer cohort
,customer_cohort AS (
select 
cohort_date,
SUM(case when index = 1 then cnt else 0 end) as "m1",
SUM(case when index = 2 then cnt else 0 end) as "m2",
SUM(case when index = 3 then cnt else 0 end) as "m3",
SUM(case when index = 4 then cnt else 0 end) as "m4"
from xxx
GROUP BY cohort_date
ORDER BY cohort_date)

-- retention cohort
select cohort_date,
round(100.00 * m1/m1,2) || '%' as m1,
round(100.00 * m2/m1,2) || '%' as m2,
round(100.00 * m3/m1,2) || '%' as m3,
round(100.00 * m4/m1,2) || '%' as m4
from customer_cohort




select * from bigquery-public-data.thelook_ecommerce.order_items
select * from bigquery-public-data.thelook_ecommerce.orders
select * from bigquery-public-data.thelook_ecommerce.products
select * from bigquery-public-data.thelook_ecommerce.users


