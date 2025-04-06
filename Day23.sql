-- Bước 1: Tính giá trị R-F-M
-- select * from customer;
-- select * from sales;
-- select * from segment_score

WITH customer_rfm as (
select 
	a.customer_id,
	current_date - MAX(order_date) as R,
	count(distinct order_id) as F,
	SUM(sales) as M
from customer as a
join sales as b
on a.customer_id = b.customer_id
group by a.customer_id)


/*Bước 2: Chia các giá trị thành các khoảng trên thang điểm 1 - 5*/
, rfm_score as (
select customer_id,
	   ntile(5) over(order by R DESC) R_score,
	   ntile(5) over(order by F) F_score,
	   ntile(5) over(order by M) M_score
from customer_rfm)

, rfm_final as (
select customer_id,
	   cast(R_score as varchar) || cast(F_score as varchar) || cast(M_score as varchar) as rfm_score
from rfm_score)

select segment, count(*) from(
select c.customer_id,
		d.segment
from rfm_final c
JOIN segment_score d
on c.rfm_score = d.scores) as a
group by segment
order by count(*)

/* Buoc 4: Truc quan phan tich RFM */

