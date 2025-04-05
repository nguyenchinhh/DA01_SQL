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

































       

select * from bigquery-public-data.thelook_ecommerce.order_items
select * from bigquery-public-data.thelook_ecommerce.orders
select * from bigquery-public-data.thelook_ecommerce.products

select * from bigquery-public-data.thelook_ecommerce.users










