-- Q1.Write a query to return the email, first name & last name of all rock music listeners. Return the list ordered alphabetically by email.
select distinct c.email, c.first_name, c.last_name 
from customer c 
join invoice i on c.customer_id=i.customer_id 
join invoice_line il on i.invoice_id=il.invoice_id 
join track t on il.track_id=t.track_id 
join genre g on t.genre_id=g.genre_id 
where g.name='Rock'
order by c.email;

-- Q2. Write a query that returns the artist name and total track count of the top 10 rock bands.
select a.name, count(*) as totaltrack 
from artist a 
join album al on a.artist_id=al.artist_id 
join track t on al.album_id=t.album_id 
join genre g on t.genre_id=g.genre_id
where g.name='Rock' 
group by a.name 
order by totaltrack desc limit 10;

-- Q3. Return all the track names that have a song length longer than the average song length. Return the name and millisecond for each track. Order by the song length with the longest songs listed first.
select name, milliseconds from track 
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;