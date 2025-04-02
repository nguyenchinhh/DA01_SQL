-- Buổi 17: DDL, DML
/* Ouput:
+ Cách dùng câu lệnh DDL(Data Definition Language) để định nghĩa đối tượng trong DB: CREATE ; ALTER; DROP
+ Cách dùng câu lệnh DDL(Data Manipulation Language) để thao tác, quản lý dữ liệu : INSERT; DELETE; TRUNCATE
- Các loại câu lệnh SQL:
+ DQL(Data Query Language) : lệnh truy vấn
+ DDL(Data Definition Language): lệnh định nghĩa xây dựng và quản lý đối tượng trong DB
+ DML(Data Manipulation Language): lệnh thay đổi giá trị dữ liệu trong bảng
+ DCL(Data Control Language): thao tác quản lý bảo mật dữ liệu và phân quyền đối tượng người dùng
+ TCL(Transaction COntrol Language)
*/

-- 1. Today's plan

-- 2. DDL & DML

-- 3.Các đối tượng trong database
SELECT * FROM actor

SELECT * FROM actor_info

SELECT a.actor_id,
    a.first_name,
    a.last_name,
    group_concat(DISTINCT (c.name || ': '::text) || (( SELECT group_concat(f.title) AS group_concat
           FROM film f
             JOIN film_category fc_1 ON f.film_id = fc_1.film_id
             JOIN film_actor fa_1 ON f.film_id = fa_1.film_id
          WHERE fc_1.category_id = c.category_id AND fa_1.actor_id = a.actor_id
          GROUP BY fa_1.actor_id))) AS film_info
   FROM actor a
     LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
     LEFT JOIN film_category fc ON fa.film_id = fc.film_id
     LEFT JOIN category c ON fc.category_id = c.category_id
  GROUP BY a.actor_id, a.first_name, a.last_name;



-- 4.CREATE OR DROP TABLE
-- DDL : CREATE-DROP-ALTER
CREATE TABLE manager
(
	manager_id INT PRIMARY KEY,
	user_name VARCHAR(20) UNIQUE,
	first_name VARCHAR(50),
	last_name VARCHAR(50) DEFAULT 'No info',
	date_of_birth DATE,
	address_id INT
)

DROP TABLE manager

-- truy vấn dữ liệu lấy ra danh sách khách hàng và địa chỉ tương ứng
-- sau đó lưu thông tin đó vào bảng đặt tên là customer_info
-- (customer_id, full_name, email, address)
CREATE TABLE customer_info AS (
SELECT customer_id, first_name || ' ' || last_name AS full_name, email, b.address
FROM customer AS a
JOIN address AS b ON a.address_id = b.address_id);

SELECT * FROM customer_info


-- 5. CREATE TEMPORY TABLE
-- DDL : CREATE-DROP-ALTER
-- truy vấn dữ liệu lấy ra danh sách khách hàng và địa chỉ tương ứng
-- sau đó lưu thông tin đó vào bảng đặt tên là customer_info
-- (customer_id, full_name, email, address)
CREATE GLOBAL TEMP TABLE temp_customer_info AS (
SELECT customer_id, first_name || ' ' || last_name AS full_name, email, b.address
FROM customer AS a
JOIN address AS b ON a.address_id = b.address_id)

SELECT * FROM temp_customer_info

-----
WITH temp_customer_info AS (
SELECT customer_id, first_name || ' ' || last_name AS full_name, email, b.address
FROM customer AS a
JOIN address AS b ON a.address_id = b.address_id)
SELECT * FROM temp_customer_info


-- 6.CREATE VIEW
-- truy vấn dữ liệu lấy ra danh sách khách hàng và địa chỉ tương ứng
-- sau đó lưu thông tin đó vào bảng đặt tên là customer_info
-- (customer_id, full_name, email, address)
CREATE OR REPLACE VIEW view_customer_info AS (
SELECT customer_id, first_name || ' ' || last_name AS full_name, email, b.address,
		a.active
FROM customer AS a
JOIN address AS b ON a.address_id = b.address_id)

SELECT * FROM view_customer_info

DROP VIEW view_customer_info



-- 7.CREATE VIEW  SOLUTION
/* Tạo View có tên movies_category hiển thị danh sách các film bao gồm
title, length, category name được sắp xếp giảm dần theo length
Lọc kết quả để chỉ những phim trong danh mục 'Action' và 'Comedy'
*/

CREATE OR REPLACE VIEW movies_category AS (
SELECT a.title, a.length, c.name AS category_name
FROM film AS a
JOIN film_category AS b ON a.film_id = b.film_id
JOIN category AS c ON c.category_id = b.category_id
ORDER BY a.length DESC )

SELECT * FROM movies_category
WHERE category_name IN ('Action', 'Comedy')


-- 8. ALTER TABLE
-- ADD, DELETE columns
ALTER TABLE manager
DROP first_name

ALTER TABLE manager
ADD column first_name VARCHAR(50)

-- RENAME columns
ALTER TABLE manager
RENAME column first_name TO ten_kh

-- ALTER datatypes
ALTER TABLE manager
ALTER COLUMN ten_kh TYPE text

SELECT * FROM manager	



-- 9.INSERT 
-- DML: INSERT ,UPDATE, DELETE, TRUNCATE
SELECT * FROM city
WHERE city_id = 3

INSERT INTO city
VALUES (1000, 'A', 44, '2020-01-01 16:40:20')

INSERT INTO city VALUES
(1001,'B', 33,'2022-08-28 10:00:10')

INSERT INTO city (city, country_id)
VALUES ('C', 44)

UPDATE city
SET country_id = 100
WHERE city_id = 3



-- 10.UPDATE SOLUTION
-- CHALLENGE
/*
1. Update giá cho thuê film 0.99 thành 1.99.
2. Điều chỉnh bảng customer như sau:
  + Thêm cột initials (data type varchar(10))
  + Update dữ liệu vào cột initials
  	Ví dụ: Frank Smith should be F.S
*/

SELECT * FROM film
WHERE rental_rate = 1.99

UPDATE film
SET rental_rate = 1.99
WHERE rental_rate = 0.99

-----
SELECT * FROM customer

ALTER TABLE customer
ADD column initials VARCHAR(10)

UPDATE customer
SET initials = SUBSTR(first_name,1,1) || '.' || SUBSTR(last_name,1,1)




-- 11.DELETE & TRUNCATE
-- DML: INSERT, UPDATE, DELETE, TRUNCATE
INSERT INTO manager
VALUES (1, 'HAPT', 'Tran', '1997-01-01',20,'Ha'),
(2, 'NGANDP', 'Doan', '1987-01-01',12,'Ngan'),
(3, 'DUNGHT', 'Hoang', '1991-02-10',19,'Thao');

SELECT * FROM manager


DELETE FROM manager
WHERE manager_id = 1

TRUNCATE TABLE manager
























