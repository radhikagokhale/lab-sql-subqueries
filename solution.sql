
-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
select count(title) no_of_copies
from inventory i
inner join film f
on i.film_id = f.film_id
where title='Hunchback Impossible';
-- 2. List all films whose length is longer than the average of all the films.
select * 
from film
where length > (
	select avg(length) 
	from film
);
-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
select * 
from actor
where actor_id in (
	select actor_id
	from film_actor
	where film_id in (
		select film_id 
		from film
		where title = 'Alone Trip'
		)
	);
-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * 
from film
where film_id in (
	select film_id
    from film_category
    where category_id in (
		select category_id
        from category
        where name = 'Family'
        )
	);
    
-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select first_name, email 
from customer
where address_id in (
	select address_id
    from address
    where city_id in (
		select city_id
        from city
        where country_id in (
			select country_id
            from country
            where country = 'Canada'
            )
		)
	)
order by first_name;
-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select *
from film 
where film_id in (
	select distinct film_id
	from film_actor
	where actor_id in (
		select actor_id
		from (
			select actor_id, count(film_id) n_film
			from film_actor
			group by actor_id
			order by n_film desc
			limit 1
		) sub1
	)
);
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select * from customer;
select * from payment;

select * 
from film 
where film_id in (
	select distinct film_id
	from inventory
	where film_id in (
		select inventory_id
		from rental
		where customer_id in (
				select customer_id from (
					select customer_id, sum(amount) as tot_amount
					from payment
					group by customer_id
					order by sum(amount) desc
					limit 1
					) sub1
				)
			)
		);
-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.
select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having sum(amount) > (
	select avg(total_amount) avg_amount_per_client
	from (
		select customer_id, sum(amount) as total_amount
		from payment
		group by customer_id
		) sub1
	)
order by total_amount_spent desc;