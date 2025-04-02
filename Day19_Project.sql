-- 1.Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER)

alter table sales_dataset_rfm_prj
alter priceeach type numeric

ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN priceeach
TYPE numeric USING (trim(priceeach)::numeric);

ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN quantityordered
TYPE INT USING (trim(quantityordered)::INT);

ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN orderlinenumber
TYPE INT USING (trim(orderlinenumber)::INT);

ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN sales
TYPE numeric USING (trim(sales)::numeric);

ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN msrp
TYPE INT USING (trim(msrp)::INT);


ALTER TABLE sales_dataset_rfm_prj 
ALTER COLUMN orderdate 
SET DATA TYPE date USING to_date(trim(orderdate), 'MM/DD/YYYY');


-- 2. Check NULL/BLANK (‘’)
SELECT *
FROM sales_dataset_rfm_prj
WHERE (ordernumber IS NULL OR ordernumber = '')
   OR (quantityordered IS NULL OR quantityordered = '')
   OR (priceeach IS NULL OR priceeach = '')
   OR (orderlinenumber IS NULL OR orderlinenumber = '')
   OR (sales IS NULL OR sales = '')
   OR (orderdate IS NULL OR orderdate = '');

-- 3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME 
/* Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa,
chữ cái tiếp theo viết thường. */
ALTER TABLE sales_dataset_rfm_prj 
ADD column CONTACTLASTNAME VARCHAR(50)

ALTER TABLE sales_dataset_rfm_prj
ADD column CONTACTFIRSTNAME VARCHAR(50)


-- Tách dữ liệu
UPDATE sales_dataset_rfm_prj
SET 
    CONTACTLASTNAME = SPLIT_PART(CONTACTFULLNAME, '-', 1),
    CONTACTFIRSTNAME = SPLIT_PART(CONTACTFULLNAME, '-', 2)
WHERE CONTACTFULLNAME LIKE '%-%';


UPDATE sales_dataset_rfm_prj
SET 
	CONTACTLASTNAME = INITCAP(CONTACTLASTNAME),
	CONTACTFIRSTNAME = INITCAP(CONTACTFIRSTNAME)
WHERE CONTACTLASTNAME IS NOT NULL AND CONTACTFIRSTNAME IS NOT NULL


-- 4.Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE
ALTER TABLE sales_dataset_rfm_prj
ADD column QTR_ID VARCHAR(20)

ALTER TABLE sales_dataset_rfm_prj
ADD column MONTH_ID VARCHAR(20)

ALTER TABLE sales_dataset_rfm_prj
ADD column YEAR_ID VARCHAR(20)

UPDATE sales_dataset_rfm_prj
SET qtr_id = EXTRACT(quarter FROM orderdate);

UPDATE sales_dataset_rfm_prj
SET month_id = EXTRACT(month FROM orderdate);


UPDATE sales_dataset_rfm_prj
SET year_id = EXTRACT(year FROM orderdate);

/* 5.Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED
và hãy chọn cách xử lý cho bản ghi đó (2 cách) 
( Không chạy câu lệnh trước khi bài được review)
*/
-- sử dụng IQR/ BoxPLOT tìm ra outlier
WITH txt_min_max_value AS (
SELECT Q1 - 1.5*IQR AS min_value,
	   Q3 - 1.5*IQR AS max_value,
select
percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) - percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS IQR
FROM sales_dataset_rfm_prj) AS a

SELECT * FROM sales_dataset_rfm_prj
WHERE quantityordered < (SELECT min_value FROM txt_min_max_value)
	OR quantityordered > (SELECT max_value FROM txt_min_max_value)


-- 6. Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN


SELECT *
FROM sales_dataset_rfm_prj
