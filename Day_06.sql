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




