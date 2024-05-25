use wallmart;
select * from walmart;

-- Add the time_of_day column
ALTER TABLE walmart ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
SET SQL_SAFE_UPDATES = 0;

UPDATE walmart
SET time_of_day = (
	CASE
		WHEN `Time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `Time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_name column
ALTER TABLE walmart ADD COLUMN day_name VARCHAR(10);

UPDATE walmart
SET day_name = DAYNAME(Date);

-- Add month_name column
ALTER TABLE walmart ADD COLUMN month_name VARCHAR(10);

UPDATE walmart
SET month_name = monthname(Date);

-- --------------------------------------------------------------------
-- ---------------------------- Generic -------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM walmart;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM walmart;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------
-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM walmart;

-- What is the most selling product line
SELECT
	product_line,
	SUM(quantity) as qty
FROM walmart
GROUP BY product_line
ORDER BY qty DESC;

-- What is the total revenue by month
SELECT
	month_name AS month,
	ROUND(SUM(total),2) AS total_revenue
FROM walmart
GROUP BY month_name 
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT
	month_name AS month,
	ROUND(SUM(cogs),2) AS cogs
FROM walmart
GROUP BY month_name 
ORDER BY cogs DESC;

-- What product line had the largest revenue?
SELECT
	product_line,
	ROUND(SUM(total),2) as total_revenue
FROM walmart
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city had the highest revenue?
SELECT
	city,
	ROUND(SUM(total),2) AS total_revenue
FROM walmart
GROUP BY city 
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(Tax_five_percent) as avg_tax
FROM walmart
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > (SELECT AVG(quantity) AS avg_qnty FROM walmart) THEN "Good"
        ELSE "Bad"
    END AS remark
FROM walmart
GROUP BY product_line;

-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM walmart
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walmart);

-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM walmart
GROUP BY gender, product_line
ORDER BY gender,total_cnt DESC;

-- What is the average rating of each product line
SELECT
	product_line,
	ROUND(AVG(Rating), 2) as avg_rating
FROM walmart
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------
-- How many unique customer types does the data have?
SELECT
	DISTINCT Customer_type
FROM walmart;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT Payment
FROM walmart;

-- What is the most common customer type?
SELECT
	Customer_type,
	count(*) as count
FROM walmart
GROUP BY Customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	Customer_type,
    COUNT(*)
FROM walmart
GROUP BY Customer_type;

-- What is the gender of most of the customers?
SELECT
	Gender,
	COUNT(*) as gender_cnt
FROM walmart
GROUP BY Gender
ORDER BY gender_cnt DESC;

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Which time of the day customers do most shopping?
SELECT
	time_of_day,
	COUNT(*) as no_of_transaction
FROM walmart
GROUP BY time_of_day
ORDER BY no_of_transaction DESC;

-- Which day of the week customers do most shopping?
SELECT
	day_name,
	COUNT(*) as no_of_transaction
FROM walmart
GROUP BY day_name
ORDER BY no_of_transaction DESC;

-- Which of the customer types brings the most revenue?
SELECT
	Customer_type,
	ROUND(SUM(total),2) AS total_revenue
FROM walmart
GROUP BY Customer_type
ORDER BY total_revenue DESC;

-- Which customer type pays the most in VAT?
SELECT
	Customer_type,
	ROUND(AVG(Tax_five_percent),2) AS total_tax
FROM walmart
GROUP BY Customer_type
ORDER BY total_tax DESC;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(Tax_five_percent), 2) AS avg_tax_pct
FROM walmart
GROUP BY city 
ORDER BY avg_tax_pct DESC;
