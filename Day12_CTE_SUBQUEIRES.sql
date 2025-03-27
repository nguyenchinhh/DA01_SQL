-- 1.Today's Plan

-- 2.SUBQUERIES IN WHERE 
-- SUBQUERIES 
-- Tìm những hóa đơn có số tiền lớn hơn số tiền trung bình các hóa đơn
SELECT AVG(amount) FROM payment;

SELECT * 
FROM payment
WHERE amount > (SELECT AVG(amount)
FROM payment)

-- Tìm những hóa đơn của khách hàng có tên là Adam
SELECT customer_id 	FROM customer
WHERE first_name = 'ADAM';

SELECT * FROM payment
WHERE customer_id IN (SELECT customer_id FROM customer
)

-- CHALLENGE : Tìm những bộ phim có thời lượng lớn hơn trung bình các bộ phim
SELECT film_id, title
FROM film
WHERE length > (SELECT AVG(length) FROM film)

-- Tìm những bộ film có ở store 2 ít nhất 3 lần
SELECT film_id, title FROM film
WHERE film_id IN (SELECT film_id
FROM public.inventory
WHERE store_id = 2
GROUP BY film_id
HAVING COUNT(*) >= 3)

-- Tìm những khách hàng đền từ California và đã chi tiêu nhiều hơn 100
-- chưa có california
SELECT customer_id, first_name, last_name, email FROM customer 
WHERE customer_id IN (SELECT customer_id FROM payment
group by customer_id
having sum(amount) > 100 )

-- cách 2: 
SELECT * FROM customer
SELECT * FROM address
SELECT * FROM payment

SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customer c
INNER JOIN address a
ON c.address_id = a.address_id
WHERE a.district = 'California'
	AND customer_id IN (SELECT customer_id FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100)

	

-- 3.SUBQUERIES IN FROM 
-- SUBQUERIES 
-- TÌM những khách hàng có nhiều hơn 30 hóa đơn
SELECT customer.first_name, new_table.so_luong FROM 
(SELECT customer_id, count(payment_id) AS so_luong
FROM payment
GROUP BY customer_id) AS new_table
JOIN customer ON new_table.customer_id = customer.customer_id
WHERE so_luong > 30


-- 4.SUBQUERIES IN SELECT 
SELECT *,
(SELECT MAX(amount) FROM payment)
FROM payment

-- CHALLENGE 
/* Tìm chênh lệch giữa số tiền từng hóa đơn so với số tiền 
 thanh toán lớn nhất mà công ty nhận được*/
SELECT payment_id, amount,
		(SELECT MAX (amount) FROM payment),
		(SELECT MAX (amount) FROM payment) - amount AS diff
FROM payment



-- 5. CORRELATED SUBQUERIES IN WHERE (truy vấn tương quan con)
-- lấy ra thông tin khác hàng từ bảng customer có tổng hóa đơn > 100$

SELECT *
FROM customer
WHERE customer_id IN (SELECT customer_id 
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100)


SELECT *
FROM customer AS c
WHERE customer_id = (SELECT customer_id 
FROM payment AS p
WHERE c.customer_id = p.customer_id
GROUP BY customer_id
HAVING SUM(amount) > 100)

SELECT *
FROM customer AS c
WHERE EXISTS (SELECT customer_id 
FROM payment AS p
WHERE c.customer_id = p.customer_id
GROUP BY customer_id
HAVING SUM(amount) > 100)


  
-- 5. CORRELATED SUBQUERIES IN SELECT
-- CORRELATED SUBQUERIES (truy vấn tương quan con)
-- mã KH, tên KH, mã thanh toán, số tiền lớn nhất của từng khách hàng
SELECT a.customer_id, a.first_name || ' ' || a.last_name, b.payment_id,
		(SELECT MAX(amount) FROM payment
WHERE customer_id = a.customer_id
GROUP BY customer_id
)
FROM customer	AS a
JOIN payment AS b
ON a.customer_id = b.customer_id
GROUP BY 1, 2, 3
ORDER BY a.customer_id

/* CHALLENGE : Liệt kê các khoản thanh toán với tổng số hóa đơn và tổng số tiền
mỗi khách hàng phải trả */
-- cách 1
SELECT a.*, b.count_payment, b.sum_amount
FROM payment AS a
JOIN (SELECT customer_id,
		COUNT(*) AS count_payment,
		SUM(amount) AS sum_amount
FROM payment 
GROUP BY customer_id) b ON a.customer_id = b.customer_id

-- cách 2
SELECT a.*, 
	(SELECT
		COUNT(*) AS count_payment
FROM payment AS b
WHERE a.customer_id = b.customer_id
GROUP BY customer_id) AS count_payment,
(SELECT
		SUM(amount) AS count_payment
FROM payment AS b
WHERE a.customer_id = b.customer_id
GROUP BY customer_id) AS sum_amount
FROM payment AS a

