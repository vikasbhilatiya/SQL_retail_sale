----- SQL Retail Sales Analysis --- 

CREATE DATABASE project_1;
USE project_1;
SELECT * FROM retails_sales;

CREATE TABLE retails_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

----- Data cleaning -----

SELECT * FROM retails_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL
    OR total_sale IS NULL;

DELETE FROM retails_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR 
    total_sale IS NULL;
    
    
----- Data Exploration -----    

----- How many sales we have?
SELECT COUNT(*) as total_sale FROM retails_sales;

----- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) FROM retails_sales;

----- How many unique category we have?
SELECT DISTINCT category FROM retails_sales; 

----- Data Analysis -----

----- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT *
FROM retails_sales
WHERE sale_date = '2022-11-05';

----- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT 
  *
FROM retails_sales
WHERE 
    category = 'Clothing'
    AND 
    sale_date  between '2022-11-01' and '2022-11-30'
    AND
    quantity >= 4;
    
    ----- Write a SQL query to calculate the total sales (total_sale) for each category.:
    
    SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retails_sales
GROUP BY 1;

----- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retails_sales
WHERE category = 'Beauty';

----- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retails_sales
WHERE total_sale > 1000;

----- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retails_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;

----- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    YEAR ( sale_date) as year,
    MONTH (sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY YEAR (sale_date) ORDER BY AVG(total_sale) DESC) as ran_k
FROM retails_sales
GROUP BY 1, 2
) as t1
where ran_k = 1;




----- **Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retails_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

----- Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retails_sales
GROUP BY category;

----- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retails_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;




