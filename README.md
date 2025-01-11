# MusicStore-SQL

This repository contains the SQL queries I wrote to analyze a music store database. 

## Database Schema

The music store database schema is as follows:

* album (album_id, title, artist_id)
* artist (artist_id, name)
* customer (customer_id, first_name, last_name, company, address, city, state, country, postal_code, phone, fax, email, support_rep_id)
* employee (employee_id, last_name, first_name, title, reports_to, levels, birthdate, hire_date, address, city, state, country, postal_code, phone, fax, email)
* genre (genre_id, name)
* invoice (invoice_id, customer_id, invoice_date, billing_address, billing_city, billing_state, billing_country, billing_postal, total)
* invoice_line (invoice_line_id, invoice_id, track_id, unit_price, quantity)
* media_type (media_type_id, name)
* playlist (playlist_id, name)
* playlist_track (playlist_id, track_id)
* track (track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price)

## SQL Queries

This repository includes SQL queries for the following purposes:

**Easy Level Queries:**

1. **Who is the senior most employee based on job title?**

   ```sql
   select * from employee
   order by levels desc
   limit 1;

2. **Write a query that shows the countries with their number of invoices in descending order of number?**

   ```sql
   select count(*), billing_country
   from invoice 
   group by billing_country
   order by count(*) desc;

3. **What are the top 3 values of total invoice?**

   ```sql
   select total from invoice 
   order by total desc limit 3;

4. **Which city has the best customers? We would like to throw a promotional music festival in the city we made the most money. Write a query that returns the cities and the sum of their invoice totals. Return both the city name and sum of all invoice totals of that city.**

   ```sql
   select billing_city, sum(total) from invoice 
   group by billing_city order by sum(total) desc;

5. **Who is the best customer? The customer who has spent the most money will be considered the best customer. Write a query that returns the person who has spent the most money.**

   ```sql
   select c.customer_id, c.first_name, c.last_name, sum(i.total) as total 
   from customer c join invoice i on c.customer_id=i.customer_id 
   group by c.customer_id 
   order by sum(i.total) desc
   limit 1;

**Medium Level Queries:**

1. **Write a query to return the email, first name & last name of all rock music listeners. Return the list ordered alphabetically by email.**

   ```sql
   select distinct c.email, c.first_name, c.last_name 
   from customer c 
   join invoice i on c.customer_id=i.customer_id 
   join invoice_line il on i.invoice_id=il.invoice_id 
   join track t on il.track_id=t.track_id 
   join genre g on t.genre_id=g.genre_id 
   where g.name='Rock'
   order by c.email;

2. **Write a query that returns the artist name and total track count of the top 10 rock bands.**
   ```sql
   select a.name, count(*) as totaltrack 
   from artist a 
   join album al on a.artist_id=al.artist_id 
   join track t on al.album_id=t.album_id 
   join genre g on t.genre_id=g.genre_id
   where g.name='Rock' 
   group by a.name 
   order by totaltrack desc limit 10;

3. **Return all the track names that have a song length longer than the average song length. Return the name and millisecond for each track. Order by the song length with the longest songs listed first.**
   ```sql
   select name, milliseconds from track 
   where milliseconds > (select avg(milliseconds) from track)
   order by milliseconds desc;

**Advanced Level Queries**
1. **Find the amount spent by each customer on the best selling artist. Write a query to return customer name, artist name and total amount spent on the best selling artist.**
   ```sql
   with best_selling_artist as(
   select a.artist_id as artistid, a.name as artistname, sum(il.unit_price*il.quantity) as total
   from invoice_line il 
   join track t on t.track_id=il.track_id 
   join album al on al.album_id=t.album_id 
   join artist a on a.artist_id=al.artist_id
   group by 1
   order by 3 desc
   limit 1
   )
   select c.customer_id, c.first_name, c.last_name, bsa.artistname, sum(il.unit_price*il.quantity) as amount_spent
   from invoice i 
   join customer c on i.customer_id=c.customer_id 
   join invoice_line il on il.invoice_id=i.invoice_id 
   join track t on il.track_id=t.track_id 
   join album al on al.album_id=t.album_id 
   join best_selling_artist bsa on bsa.artistid=al.artist_id
   group by 1,2,3,4
   order by 5 desc;

2. **We want to find out the most popular music genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with   the top genre. For countries where the maximum number of purchases is shared, return all genres.**
   ```sql
   with popular_genre as(
   select count(il.quantity) as purchases, c.country, g.name, g.genre_id,
   row_number() over(partition by c.country order by count(il.quantity) desc) as rowno
   from invoice_line il 
   join invoice i on il.invoice_id=i.invoice_id
   join customer c on c.customer_id=i.customer_id
   join track t on il.track_id=t.track_id
   join genre g on g.genre_id=t.genre_id
   group by 2,3,4
   order by 2, 1 desc
   )
   select * from popular_genre where rowno=1;

3. **Write a query that determines the customer who spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent that amount.**

   ```sql
   with customer_with_country as(
   select c.customer_id, c.first_name, c.last_name, i.billing_country, sum(i.total) as total_spending,
   row_number() over(partition by i.billing_country order by sum(i.total) desc) as rowno
   from invoice i
   join customer c on c.customer_id=i.customer_id
   group by 1,2,3,4
   order by 4, 5 desc)
   select * from customer_with_country where rowno=1;

## Files
- **Music_Store_database.sql** : Contains the SQL script to create the database and populate it with data.
- **musicstore_sql_easy.sql** : Contains the SQL queries for the easy level questions.
- **musicstore_sql_medium.sql** : Contains the SQL queries for the medium level questions.
- **musicstore_sql_advanced.sql** : Contains the SQL queries for the advanced level questions.
- **README.md** : This file.
