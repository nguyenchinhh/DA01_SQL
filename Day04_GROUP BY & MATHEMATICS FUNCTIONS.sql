-- 1. Today Plan


-- 2. Aggregate functions
SELECT 
	MAX(amount) AS max_amount,
	MIN(amount) AS min_amount,
	SUM(amount) AS total_amount,
	AVG(amount) AS avg_amount,
	COUNT(*) AS count_rental,
	COUNT(DISTINCT customer_id) AS total_record_customer
FROM payment
WHERE payment_date	BETWEEN '2020-01-01' AND '2020-02-01'

--3. GROUP BY 
SELECT customer_id, staff_id,
	SUM(amount) AS total_amount,
	AVG(amount) AS avg_amount,
	MAX(amount) AS max_amount,
	MIN(amount) AS min_amount,
	COUNT(*) AS count_rental
FROM payment
GROUP BY customer_id, staff_id
ORDER BY customer_id

-- cú pháp
SELECT col1, col2
SUM(),
AVG,
MIN(),
MAX(),
FROM table_name
GROUP BY col1, col2

-- 4.GROUP BY SOLUTION  (max, min , avg, chi phi thay the)
SELECT film_id,
	MAX(replacement_cost) AS max_replace,
	MIN(replacement_cost) AS min_replace,
	ROUND(AVG(replacement_cost),2) AS avg_replace,
	SUM(replacement_cost) AS sum_replace
FROM film
GROUP BY film_id
ORDER BY film_id


-- 5. HAVING
-- hay cho biet khach hang nao da tra tong so tien > 10$ trong t1-2020
SELECT customer_id,
	SUM(amount) AS total_amount
FROM payment
WHERE payment_date BETWEEN '2020-01-01' AND '2020-02-01'
GROUP BY customer_id
HAVING SUM(amount) > 10
-- HAVING vs WHERE 


-- 6. HAVING SOLUTION
/*
Năm 2020, các ngày 28, 29, 30 / 04 là những ngày có doanh thu rất cao.
Đó là lý do sếp muốn xem dữ liệu vào những ngày đó.
Hãy tìm số tiền thanh toán trung bình được nhóm theo khách hàng và 
ngày thanh toán - chỉ xem những ngày mà khách hàng có nhiều hơn 1 thanh toán.
Sắp xếp theo số tiền trung bình theo thứ tự giảm dần.
*/
SELECT customer_id, DATE(payment_date),
	ROUND(AVG(amount),2) AS avg_amount,
	COUNT(payment_id)
FROM payment
WHERE DATE(payment_date) IN  ('2020-04-28','2020-04-29','2020-04-30') 
GROUP BY 1, 2
HAVING count(payment_id) > 1
ORDER BY avg_amount DESC 


-- 7.Mathematics operations & function
-- TOAN TU VA HAM SO HOC
SELECT film_id,
	rental_rate,
	ROUND(rental_rate *1.1,2) AS retal_rate_new,
	CEILING(rental_rate *1.1) AS retal_rate,
	FLOOR(rental_rate *1.1) AS retal_rate
FROM film
	

-- 8.Mathematics operations & functions Solution
/*
Quản lý của bạn đang nghĩ đến việc tăng giá cho những bộ phim thay thế cao. Vì vậy
bạn nên tạo một danh sách các bộ phim có giá thuê ít hơn 4% chi phí thay thế.
Tạo danh sách film_id đó cùng với tỷ lệ phần trăm (giá thuế/ chi phí thay thế) 
được làm tròn đến 2 chữ số thập phân
*/
SELECT film_id,
		rental_rate,
		replacement_cost,
		ROUND(rental_rate / replacement_cost, 2) * 100 AS percentage_thue
FROM film
WHERE ROUND(rental_rate / replacement_cost, 2) * 100 < 4


-- 9. Tổng kết thứ tự thực hiện câu lệnh
SELECT customer_id,
	COUNT(*) AS total_record
FROM payment
WHERE payment_date >= '2020-01-30' 
GROUP BY customer_id
HAVING count(*) <= 15
ORDER BY total_record DESC
LIMIT 5

=> SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY - LIMIT

-- 10. 
































