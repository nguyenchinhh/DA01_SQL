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
	POSITION('.' IN email) ,
	POSITION('@' IN email),
	POSITION('.' IN email),
	POSITION('@' IN email) - POSITION('.' IN email) 
FROM customer