/* Lấy danh sách các film có chi phí thay thế lớn nhất trong mỗi loại rating.
Ngoài film_id, title, rating, chi phí thay thế (replacement_cost) cần hiển thị thêm
chi phí thay thế trung bình mỗi loại rating đó */ 
SELECT film_id, title, rating, replacement_cost,
(SELECT AVG(replacement_cost) 
FROM film a
WHERE a.rating = b.rating
GROUP BY rating)
FROM film b
WHERE replacement_cost = (SELECT MAX(replacement_cost)
FROM film AS c
WHERE c.rating = b.rating
GROUP BY rating)



-- 6.CTE

-- CTEs
/*Tìm khách hàng có nhiều hơn 30 hóa đơn, kết quả trả ra gồm các thông tin: mã KH, tênKH
số lượng hóa đơn, tổng số tiền, thời gian thuê trung bình 
*/
WITH twt_total_payment AS (
SELECT customer_id,
	COUNT(payment_id) AS so_luong,
	SUM(amount) AS so_tien
FROM payment
GROUP BY customer_id),
twt_avg_rental_time AS (
SELECT customer_id,
	AVG(return_date - rental_date) AS rental_time
FROM rental
GROUP BY customer_id
)
SELECT a.customer_id, a.first_name, b.so_luong, b.so_tien,c.rental_time
FROM customer AS a
JOIN twt_total_payment AS b 
ON a.customer_id = b.customer_id
JOIN twt_avg_rental_time AS c
ON c.customer_id = a.customer_id
WHERE b.so_luong > 30;




/*Tìm những hóa đơn có só tiền cao hơn số tiền trung bình của khác hàng đó chi tiêu trên mỗi hóa đơn 
kết quả trả ra gồm các thông tin: mã KH, tênKH
số lượng hóa đơn, số tiền, số tiền trung bình của khác hàng đó.
*/
WITH ex1 AS (
SELECT customer_id, 
		COUNT(payment_id) AS so_luong
FROM payment 
GROUP BY customer_id ),
twt_avg_amount AS (
SELECT customer_id, 
	AVG(amount) AS avg_amount
FROM payment 
GROUP BY customer_id 
)
SELECT a.customer_id, a.first_name, b.so_luong, d.amount,  c.avg_amount
FROM customer AS a 
JOIN ex1 AS b ON a.customer_id = b.customer_id
JOIN twt_avg_amount AS c ON c.customer_id = a.customer_id
JOIN payment AS d ON d.customer_id = a.customer_id
WHERE d.amount > c.avg_amount	





-- 5 bài tập thêm
-- 1. Tìm danh sách khách hàng đã từng thuê phim nhưng chưa từng thanh toán
SELECT * FROM customer
SELECT * FROM film
SELECT * FROM rental
SELECT * FROM payment

SELECT * 
FROM customer 
WHERE customer_id IN (
	SELECT customer_id FROM rental
	WHERE customer_id NOT IN (SELECT customer_id FROM payment)
)

SELECT customer_id, first_name, last_name  
FROM customer  
WHERE customer_id IN (  
    SELECT customer_id FROM rental  
    WHERE customer_id NOT IN (SELECT customer_id FROM payment)  
);



-- 2. Tìm phim có số lần thuê nhiều nhất
SELECT * FROM film
SELECT * FROM rental
SELECT * FROM inventory

SELECT film_id,  title FROM film
WHERE film_id IN (
	SELECT film_id
	FROM inventory
	WHERE inventory_id IN (
		SELECT inventory_id FROM rental
		GROUP BY inventory_id
		ORDER BY COUNT(*) DESC
		LIMIT 1
	)
)


-- 3. Tìm các thành phố có khách hàng nhưng không có cửa hàng
SELECT * FROM city
SELECT * FROM address

SELECT city_id, city
FROM city
WHERE city_id IN (
	SELECT city_id 
	FROM address
	WHERE address_id IN(
		SELECT address_id FROM customer
	)
	AND city_id NOT IN(
		SELECT city_id
		FROM address
		WHERE address_id IN(
			SELECT address_id FROM store
		)
	)
)


SELECT city  
FROM city  
WHERE city_id IN (  
    SELECT city_id FROM address WHERE address_id IN (SELECT address_id FROM customer)  
)  
AND city_id NOT IN (  
    SELECT city_id FROM address WHERE address_id IN (SELECT address_id FROM store)  
);

-- 4. Tìm khách hàng đã thanh toán số tiền cao hơn mức thanh toán trung bình
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > (SELECT avg(amount) FROM payment)
) 

-- 5. Tìm các bộ phim không có trong bất kỳ kho (inventory) nào
SELECT * FROM film 
SELECT * FROM inventory

SELECT * FROM film
WHERE film_id NOT IN (
	SELECT film_id
	FROM inventory
	GROUP BY film_id
)
















































