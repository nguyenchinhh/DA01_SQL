/*
1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
Output: month_year ( yyyy-mm) , total_user, total_orde
Insight là gì? ( nhận xét về sự tăng giảm theo thời gian)
Note: Nếu lỗi “SELECT list expression references column created_at which is neither grouped nor aggregated”
*/
select format_timestamp('%Y-%m',created_at) AS month_year,
      COUNT(user_id) AS total_user,
      COUNT(total_order) AS total_order
from bigquery-public-data.thelook_ecommerce.orders
WHERE created_at >= '2019-01-01'
      AND created_at <= '2022-04-01'
      AND status = 'Complete'
GROUP BY 1
ORDER BY 1



-- 2.  Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
/*
Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng 
( Từ 1/2019-4/2022)
Output: month_year ( yyyy-mm), distinct_users, average_order_value
Hint: Giá trị đơn hàng lấy trường sale_price từ bảng order_items
giá trị đơn hàng trung bình = tổng giá trị đơn hàng trong tháng/số lượng đơn hàng
Insight là gì?  ( nhận xét về sự tăng giảm theo thời gian)
*/
select format_timestamp('%Y-%m',created_at) AS month_year,
      COUNT(DISTINCT user_id) AS distinct_users,
      ROUND(SUM(sale_price) / COUNT(order_id),2)  AS average_order_value 
from bigquery-public-data.thelook_ecommerce.order_items
where created_at >= '2019-01-01' AND created_at <= '2022-04-01'
GROUP BY 1
ORDER BY 1


/* 
 3. Nhóm khách hàng theo độ tuổi
Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất)
Hint: Sử dụng UNION các KH tuổi trẻ nhất với các KH tuổi trẻ nhất 
tìm các KH tuổi trẻ nhất và gán tag ‘youngest’  
tìm các KH tuổi trẻ nhất và gán tag ‘oldest’ 
Insight là gì? (Trẻ nhất là bao nhiêu tuổi, số lượng bao nhiêu? Lớn nhất là bao nhiêu tuổi, số lượng bao nhiêu) 
*/
WITH chinh AS (
select first_name, 
      last_name,
      gender,
      age,
      'youngest' AS tag
from bigquery-public-data.thelook_ecommerce.users
where created_at >= '2019-01-01' AND created_at <= '2022-04-30'
      AND (age) IN (
        SELECT 
        MIN(age) AS age
        FROM bigquery-public-data.thelook_ecommerce.users
        WHERE created_at >= '2019-01-01' AND created_at <= '2022-04-30'
        GROUP BY gender
      )
UNION ALL
select first_name, 
      last_name,
      gender,
      age,
      'oldest' AS tag
from bigquery-public-data.thelook_ecommerce.users
where created_at >= '2019-01-01' AND created_at <= '2022-04-30'
      AND (age) IN(
        SELECT 
        MAX(age) AS age
        FROM bigquery-public-data.thelook_ecommerce.users
        WHERE created_at >= '2019-01-01' AND created_at <= '2022-04-30'
        GROUP BY gender
      )
)

SELECT tag,
      MIN(age) AS min_age,
      MAX(age) AS max_age,
      COUNT(*) AS total_users
FROM chinh
GROUP BY 1



/* 4.Top 5 sản phẩm mỗi tháng.
Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
Output: month_year ( yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month
Hint: Sử dụng hàm dense_rank() */

select *
from bigquery-public-data.thelook_ecommerce.inventory_items

select format_timestamp('%Y-%m',a.created_at) AS month_year,
        a.product_id,
        a.product_name,
        b.sale_price,
        a.cost,
        (a.product_retail_price - a.cost) AS profit,
        dense_rank() over(partition by a.product_id order by (a.product_retail_price - a.cost)) AS profit_rank
from bigquery-public-data.thelook_ecommerce.inventory_items as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.product_id = b.product_id
LIMIT 5

/* 5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
Output: dates (yyyy-mm-dd), product_categories, revenue */
select date(created_at) AS dates,
       product_category,
       SUM(product_retail_price - cost) AS revenue
from bigquery-public-data.thelook_ecommerce.inventory_items
where created_at <= '2022-04-15'
GROUP BY 1, 2
ORDER BY dates

