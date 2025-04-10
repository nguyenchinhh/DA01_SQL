
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

-- 2. Tạo retention cohort analysis theo tháng, theo dõi 3 tháng (index từ 1 đến 4)

, customer_first_purchase AS (
  SELECT 
    user_id,
    MIN(DATE(created_at)) AS first_purchase_date
  FROM bigquery-public-data.thelook_ecommerce.orders
  WHERE user_id IS NOT NULL
  GROUP BY user_id
),

customer_orders_with_index AS (
  SELECT 
    o.user_id,
    DATE(o.created_at) AS purchase_date,
    FORMAT_TIMESTAMP('%Y-%m', o.created_at) AS purchase_month,
    FORMAT_TIMESTAMP('%Y-%m', f.first_purchase_date) AS cohort_month,
    DATE_DIFF(DATE(o.created_at), DATE(f.first_purchase_date), MONTH) + 1 AS index_month
  FROM bigquery-public-data.thelook_ecommerce.orders o
  JOIN customer_first_purchase f
    ON o.user_id = f.user_id
  WHERE o.user_id IS NOT NULL
)

, filtered_index AS (
  SELECT *
  FROM customer_orders_with_index
  WHERE index_month BETWEEN 1 AND 4  
)

, cohort_count AS (
  SELECT 
    cohort_month,
    index_month,
    COUNT(DISTINCT user_id) AS user_count
  FROM filtered_index
  GROUP BY cohort_month, index_month
)

, cohort_pivot AS (
  SELECT 
    cohort_month,
    SUM(CASE WHEN index_month = 1 THEN user_count ELSE 0 END) AS m1,
    SUM(CASE WHEN index_month = 2 THEN user_count ELSE 0 END) AS m2,
    SUM(CASE WHEN index_month = 3 THEN user_count ELSE 0 END) AS m3,
    SUM(CASE WHEN index_month = 4 THEN user_count ELSE 0 END) AS m4
  FROM cohort_count
  GROUP BY cohort_month
)

-- churn cohort
SELECT 
  cohort_month,
  (100 - ROUND(100.0 * m1 / m1, 2)) || '%' AS m1,
  (100 - ROUND(100.0 * m2 / m1, 2)) || '%' AS m2,
  (100 - ROUND(100.0 * m3 / m1, 2)) || '%' AS m3,
  (100 - ROUND(100.0 * m4 / m1, 2)) || '%' AS m4
FROM cohort_pivot
ORDER BY cohort_month;

-- SELECT 
--   cohort_month,
--   ROUND(100.0 * m1 / m1, 2) || '%' AS m1,
--   ROUND(100.0 * m2 / m1, 2) || '%' AS m2,
--   ROUND(100.0 * m3 / m1, 2) || '%' AS m3,
--   ROUND(100.0 * m4 / m1, 2) || '%' AS m4
-- FROM cohort_pivot
-- ORDER BY cohort_month;


