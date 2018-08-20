USE sakila;

-- 1a. Display the first and last names of all actors from the table actor:
select first_name,last_name
from sakila.actor
order by last_name,first_name;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name," ",last_name) as actor_name
from sakila.actor
order by last_name, first_name;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe.":
select actor_id,first_name,last_name
from sakila.actor
where first_name="Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id,first_name,last_name
from sakila.actor
where last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id,first_name,last_name
from sakila.actor
where last_name LIKE "%LI%"
order by last_name,first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id,country
from sakila.country
where country IN ("Afghanistan", "Bangladesh","China");

-- 3a. Create a column in the table actor named description and use the data type BLOB:
ALTER TABLE sakila.actor 
ADD COLUMN description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE sakila.actor 
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name,count(last_name) as last_name_count
from sakila.actor
group by last_name
order by last_name_count desc;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name,count(last_name) as last_name_count
from sakila.actor
group by last_name
having last_name_count>=2
order by last_name_count desc;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

--  Turn safe updates off
SET SQL_SAFE_UPDATES = 0;

UPDATE sakila.actor
SET first_name="HAPRO"
WHERE first_name="GROUCHO" and last_name="WILLIAMS";

-- Check To See if It was Updated Correctly
SELECT *
FROM sakila.actor
WHERE last_name="WILLIAMS";

-- 4d. In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO:

UPDATE sakila.actor
SET first_name="GROUCHO"
WHERE first_name="HAPRO" and last_name="WILLIAMS";

-- Check To See if It was Updated Correctly
SELECT *
FROM sakila.actor
WHERE last_name="WILLIAMS";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

select staff.first_name,staff.last_name,address.address
from sakila.staff staff
join sakila.address address on staff.address_id=address.address_id;


-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment:
# Should be less than 4206

select staff.first_name,staff.last_name,sum(amount)
from payment
join staff on staff.staff_id=payment.staff_id
where payment.payment_date >  '2005-08-01 00:00:00' AND payment.payment_date < ' 2005-09-01 00:00:00'
group by staff.last_name,staff.first_name
order by last_name,first_name;


-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

select film.title, count(actor_id) as Num_of_Featured_Actors
from sakila.film
inner join sakila.film_actor on film.film_id=film_actor.film_id 
group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select count(inventory_id)
from sakila.inventory
inner join  sakila.film on film.film_id=inventory.film_id
where title= 'Hunchback Impossible';


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

select customer.first_name,customer.last_name,sum(amount)
from customer
join payment on payment.customer_id=customer.customer_id 
group by customer.last_name,customer.first_name
order by last_name,first_name;

-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English:

select f.title,f.language_id
from film f
where f.title LIKE 'K%' or  f.title LIKE 'Q%'
and language_id in
(
select l.language_id
from language l
where l.name="English");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip: 

select a.first_name,a.last_name
from actor a
where actor_id in
(
select actor_id
from film_actor fa
where film_id in
(
select film_id
from film f
where f.title='Alone Trip'
)
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information: 

select customer_list.name,email,country
from customer_list
inner join customer on customer_list.ID = customer.customer_id
where country='Canada';

-- 7d. Identify all movies categorized as family films:

select title
from film f
where film_id in
(
select film_id
from film_category
where category_id in
(
select category_id
from category
where name='Family'
)
);


-- 7e. Display the most frequently rented movies in descending order:

select f.title,count(r.rental_id) as 'Rental_Count'
from film f
join inventory i on i.film_id=f.film_id
join rental r on r.inventory_id=i.inventory_id
group by f.title
order by count(r.rental_id) desc;


-- 7f. Write a query to display how much business, in dollars, each store brought in: 

select s.store_id,sum(p.amount) as 'store_revenue'
from store s
join staff st on st.store_id=s.store_id
join payment p on p.staff_id=st.staff_id
group by s.store_id;


-- 7g. Write a query to display for each store its store ID, city, and country:

select s.store_id,c.city,ct.country
from store s
join address  a on s.address_id=a.address_id
join city c on c.city_id=a.city_id
join country ct on ct.country_id=c.country_id;


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.):

select c.name as 'Genre',sum(p.amount) as 'Gross_Revenue'
from category c
inner join film_category fc on c.category_id=fc.category_id
inner join inventory i on i.film_id=fc.film_id
inner join rental r on r.inventory_id=i.inventory_id
inner join payment p on p.rental_id=r.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 

create view top_five_genre as
select c.name as 'Genre',sum(p.amount) as 'Gross_Revenue'
from category c
inner join film_category fc on c.category_id=fc.category_id
inner join inventory i on i.film_id=fc.film_id
inner join rental r on r.inventory_id=i.inventory_id
inner join payment p on p.rental_id=r.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;


-- 8b. How would you display the view that you created in 8a:

select *
from top_five_genre;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it:

drop view top_five_genre;
