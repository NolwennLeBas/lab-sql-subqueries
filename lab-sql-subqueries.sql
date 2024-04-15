USE sakila;

-- 1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT * FROM sakila.inventory;
SELECT * FROM sakila.film;
SELECT count(i.inventory_id) AS number_of_copies, f.title
FROM sakila.inventory AS i
JOIN sakila.film AS f
ON i.film_id = f.film_id
WHERE f.title = 'HUNCHBACK IMPOSSIBLE';
    
-- 2 List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT * FROM sakila.film;
SELECT title, length FROM sakila.film
WHERE length >= (
	SELECT avg(length) FROM sakila.film);

-- 3 Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT * FROM sakila.film_actor;
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film;
SELECT concat(a.first_name, ' ', a.last_name) AS actor_name
FROM sakila.actor AS a
JOIN sakila.film_actor AS fa USING (actor_id)
WHERE film_id = (
	SELECT film_id FROM sakila.film
    WHERE title = 'ALONE TRIP');

-- BONUS

-- 4 Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT * FROM sakila.film_category;
SELECT * FROM sakila.film;
SELECT * FROM sakila.category;
SELECT f.title FROM sakila.film AS f
JOIN sakila.film_category AS fc USING (film_id)
WHERE category_id = (
	SELECT category_id FROM sakila.category
	WHERE name = 'Family');


-- 5 Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT * FROM sakila.customer;
SELECT * FROM sakila.address;
SELECT * FROM sakila.city;
SELECT * FROM sakila.country;
SELECT concat(c.first_name, ' ', c.last_name) AS customer_name, c.email
FROM sakila.customer AS c
JOIN sakila.address AS a USING (address_id)
JOIN sakila.city AS ci USING (city_id)
WHERE ci.country_id =(
	SELECT country_id FROM sakila.country
    WHERE country = 'Canada');

-- 6 Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT * FROM sakila.film;
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film_actor;
SELECT f.title, concat(a.first_name, ' ', a.last_name) AS most_prolific_actor
FROM sakila.film AS f
JOIN sakila.film_actor AS fa USING (film_id)
JOIN sakila.actor AS a USING (actor_id)
WHERE actor_id= (
	SELECT actor_id FROM sakila.film_actor
	GROUP BY actor_id
	ORDER BY COUNT(film_id) DESC
	LIMIT 1);

-- Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT * FROM sakila.customer;
SELECT * FROM sakila.payment;
SELECT concat(first_name, ' ', last_name) AS most_profitable_customer
FROM sakila.customer
WHERE customer_id =(
	SELECT customer_id FROM sakila.payment
	GROUP BY customer_id
	ORDER BY sum(amount) DESC
	LIMIT 1);

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.

-- NOT WORKING
SELECT * FROM sakila.payment;
SELECT p1.customer_id, sum(p1.amount) AS total_amount_spent FROM sakila.payment AS p1
WHERE sum(amount) > (
	SELECT avg(amount) FROM sakila.payment AS p2
    WHERE p1.customer_id = p2.customer_id )
GROUP BY customer_id
ORDER BY sum(amount) DESC;

-- WORKING SEPARATELY
SELECT AVG(amount) FROM sakila.payment;
SELECT customer_id, sum(amount) AS total_amount_spent FROM sakila.payment
GROUP BY customer_id
ORDER BY sum(amount) DESC;