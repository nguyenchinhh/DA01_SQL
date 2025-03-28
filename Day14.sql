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
























-- 5.RANK


-- 6.RANK SOLUTUON




--7. FIRST_VALUE



-- 8.LEAD() & LAG()



-- 9. LEAD & LAG() SOLUTION


-- 10. Quiz
