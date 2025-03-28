-- BUỔI 14: WINDOW FUNCTION
-- 1. Today's plan
/*
tổng hợp: SUM, AVG, MIN, MAX, COUNT
xếp hạng: RANK
phân tích: LEAD(), LAG()
*/


-- 2.OVER() with PARTITION BY
-- WINDOW FUNCTION with SUM(), COUNT(), AVG(), 
/* Tính tỉ lệ số tiền thanh toán từng ngày với tổng số tiền đã thanh toán của mỗi KH
output: mã KH, tên KH,ngày thanh toán, số tiền thanh toán tại ngày,
tổng số tiền thanh toán, tỉ lệ
*/

SELECT a.customer_id, b.first_name, a.payment_date, a.amount,
	(SELECT SUM(amount) 
FROM payment c
WHERE c.customer_id = a.customer_id
GROUP BY customer_id),
a.amount / 	(SELECT SUM(amount) 
FROM payment c
WHERE c.customer_id = a.customer_id
GROUP BY customer_id) AS percentage
FROM payment a
JOIN customer b
ON a.customer_id = b.customer_id

-- cách 2
WITH tw_total_payment AS (
	SELECT customer_id,
			SUM(amount) AS total
	FROM payment
	GROUP BY customer_id
)

SELECT a.customer_id, b.first_name, a.payment_date, a.amount, c.total, a.amount / c.total AS percentage
FROM payment AS a
JOIN customer AS b
ON a.customer_id = b.customer_id
JOIN tw_total_payment AS c
ON c.customer_id = a.customer_id

-- cach 3: window function 
SELECT a.customer_id, b.first_name, a.payment_date, a.amount,
	SUM(amount) OVER (PARTITION BY a.customer_id) AS total
FROM payment AS a

JOIN customer AS b ON a.customer_id = b.customer_id

-- CU PHAP:
SELECT col1, col2, col3,...
AGG(col2) OVER(PARTITION BY col1/col2/col3,...) 
FROM table_name


-- 3.OVER() with PARTITION BY SOLUTION
-- CHALLENGE 1
/* Viết truy vấn trả về danh sách phim bao gồm:
film_id, title, length, category, 
thời lượng trung bình của phim trong category đó
sắp xếp kết quả theo film_id
*/
SELECT f.film_id, f.title, f.length, c.name AS category,
		ROUND(AVG(length) OVER(PARTITION BY c.name),2) AS avg
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
ORDER BY f.film_id



-- CHALLENGE 2
/* Viết truy vấn trả về tất cả chi tiết các thanh toán bao gồm số lần thanh toán được
thực hiện bởi khách hàng này và số tiền đó
sắp xếp kết quả theo payment_id
*/
SELECT *,
		COUNT(*) OVER(PARTITION BY customer_id, amount) AS total
FROM payment
ORDER BY payment_id ASC




-- 4.OVER() with ORDER BY 
-- ORDER BY
SELECT payment_date, customer_id, amount,
		SUM(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS total_amount -- luy ke
FROM payment


SELECT col1, col2, coln,...
		AGG(col2) OVE(PARTITION BY col1/col2 ORDER BY col3)
FROM table_name


-- 5.RANK
-- WINDOW FUNCTION with RANK FUNCTION
-- xếp hạng độ dài phim trong từng thể loại
-- output: film_id, category, length, xếp hạng độ dài phim trong từng category
SELECT a.film_id, c.name AS category, a.length,
		RANK() OVER(PARTITION BY c.name ORDER BY a.length DESC) AS rank1,
		DENSE_RANK() OVER(PARTITION BY c.name ORDER BY a.length DESC) AS rank2,
		ROW_NUMBER() OVER(PARTITION BY c.name ORDER BY a.length DESC, a.film_id) AS rank3
FROM film a
JOIN film_category b ON a.film_id = b.film_id
JOIN category c ON c.category_id = b.category_id
ORDER BY c.name


-- 6.RANK SOLUTUON
/* Viết truy vấn trả về tên khách hàng, quốc gia và số lượng thanh toán mà họ có
Sau đó tạo bảng xếp hạng những khách hàng có doanh thu ca nhất cho mỗi quốc gia
Lọc kết quả chỉ 3 khách hàng hàng đầu của mỗi quốc gia
*/
SELECT * FROM 
(
SELECT CONCAT(first_name, ' ', last_name)  AS full_name, d.country,
		COUNT(*) AS so_luong,
		SUM(e.amount) AS amount,
		RANK() OVER(PARTITION BY d.country ORDER BY SUM(e.amount) ASC ) AS stt
FROM customer a
INNER JOIN address b ON a.address_id = b.address_id
INNER JOIN city c ON c.city_id = b.city_id
INNER JOIN country d ON c.country_id = d.country_id
INNER JOIN payment e ON e.customer_id = a.customer_id
GROUP BY 1, 2
)
WHERE stt <= 3


--7. FIRST_VALUE
-- WINDOW FUNCTION with FIRST_VALUE
-- số tiền thanh toán cho đơn hàng đầu tiên và gần đây nhất của từng khách hàng
SELECT * FROM (
SELECT customer_id, payment_date,amount,
		ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY payment_date DESC) AS stt
FROM payment ) A
WHERE stt = 1;


SELECT customer_id, payment_date,amount,
		FIRST_VALUE(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS first_amount,
		FIRST_VALUE(amount) OVER(PARTITION BY customer_id ORDER BY payment_date DESC) AS last_amount
FROM payment 


-- 8.LEAD() & LAG()
-- WINDOW FUNCTION with LEAD(), LAG()
-- tìm chênh lệch số tiền giữa các lần thanh toán của từng khách hàng
SELECT customer_id, payment_date, amount,
		LEAD(amount,3) OVER(PARTITION BY customer_id ORDER BY payment_date) AS next_amount,
		LEAD(payment_date,3) OVER(PARTITION BY customer_id ORDER BY payment_date) AS next_payment_date,
		amount - LEAD(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS diff
FROM payment
ORDER BY customer_id, payment_date


SELECT customer_id, payment_date, amount,
		LAG(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS previous_amount,
		LAG(payment_date) OVER(PARTITION BY customer_id ORDER BY payment_date) AS previous_payment_date,
		amount - LEAD(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS diff
FROM payment
ORDER BY customer_id, payment_date


-- 9. LEAD & LAG() SOLUTION
/* Viết truy vấn trả về doanh thu trong ngày và doanh thu của ngày hôm trước
Sau đó tính toán phần trăm tăng trưởng so với ngày hôm trước */
WITH ex AS (
SELECT date(payment_date) AS payment_date,
		SUM(amount) AS amount
FROM payment
GROUP BY date(payment_date)) 

SELECT payment_date,amount,
		LAG(amount) OVER(ORDER BY payment_date) AS previous_amount,
		ROUND((amount - LAG(amount) OVER(ORDER BY payment_date)) / LAG(amount) OVER(ORDER BY payment_date) * 100,2) AS percentage_diff
FROM ex

-- 10. Quiz 90%















