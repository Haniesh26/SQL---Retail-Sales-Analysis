-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;

-- Create Table
DROP table IF exists retail_sales ;

CREATE TABLE retail_sales (
	transactions_id	INT PRIMARY KEY,
    sale_date DATE,
	sale_time TIME,
    customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT * FROM retail_sales
LIMIT 10;

SELECT Count(*)
FROM retail_sales;

SELECT * FROM retail_sales
WHERE
	transactions_id is NULL
    OR
    sale_date is NULL
    OR
    sale_time is NULL
    OR 
    gender is NULL
    OR 
    category is NULL
    OR 
    quantiy is NULL
    OR 
    cogs is NULL 
    OR 
    total_sale is NULL;
    
SELECT * FROM retail_sales
WHERE total_sale is NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business key Problems and answers
-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'
ORDER BY gender;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'  AND quantiy = 4 AND DATE_FORMAT(sale_date , '%Y-%m') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category , SUM(total_sale) as net_sale, Count(*) as total_orders 
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category , ROUND(AVG(age) , 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail_sales
WHERE total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT COUNT(transactions_id) , gender , category
FROM retail_sales
GROUP BY gender , category
Order BY 3;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM
(
SELECT 	
		DATE_FORMAT(sale_date , '%m') as a_month,
		DATE_FORMAT(sale_date , '%y') as a_year ,
		ROUND(Avg(total_sale),2) as avg_month_sales ,
        row_number() OVER(Partition BY DATE_FORMAT(sale_date , '%y') ORDER BY avg(total_sale) DESC) as num_rank
FROM retail_sales
GROUP BY a_year , a_month ) as t1
WHERE num_rank = 1;
-- ORDER BY a_year , avg_month_sales DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id , SUM(total_sale) as total
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category , COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN DATE_FORMAT(sale_time , '%H' ) <=12
			THEN 'Morning'
        WHEN  DATE_FORMAT(sale_time , '%H' ) BETWEEN 12 AND 17 
			THEN 'Afternoon'
        WHEN  DATE_FORMAT(sale_time , '%H' ) >17 
			THEN 'Evening'
        ELSE 'NULL'
	END as shift
FROM retail_sales
)
SELECT COUNT(transactions_id) as total_order , shift
FROM hourly_sale 
GROUP BY shift;







