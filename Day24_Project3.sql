-- PROJECT 3
/* 1. Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE */
select productline,
	   year_id,
	   dealsize,
	   sum(sales) as revenue
from sales_dataset_rfm_prj
group by 1, 2, 3

/* 2. Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER */
-- cach 1
with rank_sales as (
select month_id,
		year_id,
		sum(sales) as revenue,
		row_number() over(partition by year_id order by sum(sales) DESC) as rank1
from sales_dataset_rfm_prj
group by 1, 2)
	
select month_id,
	   year_id,
	   revenue,
	   rank1
from rank_sales
where rank1 = 1
order by year_id


-- cach 2
select * from (
select month_id,
		year_id,
		sum(sales) as revenue,
		row_number() over(partition by year_id order by sum(sales) DESC) as rank1
from sales_dataset_rfm_prj
group by 1, 2)
where rank1 = 1
order by revenue DESC


/* 3. Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER */
with ex1 as (
select month_id,
	   year_id,
	   productline,
	   sum(sales) as revenue,
	   count(*) as order_number,
	   row_number() over(partition by year_id order by sum(sales) DESC) as rank1
from sales_dataset_rfm_prj
group by 1, 2, 3)

select month_id,
	   year_id
	   revenue,
	   productline,
	   order_number
from ex1
where month_id = '11' and rank1 = 1


/* 4. Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK */

select * from (
select year_id,
		productline,
		sum(sales) as revenue,
		row_number() over(partition by year_id order by sum(sales) DESC) as ranks
from sales_dataset_rfm_prj
where country = 'UK'
group by 1, 2)
where ranks = 1
order by revenue DESC


/* 5. Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23) */

-- Bước 1: Tính giá trị R-F-M
with ex1 as (
select a.customer_name,
		current_date - MAX(order_date) R,
		count(distinct order_id) F,
		SUM(sales) AS M
from customer as a
join sales as b
on a.customer_id = b.customer_id
group by a.customer_name)

/*Bước 2: Chia các giá trị thành các khoảng trên thang điểm 1 - 5*/
, rfm_score AS (
select customer_name,
		ntile(5) over (order by R DESC) R_score,
		ntile(5) over (order by F) F_score,
		ntile(5) over (order by M) M_score
from ex1)

, rfm_final as (
	select customer_name,
			cast(R_score as varchar) || cast(F_score as varchar) || cast(M_score as varchar) as rfm_score
	from rfm_score
)
select segment, count(*) from(
	select customer_name,
			d.segment
from rfm_final as c
join segment_score as d
on c.rfm_score = d.scores) as a
group by segment
order by count(*)





