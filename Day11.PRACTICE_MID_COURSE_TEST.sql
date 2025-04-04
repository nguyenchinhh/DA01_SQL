-- EX1: hackerrank-average-population-of-each-continent
SELECT co.continent,
        FLOOR(AVG(ci.population))
FROM city AS ci
JOIN country AS co
ON ci.countrycode = co.code
GROUP BY co.continent

-- EX2: datalumwe-signup-confirmation-rate
SELECT 
    ROUND(COUNT(CASE
        WHEN signup_action = 'Confirmed' THEN 1
    END) * 1.0 / COUNT(*) ,2)
FROM texts AS t 
LEFT JOIN emails AS e 
ON t.email_id = e.email_id


-- EX3: datalemur-time-spent-snaps
SELECT 
    b.age_bucket,
    ROUND(100 * SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END) 
              / SUM(a.time_spent), 2) AS send_perc,
    ROUND(100 * SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END) 
              / SUM(a.time_spent), 2) AS open_perc
FROM activities AS a
LEFT JOIN age_breakdown AS b
ON a.user_id = b.user_id
WHERE a.activity_type != 'chat'
GROUP BY b.age_bucket;

-- EX4: datalemur-supercloud-customer
WITH cats_bought AS
(
SELECT customer_id, COUNT(DISTINCT product_category) AS cats_buy
FROM customer_contracts
INNER JOIN products
USING(product_id)
GROUP BY customer_id
)

SELECT customer_id
FROM cats_bought
WHERE cats_buy = (SELECT COUNT(DISTINCT product_category) FROM products)


-- EX5 : leetcode-the-number-of-employees-which-report-to-each-employee
SELECT m.employee_id,
        m.name,
        COUNT(DISTINCT e.employee_id) AS reports_count,
        ROUND(AVG(e.age)) AS average_age
FROM Employees AS e 
INNER JOIN Employees AS m
ON m.employee_id = e.reports_to 
GROUP BY 1, 2
ORDER BY m.employee_id	


-- EX6: leetcode-list-the-products-ordered-in-a-period	
SELECT p.product_name,
        SUM(o.unit) AS unit
FROM Products AS p
INNER JOIN Orders AS o
ON p.product_id = o.product_id 
WHERE EXTRACT(YEAR FROM o.order_date) = 2020 AND EXTRACT(MONTH FROM o.order_date) = 2
GROUP BY p.product_name
HAVING  SUM(o.unit) >= 100

	
-- EX7: datalumwe-sql-page-with-no-likes
SELECT a.page_id
FROM pages AS a 
LEFT JOIN page_likes AS b 
ON a.page_id = b.page_id
WHERE b.page_id IS NULL 
GROUP BY a.page_id
ORDER BY a.page_id 




	
-- MID COURSE
/*
Câu hỏi 1:
Question 1:
Level: Basic
Topic: DISTINCT
Task: Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film.
Question: Chi phí thay thế thấp nhất là bao nhiêu?
Answer: 9.99 */
SELECT DISTINCT replacement_cost 
FROM film
ORDER BY replacement_cost 


-- Level: Intermediate
-- Topic: CASE + GROUP BY
-- Task: Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim
-- có chi phí thay thế trong các phạm vi chi phí sau
-- low: 9.99 - 19.99
-- medium: 20.00 - 24.99
-- high: 25.00 - 29.99
-- Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?
-- Answer: 514
SELECT 
 	CASE
		WHEN replacement_cost >= 9.99 AND replacement_cost <= 19.99 THEN 'low'
		WHEN replacement_cost >= 20.00 AND replacement_cost <= 24.99 THEN 'medium'
		WHEN replacement_cost >= 25.00 AND replacement_cost >= 29.99 THEN 'high'
		ELSE 'no_default'
	END AS phan_loai,
COUNT(*)
FROM film 
GROUP BY phan_loai


/* Question 3:
Level: c
Topic: JOIN
Task: Tạo danh sách các film_title  bao gồm tiêu đề (title), độ dài (length) và
tên danh mục (category_name) được sắp xếp theo độ dài giảm dần.
Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?
-- Answer: Sports : 184
SELECT * FROM film
SELECT * FROM category
SELECT * FROM film_category */

SELECT a.title, a.length, c.name, a.description
FROM film AS a
JOIN film_category AS b
ON a.film_id = b.film_id
JOIN category AS c
ON c.category_id = b.category_id
WHERE c.name LIKE '%Drama%' OR c.name LIKE '%Sports%'
ORDER BY a.length DESC


/* Question 4:
Level: Intermediate
Topic: JOIN & GROUP BY
Task: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?
Answer: Sports :74 titles */

SELECT  c.name,
		COUNT(*) AS so_luong
FROM film AS a
JOIN film_category AS b
ON a.film_id = b.film_id
JOIN category AS c
ON c.category_id = b.category_id
GROUP BY c.name
ORDER BY so_luong DESC

/* Question 5:
Level: Intermediate
Topic: JOIN & GROUP BY
Task:Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên
cũng như số lượng phim họ tham gia.
Question: Diễn viên nào đóng nhiều phim nhất?
Answer: Susan Davis : 54 movies */
-- SELECT * FROM film_actor
-- SELECT * FROM actor
-- SELECT * FROM film 

SELECT a.first_name || ' ' || a.last_name AS ho_va_ten,
		COUNT(description) AS so_luong
FROM actor AS a
JOIN film_actor AS b
ON a.actor_id = b.actor_id
JOIN film AS c 
ON c.film_id = b.film_id
GROUP BY ho_va_ten
ORDER BY so_luong DESC



/* Question 6:
Level: Intermediate
Topic: LEFT JOIN & FILTERING
Task: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
Question: Có bao nhiêu địa chỉ như vậy?
Answer: 4 */
-- SELECT * FROM customer
-- SELECT * FROM address

SELECT COUNT(*) AS so_luong
FROM address AS a
LEFT JOIN customer AS c
ON c.address_id = a.address_id
WHERE c.address_id IS NULL


/* Question 7:
Level: Intermediate
Topic: JOIN & GROUP BY
Task: Danh sách các thành phố và doanh thu tương ừng trên từng thành phố
Question: Thành phố nào đạt doanh thu cao nhất ?
Answer: Cape Coral : 221.55 
SELECT * FROM city
SELECT * FROM payment
SELECT * FROM customer
SELECT * FROM address */

SELECT c.city,
	SUM(p.amount) AS total_amount
FROM payment AS p 
JOIN customer AS cu
ON p.customer_id = cu.customer_id
JOIN address AS a
ON a.address_id = cu.address_id
JOIN city AS c
ON c.city_id = a.city_id
GROUP BY c.city
ORDER BY total_amount DESC


/* Question 8:
Level: Intermediate
Topic: JOIN & GROUP BY
Task: Tạo danh sách trả ra 2 cột dữ liệu:
   cột 1: thông tin thành phố và đất nước ( format: “city, country")
   cột 2: doanh thu tương ứng với cột 1
Question: Thành phố của đất nước nào đat doanh thu thấp nhất ?
Answer: United States, Tallahassee : 50.85. */

SELECT ci.city,
		co.country,
		SUM(p.amount) AS total_amount
FROM payment AS p
JOIN customer AS cu
ON p.customer_id = cu.customer_id
JOIN address AS a
ON a.address_id = cu.address_id
JOIN city AS ci
ON ci.city_id = a.city_id
JOIN country AS co
ON co.country_id = ci.country_id 
GROUP BY 1, 2
ORDER BY 3



































