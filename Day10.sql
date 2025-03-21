-- BUỔI 10: JOIN & UNION
-- 1.Today's Plan
-- Mỏ rộng  theo chiều ngang dùng JOIN, còn dọc dùng UNION

-- 2. INNER JOIN
SELECT t1.*, t2.*
FROM table1 AS t1
INNER JOIN table2 AS t2
ON t1.key1 = t2.key2


SELECT p.payment_id, p.customer_id, c.first_name, c.last_name
FROM payment AS p
INNER JOIN  customer AS c
ON p.customer_id = c.customer_id

-- 3.INNER JOIN SOLUTION
/* Có bao nhiêu người ngồi ghế theo các loại sau:
  Business
  Economy
  Comfort
*/
SELECT fare_conditions,
		COUNT(*)
FROM seats AS s
INNER JOIN boarding_passes AS b
ON s.seat_no = b.seat_no
GROUP BY fare_conditions

-- 4.LEFT JOIN - RIGHT JOIN
-- Tìm thông tin các chuyến bay của từng máy bay 
-- B1: xác định bảng
-- B2: xác định key join
-- B3: chọn phương thức JOIN
SELECT a.aircraft_code, f.flight_no
FROM aircrafts_data AS a
LEFT JOIN flights AS f
ON a.aircraft_code = f.aircraft_code
WHERE f.flight_no IS NULL

-- 5.LEFT JOIN - RIGHT JOIN SOLUTION
/* Tìm hiểu ghế nào được chọn thường xuyên nhất. (Đảm bảo tất cả các ghế đề được liệt kê
ngay cả khi chúng chưa bao giờ được đặt.)
Có chỗ ngồi nào chưa bao giờ được đặt không?
Chỉ ra hàng ghế nào được đặt thường xuyên nhất (A, B, C)
*/

-- 1, 2
SELECT s.seat_no,
		COUNT(flight_id) AS so_luong
FROM seats AS s
LEFT JOIN boarding_passes AS b
ON s.seat_no = b.seat_no
-- WHERE s.seat_no IS NULL
GROUP BY s.seat_no
ORDER BY COUNT(flight_id) DESC
-- 3
SELECT RIGHT(s.seat_no,1),
		COUNT(flight_id) AS so_luong
FROM seats AS s
LEFT JOIN boarding_passes AS b
ON s.seat_no = b.seat_no
GROUP BY RIGHT(s.seat_no,1)
ORDER BY RIGHT(s.seat_no,1)


-- 6. FULL JOIN
SELECT * 
FROM boarding_passes AS b
FULL JOIN tickets AS t
ON b.ticket_no = t.ticket_no
WHERE b.ticket_no IS NULL

--7. JOIN ON MULTIPLE CONDITIONS
-- JOIN nhiều điều kiện
-- Tính giá trị trung bình của từng số ghế máy bay
-- b1: xdinh ouput, input
-- SỐ GHẾ; GIÁ TRUNG BÌNH

SELECT * FROM seats

SELECT b.seat_no, 
	AVG(t.amount) AS avg_amount
FROM boarding_passes AS b
LEFT JOIN ticket_flights AS t
ON b.ticket_no = t.ticket_no AND b.flight_id = t.flight_id
GROUP BY (b.seat_no)
ORDER BY AVG(t.amount) DESC


--8. JOIN MULTIPLE TABLE
-- số vé, tên khách hàng, giá vé, giờ bay, giờ kết thúc
SELECT a.ticket_no, a.passenger_name, b.amount, c.scheduled_departure, c.scheduled_arrival
FROM tickets AS a
INNER JOIN ticket_flights AS b
ON a.ticket_no = b.ticket_no
INNER JOIN flights AS c
ON c.flight_id = b.flight_id


  -- 9.JOIN MULTIPLE TABLE SOLUTION
/* Công ty muốn tùy chỉnh chiến dịch của họ cho phù hợp với khách hàng tùy thuộc vào
đất nước họ đến.
Những khách hàng nào đến từ Brazil?
Viết truy vấn để lấy first_name, last_name, email và quốc gia từ tất cả khách hàng từ Brazil.
*/
SELECT a.first_name, a.last_name, a.email, d.country
FROM customer AS a
INNER JOIN address AS b
ON a.address_id = b.address_id
INNER JOIN city AS c
ON b.city_id = c.city_id
INNER JOIN country AS d
ON c.country_id = d.country_id
WHERE d.country = 'Brazil'


-- 10.SELF JOIN 
SELECT emp.employee_id, emp.name AS emp_name, emp.manager_id, mng.name AS mng_name
FROM employee AS emp
LEFT JOIN employee AS mng
ON emp.manager_id = mng.employee_id

/*Challenge: Tìm những bộ phim có cùng thời lượng phim
ouput: titl21, title2, length
*/
SELECT a.title AS title1, b.title AS title2, a.length
FROM film AS a
LEFT JOIN film AS b
ON a.length = b.length 
WHERE a.title <> b.title

-- 11. UNION
-- UNION 
/*
1. Số lượng cột 2 bảng phải giống nhau.
2. Kiểu dữ liệu trong cùng 1 cột phải giống nhau.
3. UNION loại trùng lặp còn UNION ALL thì không.
*/
  
-- SELECT col1, col2, col3, ...coln
-- FROM table1
-- UNION/UNION ALL 
-- SELECT col1, col2, col3,...coln
-- FROM table2
-- UNION/UNION ALL 
-- SELECT col1, col2, col3,...coln
-- FROM table3


SELECT first_name, 'actor' AS source FROM actor 
UNION 
SELECT first_name, 'customer' AS source FROM customer
UNION
SELECT first_name, 'staff' AS source FROM staff
ORDER BY first_name


























