-- Q1.Find the amount spent by each customer on the best selling artist. Write a query to return customer name, artist name and total amount spent on the best selling artist.
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

-- Q2.We want to find out the most popular music genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top genre. For countries where the maximum number of purchases is shared, return all genres.
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

-- Q3.Write a query that determines the customer who spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent that amount.
with customer_with_country as(
select c.customer_id, c.first_name, c.last_name, i.billing_country, sum(i.total) as total_spending,
row_number() over(partition by i.billing_country order by sum(i.total) desc) as rowno
from invoice i
join customer c on c.customer_id=i.customer_id
group by 1,2,3,4
order by 4, 5 desc)
select * from customer_with_country where rowno=1;
