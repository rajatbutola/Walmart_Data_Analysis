SELECT product_line, MIN(total_price) as min_price ,
 MAX(total_price) as max_price from
 (
SELECT product_line, SUM(total) as total_price FROM salesdatawalmart.sales
group by product_line
) as total_table
group by product_line;


------------------------- Feature Engineering ------------------------------------
Select time ,
(case
    when `time` BETWEEN "00:00:00" and "12:00:00" Then "Morning"
    when `time` BETWEEN "12:01:00" and "16:00:00" Then "Afternoon"
    else "Evening"
    end
    ) as time_of_day
from salesdatawalmart.sales;

ALTER Table sales
drop column time_of_day;

ALTER Table sales
add column time_of_day VARCHAR(20);

Update sales
SET time_of_day = (
case
    when `time` BETWEEN "00:00:00" and "12:00:00" Then "Morning"
    when `time` BETWEEN "12:01:00" and "16:00:00" Then "Afternoon"
    else "Evening"
    end
);
select * from sales;
-- - -------- day_name 
select date, dayname(date) as day_name from sales;
ALTER TABLE sales
add column day_name VARCHAR(12);
Update sales
SET day_name = dayname(date);
select * from sales;

-- - -------- month_name 
select date, MONTHNAME(date) as month_name from sales;
ALTER TABLE sales
add column month_name VARCHAR(12);
Update sales
SET month_name = monthname(date);
select * from sales;
-- -------------How many unique cities does the data have?
select count(distinct(city)) from sales;

-- -----in which city is each branch?
select distinct city, branch from sales;

-- ------ how many unique product lines does the data have?
select distinct product_line from sales;
-- what is the most common payment method
select Max(payment_method) from sales;
-- what is the most selling product line?
select product_line, count(product_line) as pl from sales
group by product_line
order by pl Desc;
-- what is the total revenue by month
select month_name, SUM(total) as revenue from sales
group by month_name
order by revenue;
-- what month had the largest COGS?
select month_name, sum(cogs) as maxi from sales
group by month_name
order by maxi Desc;
-- what product line had the largest revenue
select product_line, SUM(total) as revenue from sales
group by product_line
order by revenue desc;
-- what is the city with largest revenue
select city , branch, sum(total) as rev from sales
group by city, branch
order by rev desc;
-- which product line had the largest VAT
select product_line, AVG(VAT) as vat from sales
group by product_line
order by vat desc;
/* fetch each product line and add a column to those product line showing "good", "bad".
 Good if its greater than average sales */
select product_line
from sales
where 
 (case
 when product_line <  (select AVG(total) from sales) then "Good"
 else "bad"
 end);
 -- which branch sold more products than average product sold
 
 
 select branch, SUM(quantity) as qu , AVG(quantity) as avge,
 case 
 when SUM(quantity) > AVG(quantity) then "Good"
 else "bad"
 end as label
 from sales
 group by branch
 order by qu desc;
 -- what is the most common product line by gender?
 select count(product_line) as summ, product_line, gender from sales
 group by product_line , gender
 order by summ desc;
-- what is the average rating of each product line
select product_line , round(avg(rating),2) as avg_rate from sales
group by product_line
order by avg_rate desc;

-- number of sales made in each time of the day per weekdays
select time_of_day, day_name, SUM(total) as sales_per_day from sales
group by time_of_day, day_name
having day_name != "Sunday" and day_name != "Saturday"
order by day_name ,sales_per_day desc;

-- which of the customer types brings the most revenue?
select customer_type, sum(total) as revenue from sales
group by customer_type
order by revenue desc;
-- which city has the largest tax percent/VAT
select city , avg(VAT) as sum_vat from sales
group by city
order by sum_vat desc;
-- which customer type pays the most in VAT
select customer_type, AVG(VAT) as vat from sales
group by customer_type
order by vat desc;

