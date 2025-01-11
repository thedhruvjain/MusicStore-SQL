-- Q1.Who is the senior most employee based on job title?
select * from employee
order by levels desc
limit 1;  --higher the level higher the job title

-- Q2.Write a query that shows the countries with their number of invoices in descending order of number?
select count(*), billing_country
from invoice 
group by billing_country
order by count(*) desc;

-- Q3.What are the top 3 values of total invoice?
select total from invoice 
order by total desc limit 3;

-- Q4.Which city has the best customers? We would like to throw a promotional music festival in the city we made the most money. Write a query that returns the cities and the sum of their invoice totals. Return both the city name and sum of all invoice totals of that city.
select billing_city, sum(total) from invoice 
group by billing_city order by sum(total) desc;

-- Q5.Who is the best customer? The customer who has spent the most money will be considered the best customer. Write a query that returns the person who has spent the most money.
select c.customer_id, c.first_name, c.last_name, sum(i.total) as total 
from customer c join invoice i on c.customer_id=i.customer_id 
group by c.customer_id 
order by sum(i.total) desc
limit 1;
