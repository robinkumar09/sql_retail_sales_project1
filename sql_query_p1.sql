create database sql_project_p2

Create table retail_sales(
transactions_id int primary key ,
sale_date date,
sale_time time,
customer_id int	,
gender varchar(15),
age int	,
category varchar(18),
quantiy	int,
price_per_unit float,
cogs float,
total_sale float
);

select *  from retail_sales

select * from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null 
or
quantiy is null 
or
cogs is null
or
total_sale is null ;



delete from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null 
or
quantiy is null 
or
cogs is null
or
total_sale is null ;


--data exploration 

--- how many sales we have??

select count(*) as total_sales from retail_sales

--how many unique customers we have ??

select count(distinct customer_id) as total_customer from retail_sales

-- Data Analysis & Business Key Problems & Answers

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

select * from retail_sales
where sale_date ='2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category ,count(transactions_id) as total_sales ,sum(total_sale) as net_sale
from retail_sales
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg(age) as average_age
from retail_sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
	
select transactions_id
from retail_sales
where total_sale >'1000'


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,
gender,
count(transactions_id) as total_transaction
from retail_sales
group by category,gender
order by gender


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from
(
select
extract(year from sale_date) as year,
extract(month from sale_date) as month ,
(avg(total_sale),2) as average_sale,
rank() over( partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2
) as t1
where rank =1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


