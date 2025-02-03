CREATE DATABASE IF NOT EXISTS salesDataWalmart;
CREATE TABLE IF NOT EXISTS sales(
	inovice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR (30) NOT NULl,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR (30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT (6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR (15) NOT NULL,
    cogs DECIMAL (10,2) NOT NULL,
    gross_margin_pct FLOAT (11,9),
    gross_income DECIMAL (12,4) NOT NULL,
    rating FLOAT (2,1) 
    
);


-- -------------------------------------------Feature Engineering---------------------------

-- time_of_day 

SELECT 
	time,
    (CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
    ) AS time_of_day 
FROM sales;     

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales 
SET time_of_day = (
	CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
    );
    
    -- Day_name
SELECT 
	Date,
    DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales 
SET day_name = DAYNAME(date);

-- Month_name 

SELECT 
	date,
    MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales 
SET month_name = MONTHNAME(date);
-- -----------------------------------------------------------------------------------------------

-- ------------------------------------------------------Generic------------------------------------------------

-- How many Unuique cities does the data have?

SELECT 
	DISTINCT city 
FROM sales;

-- In Which city is each branch?

SELECT 
	DISTINCT branch 
FROM sales;

SELECT 
	DISTINCT city,
    branch 
FROM sales;

--  ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------Product----------------------------------------------------------------------------

-- How many unique product lines does the data have? 
SELECT 
	DISTINCT product_line
FROM sales;
SELECT 
	COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common ayment method?
SELECT 
payment_method,
	COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- What is the most selling prodcut line?
SELECT 
	product_line,
	COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month?
SELECT 
	month_name AS Month ,
    SUM(total) AS total_revenue 
FROM sales
GROUP BY month_name 
ORDER BY total_revenue
DESC;

-- What month had largest cogs?

SELECT 
	month_name AS month,
	SUM(cogs) AS cogs 
FROM sales 
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue?

SELECT
	product_line,
    SUM(total)as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue
DESC;

-- What is the city with the larget revenue?

SELECT
	branch,
    city,
    SUM(total)as total_revenue
FROM sales
GROUP BY branch, city
ORDER BY total_revenue
DESC;

-- What product line had the largest VAT?

SELECT
	product_line,
    AVG(VAT) AS Avg_tax
FROM sales 
GROUP BY product_line
ORDER BY avg_tax
DESC;

-- Which branch sold more product than average product sold?

SELECT	
	branch ,
    SUM(quantity) AS Qty
FROM sales 
GROUP BY branch 
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?

SELECT 
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender,product_line
ORDER BY total_cnt
DESC;

-- What is the average rating of each produc line?

SELECT
	ROUND(AVG(rating),2) AS Avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating
DESC;			

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------SALES--------------------------------------------------------------------------


-- No.of Sales made in each time of day per weekday 9

SELECT
	time_of_day,
    COUNT(*) AS total_sales 
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which typye of customer type brings most revenue?

SELECT
	customer_type,
    SUM(total) AS total_rev
 FROM sales
 GROUP BY customer_type
 ORDER BY total_rev DESC;
 
 -- Which city has the largest TAx % / VAT (Value Added TAx) ?
 
SELECT 
	city,
    AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays most in VAT?


SELECT 
	customer_type,
    AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------CUSTOMERS---------------------------------------------------------------------------------------

-- How may unique customer types does the data have?

SELECT 
	DISTINCT(customer_type)
FROM sales;

-- How many unique payment methods does the data have?

SELECT 
	DISTINCT(payment_method)
FROM sales;

-- What is the most common customer type?

SELECT 
	customer_type,
	COUNT(customer_type)
FROM sales
GROUP BY customer_type 
ORDER BY customer_type;

-- Which is customer type which buys the most?

SELECT 
	customer_type,
    COUNT(*) AS customer_cnt
FROM sales
GROUP BY customer_type;

-- What is the mostr common gender?

SELECT 
	 gender,
     COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per brach?

SELECT 
	 gender,
     COUNT(*) AS gender_cnt
FROM sales
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What time of the day do customers give most rating?

SELECT 
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- which time of the day do customers gie per branch?

SELECT 
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day of ythe week has best rating?

SELECT 
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?

SELECT 
	day_name,
    AVG(rating) AS avg_rating
    
FROM sales
WHERE branch = "C"
GROUP BY day_name 
ORDER BY avg_rating DESC;














    
    
    
    
    
    
    




















