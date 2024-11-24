-- Years of release
 select distinct release_year 
 from film;
 
 -- countries where film was released
  select distinct country 
 from country;
 
 -- which actor has most movies in the year
select f.actor_id,first_name, last_name,count(film_id) total_films
from  film_actor f
inner join actor a
on a.actor_id = f.actor_id
group by actor_id
order by total_films desc;

-- which catogary has the most films in the given year
select name,count(film_id) as total_films
from category c
inner join film_category fc
on c.category_id = fc.category_id
group by name
order by total_films desc;


-- How much  revenue each catagory collected
select c.name,sum(p.amount) as total_sales
from payment p
join rental r
on r.rental_id = p.rental_id
join inventory i
on r.inventory_id = i.inventory_id
 join film f
on i.film_id = f.film_id
join film_category fc
on fc.film_id = f.film_id
join category c
 on c.category_id = fc.category_id
 group by name
 order by total_sales desc;
 
-- Revenue collected by each film 
 select f.film_id,f.title,f.release_year,sum(p.amount) total_revenue_millions
 from payment p
join rental r
on r.rental_id = p.rental_id
join inventory i
on r.inventory_id = i.inventory_id
 join film f
on i.film_id = f.film_id
group by f.film_id,f.title 
order by total_revenue_millions desc;
 

-- Name of film and catagory for every actor
select first_name, last_name,group_concat(distinct concat(C.NAME),":",
      (select 
       group_concat(f.title order by f.title asc separator ',') 
       from
		film f
                            JOIN film_category fc ON f.film_id = fc.film_id
                            JOIN film_actor fa ON f.film_id = fa.film_id
                        WHERE
                            fc.category_id = c.category_id
                                AND fa.actor_id= a.actor_id)
            ORDER BY c.name ASC SEPARATOR '; ') AS film_info
from actor a
		join film_actor fa
		on a.actor_id = fa.actor_id
		join film f
		on f.film_id = fa.film_id
        join film_category fc
        on f.film_id = fc.film_id
        join category c
         on c.category_id = fc.category_id
group by a.first_name, a.last_name;

-- films that are not available in inventory
select film_id, title
from film
where film_id not in (select film_id from inventory);

-- films that are available in inventory
select film_id, title,(select count(film_id)
from inventory i 
where i.film_id = f.film_id
group by film_id ) as stocks
from film f
where film_id in (select film_id from inventory)
order by stocks desc;
-- THE END