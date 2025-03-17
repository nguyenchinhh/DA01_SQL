-- 1.Liệt kê các khách hàng có họ và tên nhiều hơn 10 kí tự. Kết quả trả ra ở dạng chữ thường
SELECT LOWER(last_name), LOWER(first_name)
FROM customer
WHERE length(last_name) > 10 OR length(first_name) > 10

-- 2.Trước tiên hãy trích xuất 5 ký tự cuối cùng của địa chỉ email. Địa chỉ email luôn kêt thúc bằng '.org'
-- Làm cách nào bạn có thể trích xuất chỉ dấu chấm '.' từ địa chỉ email?
SELECT email,
	RIGHT(email,5),
	LEFT(RIGHT(email,4),1)
FROM customer


--3. NỐI CHUỖI
SELECT 
	customer_id,
	first_name,
	last_name,
	first_name ||' ' || last_name AS full_name, -- || dùng để nối chuỗi
	CONCAT(first_name, ' ', last_name) AS full_name
FROM customer
-- Để bảo mật dữ liệu khách hàng, bạn được yêu cầu mask địa chỉ email như sau. Ví dụ
-- MARY.SMITH@sakilacustomer.org
-- => MAR***H@sakilacustomer.org
SELECT email,
	LEFT(email, 3) || '***' || RIGHT(email,20)
FROM customer



-- 4.REPLACE
SELECT 
email,
REPLACE(email,'.org', '.com') AS new_email
FROM customer

-- 5.POSITION
SELECT  
	email,
	POSITION('@' IN email) // tim vi tri @ tren email
FROM customer

-- POSITION
SELECT  
	email,
	LEFT(email,POSITION('@' IN email)- 1), -- lấy tên bên trái trước @
	RIGHT(email,LENGTH(email) - POSITION('@' IN email)) -- lấy tên bên phải sau @
FROM customer

-- 6. SUBSTRING
-- Lấy ra ký tự từ  2 đến 4 của first_name
SELECT first_name,
	RIGHT(LEFT(first_name, 4),3),
	SUBSTRING(email,2,3) -- bắt đầu từ 2, lấy ra 3 kí tự
FROM customer
	
---
SELECT 
	email,
	SUBSTRING(email FROM POSITION('.' IN email) + 1 FOR POSITION('@' IN email) - POSITION('.' IN email) - 1),
	-- POSITION('.' IN email) ,
	-- POSITION('@' IN email),
	-- POSITION('.' IN email),
	-- POSITION('@' IN email) - POSITION('.' IN email) - 1
FROM customer


-- Challenge : 
-- Giả sử bạn chỉ có địa chỉ email và họ khách hàng. Bạn cần trích xuất tên từ địa chỉ emai và nối nói với họ
-- kết quả phải ở dạng: "Họ, Tên"
-- cách 1
SELECT email,
		-- last_name,
		-- POSITION('.' IN EMAIL),
		LEFT(email,POSITION('.' IN EMAIL) - 1) || ',' || last_name
FROM customer
-- cách 2
SELECT email,
		SUBSTRING(email FROM 1 FOR POSITION ('.' IN email) - 1) as first_name,
		SUBSTRING(email FROM 1 FOR POSITION ('.' IN email) - 1) || ',' || last_name AS full_name
FROM customer


-- 7. EXTRACT
-- Năm 2020, có bao nhiêu đơn hàng cho thuê trong mỗi tháng
SELECT 
	EXTRACT(month FROM rental_date),
	COUNT(*)
FROM rental
WHERE EXTRACT(year FROM rental_date) = '2020'
GROUP BY EXTRACT(month FROM rental_date)

--CHALLENGE
-- Bạn cần phân tích các khoản thanh toán và tìm hiểu những điều sau:
-- . THáng nào có tổng số tiền thanh toán cao nhất?
-- . Ngày nào trong tuần có tổng số tiền thanh toán cao nhất (0 là chủ nhật)
-- . Số tiền cao nhất mà một khách hàng đã chi tiêu trong một tuần là bao nhiêu?
SELECT 
	EXTRACT(month FROM payment_date) AS month_of_year,
	SUM(amount) AS amount
FROM payment
GROUP BY EXTRACT(month FROM payment_date)
ORDER BY amount DESC

-- 2. Ngày nào trong tuần có tổng số tiền thanh toán cao nhất (0 là chủ nhật)

SELECT 
	EXTRACT(DOW FROM payment_date) AS day_of_week,
	SUM(amount) AS amount
FROM payment
GROUP BY EXTRACT(DOW FROM payment_date)
ORDER BY amount DESC
-- 3.Số tiền cao nhất mà một khách hàng đã chi tiêu trong một tuần là bao nhiêu?
SELECT customer_id,
	EXTRACT(WEEK FROM payment_date) AS week_of_month,
	SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id,EXTRACT(WEEK FROM payment_date) 
ORDER BY total_amount DESC


-- 8.TO CHAR
SELECT 	
	payment_date,
	EXTRACT(year from payment_date),
	TO_CHAR(payment_date, 'yyyy')
FROM payment
-- TO_CHAR(payment_date, format)

-- 9.INTERVAL
SELECT current_date, current_timestamp,
	customer_id,
	rental_date,
	return_date,
	EXTRACT(day FROM return_date - rental_date) * 24 
	+ EXTRACT(hour FROM return_date - rental_date) ||' ' || 'giờ' 
FROM rental
-- current_date, current_timestamp


-- Challenge 
-- Bạn cần tạo danh sách tất cả thời gian đã thuê của khách hàng với customer_id 35.
-- Ngoài ra bạn cần tìm hiểu khách hàng nào có thời gian thuê trung bình dài nhất?

--Giải
-- Bạn cần tạo danh sách tất cả thời gian đã thuê của khách hàng với customer_id 35.
SELECT customer_id,
		rental_date,
		return_date,
		return_date - rental_date
FROM rental
WHERE customer_id = 35

-- Ngoài ra bạn cần tìm hiểu khách hàng nào có thời gian thuê trung bình dài nhất?
SELECT customer_id,
		-- AVG(return_date - rental_date),
		ROUND(AVG(EXTRACT(day FROM return_date - rental_date) * 24 
	+ EXTRACT(hour FROM return_date - rental_date)),3)  ||' ' || 'giờ' AS avg_rental_max
FROM rental
GROUP BY customer_id
ORDER BY AVG(return_date - rental_date) DESC



















