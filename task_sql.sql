<<<<<<< HEAD:task_sql.sql
﻿SET client_encoding = 'UTF8';
-- свыоваоы
-- найти количество фильмов в каждой категории, и отсортировать убывающе 
=======
SET client_encoding = 'UTF8';
-- íàéòè êîëè÷åñòâî ôèëüìîâ â êàæäîé êàòåãîðèè, è îòñîðòèðîâàòü óáûâàþùå 
>>>>>>> 10f9ee57066554f065e811ce3646996821027782:tasks_sql.sql
select c."name" , count(f.film_id)
from film f 
inner join film_category fc on fc.film_id = f.film_id 
inner join category c on c.category_id = fc.category_id 
group by c.category_id 
order by count(f.film_id);

--Find 10 actors with the most rented films, sorted in descending order.

select actor_name, "count"
from (
select concat(a.first_name || ' ' || a.last_name) as actor_name, count(r.rental_id) as "count"
from rental r 
inner join inventory i 
on r.inventory_id = i.inventory_id 
inner join film f 
on f.film_id = i.film_id 
inner join film_actor fa 
on fa.film_id = f.film_id 
inner join actor a on 
a.actor_id = fa.actor_id 
group by a.actor_id 
order by count(r.rental_id) desc
limit 10) tab
order by "count";


-- show the category of films on which they spent the most money.

select c."name" , sum(p.amount)
from payment p 
inner join rental r on r.rental_id = p.rental_id 
inner join inventory i on i.inventory_id = r.inventory_id 
inner join film f on f.film_id = i.film_id 
inner join film_category fc on fc.film_id = f.film_id 
inner join category c on c.category_id = fc.category_id 
group by c.category_id 
order by sum(p.amount) desc 
limit 1;

--show movies titles that are not in inventory. Write a query without using the IN operator.

select distinct f.title 
from film f 
left join inventory i 
on i.film_id = f.film_id 
where i.inventory_id is null;

<<<<<<< HEAD:task_sql.sql
--bring out the top 3 actors who have most appeared in films in the УChildrenФ category. If several actors have the same number of films, output all.
=======
--bring out the top 3 actors who have most appeared in films in the “Children” category. If several actors have the same number of films, output all.
>>>>>>> 10f9ee57066554f065e811ce3646996821027782:tasks_sql.sql
select actor_full_name, "count"
from (
select concat(a.first_name || ' ' || a.last_name) as actor_full_name, count(a.actor_id) as "count", dense_rank () over(order by count(a.actor_id) desc) as "rank"
from film f 
inner join film_actor fa ON fa.film_id = f.film_id 
inner join actor a on a.actor_id = fa.actor_id 
inner join film_category fc on fc.film_id = f.film_id 
inner join category c on c.category_id = fc.category_id 
where upper(c."name")  = upper('children')
group by a.actor_id 
order by count(a.actor_id) desc) tab
where rank<=3;

<<<<<<< HEAD:task_sql.sql
-- find cities with the number of active and inactive customers (active Ч customer.active = 1). Sort by the number of inactive clients in descending order.
=======
-- find cities with the number of active and inactive customers (active — customer.active = 1). Sort by the number of inactive clients in descending order.
>>>>>>> 10f9ee57066554f065e811ce3646996821027782:tasks_sql.sql

select c2.city ,'True' as "status", count(c.customer_id) 
from customer c 
inner join address a on a.address_id = c.address_id 
inner join city c2 on c2.city_id = a.city_id 
where c.activebool = true 
group by c2.city_id
union all
select distinct c.city,'False' ,sum(case when c2.activebool is null then 0 else 1 end)
from city c 
left join address a on a.city_id  = c.city_id 
left join customer c2 on c2.address_id = a.address_id and c2.activebool = false
group by c.city_id 
order by city,"status","count" desc

<<<<<<< HEAD:task_sql.sql
-- Show the category of movies that has the largest number of hours of total rental in cities (customer.address_id in this city), and that start with the letter УaФ.
--Do the same for cities that have a У-Ф symbol. Write everything in one request.
=======
-- Show the category of movies that has the largest number of hours of total rental in cities (customer.address_id in this city), and that start with the letter “a”.
--Do the same for cities that have a “-” symbol. Write everything in one request.
>>>>>>> 10f9ee57066554f065e811ce3646996821027782:tasks_sql.sql

select city, "name", "rental_hours" 
from
(select c3.city ,c."name" , coalesce(sum(extract(epoch from return_date - rental_date)/3600),0) as "rental_hours",rank () over(partition by c3.city  order by c3.city ,
coalesce(sum(extract(epoch from return_date - rental_date)/3600),0) desc) as "rank"
from rental r
inner join inventory i on i.inventory_id = r.inventory_id 
inner join film f on f.film_id = i.film_id 
inner join film_category fc on f.film_id = fc.film_id 
inner join category c on c.category_id = fc.category_id 
inner join customer c2 on c2.customer_id = r.customer_id 
inner join address a on a.address_id = c2.address_id 
inner join city c3 on c3.city_id = a.city_id 
where upper(c3.city) like upper('a%') or upper(c3.city) like upper('%-%')
group by c3.city , c."name" ) tab 
where "rank" = 1;
