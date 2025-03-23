

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













































