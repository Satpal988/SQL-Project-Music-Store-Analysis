SQL PROJECT- MUSIC STORE DATA ANALYSIS

Question Set 1 - Easy

1. Who is the senior most employee based on job title?

select * from employee
order by levels desc
limit 1

2. Which countries have the most Invoices?

select
	billing_country,
	count(invoice_id)
from invoice
group by 1
order by 2 desc

3. What are top 3 values of total invoice?

select
	invoice_id,
	total
from invoice
group by 1
order by 2 desc
limit 5

4. Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals

select 
	billing_city,
	cast(sum(total) as numeric(10,2))
from invoice
group by 1
order by 2 desc

5. Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money.

select
	customer.customer_id,
	customer.first_name,
	customer.last_name,
	cast(sum(invoice.total) as numeric(10,2))
from customer
join invoice on customer.customer_id = invoice.customer_id
group by 1,2,3
order by 4 desc

6. Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A

select 
	customer.first_name,
	customer.last_name,
	customer.email,
	genre.name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
group by 1,2,3,4

7. Lets invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands.

select * from track

select
	artist.name,
	count(track.track_id)
from artist
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by 1
order by 2 desc
limit 10

8. Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first

select
	name,
	milliseconds
from track
group by 1,2
having milliseconds >(select avg(milliseconds) from track )
order by 2 desc

9. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent

with Best_selling_artist as (
	select
		artist.artist_id,
		artist.name as artist_name,
		cast(SUM(invoice_line.unit_price * invoice_line.quantity) as numeric (10,2)) as total_spend
	from invoice_line
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join track on invoice_line.track_id = track.track_id
	join album on track.album_id = album.album_id
	join artist on album.artist_id = artist.artist_id
	group by 1,2
	order by 3 desc
	limit 1
)

select
	customer.first_name,
	customer.last_name,
	Best_selling_artist.artist_name,
	Best_selling_artist.total_spend
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
join Best_selling_artist on album.artist_id = Best_selling_artist.artist_id
group by 1,2,3,4
order by 4 desc


10. We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres

with sales_per_country as (
	select 
		customer.country,
		genre.name,
		count(invoice_line.quantity) as quantity
	from customer
	join invoice on customer.customer_id = invoice.customer_id
	join invoice_line on invoice.invoice_id = invoice_line.invoice_id
	join track on invoice_line.track_id = track.track_id
	join genre on track.genre_id = genre.genre_id
	group by 1,2
	order by 3 desc
),
popular_genre as (
	select 
		country,
		max(quantity)as max_sale
	from sales_per_country
	group by 1
	order by 2 desc
)

select sales_per_country.*
from sales_per_country
join popular_genre on sales_per_country.country = popular_genre.country
where sales_per_country.quantity = popular_genre.max_sale

2nd method

with popular_genre as (
select 
	customer.country,
	genre.name,
	count(invoice_line.quantity),
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc ) as row_number
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
Group by 1,2
order by 1,3 desc
)
select * from popular_genre
where row_number = 1


11. Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount

with top_customer as (
	select 
		customer.country,
		customer.first_name,
		cast(sum(invoice_line.unit_price * invoice_line.quantity) as numeric(10,2)) as total_spent,
		row_number() over(partition by customer.country 
		order by sum(invoice_line.unit_price * invoice_line.quantity) desc) as row_number
	from customer
	join invoice on customer.customer_id = invoice.customer_id
	join invoice_line on invoice.invoice_id = invoice_line.invoice_id
	group by 1,2
	order by 1 desc,3 desc
)
select * from top_customer 
where row_number = 1









