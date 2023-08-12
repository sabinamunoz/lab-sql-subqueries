use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(*) as numb_copies from inventory
where film_id 
in (select film_id from film where title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average of all the films.
select * from film
having length > (select avg(length) from film);


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select fa.actor_id, concat(a.first_name,' ',a.last_name) as full_name from film_actor fa
left join actor a on a.actor_id = fa.actor_id
where film_id 
in (select film_id from film
where title = 'Alone Trip');


-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * from film
where film_id 
in (
select film_id from film where film_id in
(select category_id from category)
);


-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select cu.customer_id, cu.first_name, cu.last_name, cu.email from customer cu
left join address ad on ad.address_id = cu.address_id
left join city ct on ct.city_id = ad.city_id
where ct.country_id in (select country_id from country where country = 'Canada');



-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- defined the most prolific actor > 107
select title from film
where film_id in (
    select film_id from film_actor
    where actor_id in (
        select actor_id
        from film_actor
        group by actor_id
        having count(*) = (
            select max(count)
            from (
                select count(*) as count
                from film_actor
                group by actor_id
            ) as subquery
        )
    )
);





-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

-- most profitable customer: 526


select title from rental r
left join inventory i on i.inventory_id = r.inventory_id
left join film f on f.film_id = i.inventory_id
where title is not null && customer_id in (
	select customer_id
	from payment
	group by customer_id
	having sum(amount) = (
		select max(total_amount)
		from (
			select customer_id, sum(amount) as total_amount
			from payment
			group by customer_id
		) as subquery
)
);



-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.


select * from client_id;

select customer_id, sum(amount) as total_amount_spent from payment
group by customer_id
having sum(amount) > (
	select avg(total_amount) as avg_total_amount 
    from (
	select customer_id, sum(amount) as total_amount
    from payment
	group by customer_id) as subquery);



