-- Buổi 8: LOGICAL FUNCTIONS & PIVOT TALBLE
--  Dùng CASE WHEN để phân nhóm theo từng category
-- Dùng COLLESE để xử lý dữ liệu bị NULL
-- Dùng CAST để chuyển dổi kiểu dữ liệu
-- Cách PIVOT TABLE để định hình dữ liệu


-- 2. CASE WHEN 
/* Hãy phân loại các bộ phim theo thời lượng short-medium-long cụ thể:
- short: < 60 phút
- medium: 60 - 120 phút
- long: > 120 phút
*/

SELECT 
	CASE 
		WHEN length < 60 THEN 'short'
		WHEN length >= 60 AND length <= 120 THEN 'medium'
		WHEN length > 120 THEN 'long'
		ELSE ''
	END AS category,
COUNT(*) AS so_luong	
FROM film
GROUP BY category 

  
/* Bộ phim có tag là 1 nếu trường hợp rating là G hoặc PG;
 tag là 0 trong các trường hợp còn lại
*/
SELECT rating,
	CASE 
		WHEN rating = 'PG' OR rating = 'G' THEN 1
		ELSE 0
	END AS tag
FROM film


-- 2. CASE- WHEN SOLUTION 
/* EX1. Bạn cần tìm hiểu xem công ty đã bán bao nhiêu vé trong các danhm mục sau:
- Low price ticket: total_amount < 20,000
- Mid price ticket: total_amount between 20,000 and 150,000
- High price ticket: total_amount >= 150,000
*/
SELECT 
	CASE 
		WHEN amount < 20000 THEN 'Low price ticket'
		WHEN amount BETWEEN 20000 AND 150000 THEN 'Mid price ticket'
		ELSE 'High price ticket'
	END AS category,
COUNT(*) AS so_luong
FROM ticket_flights
GROUP BY category


/* EX2. Bạn cần biết có bao nhiêu chuyến bay đã khởi hành vào các mùa sau: 
- Mùa xuân: Tháng 2, 3, 4
- Mùa hè: Tháng 5, 6, 7
- Mùa thu: Tháng 8, 9 , 10
- Mùa đông: 11, 12, 1
*/
SELECT 
	CASE 
		WHEN EXTRACT(month FROM scheduled_departure) IN (2,3,4) THEN 'Mua xuan'
		WHEN EXTRACT(month FROM scheduled_departure) IN (5,6,7) THEN 'Mua he'
		WHEN EXTRACT(month FROM scheduled_departure) IN (8,9,10) THEN 'Mua thu'
		WHEN EXTRACT(month FROM scheduled_departure) IN (11,12,1) THEN 'Mua dong'
	END AS season,
COUNT(*) AS so_luong
FROM flights
GROUP BY season


/* EX3. Bạn muốn tạo danh sách phim phân cấp độ theo cách sau:
1. Xếp hạng là 'PG' hoặc 'PG-13' hoặc thời lượng hơn 210 phút: 'Greating rating or long (tier 1)
2. Mô tả chứa 'Drama' và thời lượng hơn 90 phút: 'Long drama (tier 2)'
3. Mô tả có chứa 'Drama' và thời lượng không quá 90': 'Shcity drama (tier 3)'
4. Giá thuê thấp hơn $1: 'Very cheap'(tier 4)
Nếu bộ phim có thể thuộc nhiều danh mục, nó sẽ được chỉ định ở cấp cao hơn. Làm cách nào để bạn có thể chỉ lọc những phim xuất hiện ở một trong 4 cấp độ này?

*/
SELECT *,
	CASE
		WHEN rating IN ('PG','PG-13') OR length > 210 THEN 'Greating rating or long (tier 1)'
		WHEN description LIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2))'
		WHEN description LIKE '%Drama%' AND length < 90 THEN 'Shcity drama (tier 3)'
		WHEN rental_rate < 1  THEN 'Very cheap(tier 4)'
	END as category
FROM film
WHERE CASE
		WHEN rating IN ('PG','PG-13') OR length > 210 THEN 'Greating rating or long (tier 1)'
		WHEN description LIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2))'
		WHEN description LIKE '%Drama%' AND length < 90 THEN 'Shcity drama (tier 3)'
		WHEN rental_rate < 1  THEN 'Very cheap(tier 4)'
	END IS NOT NULL



-- 3. PIVOT TABLE WITH CASE WHEN 
/* Tính tổng số tiền theo từng loại hóa đơn high-medium-low
của từng khách hàng
- high: amount > 10
- medium: 5 <= amount <= 10
- low: aount < 5
*/
SELECT
	customer_id,
	SUM(CASE
		WHEN amount > 10 THEN amount
		ELSE 0
	END) AS hight,
	SUM(CASE
		WHEN amount BETWEEN 5 AND 10 THEN amount
		ELSE 0
	END) AS medium ,
	SUM(CASE
		WHEN amount < 5 THEN amount
		ELSE 0
	END) AS Low
FROM payment
GROUP BY customer_id
ORDER BY customer_id


-- 4. PIVOT BY CASE-WHEN SOLUTION
/* Bạn cần thống kê có bao nhiêu bộ phim được đánh giá là R, PG, PG - 13 ở các thể loại phim long - medium - short
- long: length > 120
- medium: 60 <= legth <= 120
- short: lenght < 60
*/
SELECT 
	CASE 
		WHEN length > 120 THEN 'long'
		WHEN length BETWEEN 60 AND 120 THEN 'medium'
		WHEN length < 60 THEN 'short'
	END AS category,
	SUM(CASE
	WHEN rating = 'R' THEN 1 ELSE 0
	END) AS r,
	SUM(CASE
	WHEN rating = 'PG' THEN 1 ELSE 0
	END) AS pg,
	SUM(CASE
	WHEN rating = 'PG-13' THEN 1 ELSE 0
	END) AS pg_13
FROM film
GROUP BY category















































