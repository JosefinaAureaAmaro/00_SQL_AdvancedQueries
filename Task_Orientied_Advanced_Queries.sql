/*** PRACTING QUERIES BASED ON AN ERD DIAGRAM ***/
/* These task-oriented assignments are designed by me
to make the query complex and comprehensive */

-- COUNT RENTAL RATE GROUP BY RATING

SELECT rating, rental_rate, COUNT(rental_rate) AS num_purch_rate -- COLUMNS
FROM film -- TABLE
GROUP BY rating, rental_rate -- CATEGORICAL COLUMNS 
ORDER BY COUNT(rental_rate) DESC; -- ORDER OF DATA



-- GIVE ME ALL THE TITLES OF FILMS IN HORROR

-- SUBQUERY VERSION
SELECT name, title
FROM film
JOIN film_category AS fc ON fc.film_id = film.film_id
JOIN category AS cat ON cat.category_id = fc.category_id
WHERE cat.category_id IN (SELECT category_id
FROM category
WHERE name = 'Horror');

-- WHERE VERSION
SELECT name, title
FROM film
JOIN film_category AS fc ON fc.film_id = film.film_id
JOIN category AS cat ON cat.category_id = fc.category_id
WHERE name = 'Horror';


-- COUNT THE NUMBER OF FILMS PER ACTOR BY A GIVEN CATEGORY
-- (pt 1)
CREATE VIEW featured_actors
AS SELECT DISTINCT film_category.film_id, name, first_name, last_name
FROM category
JOIN film_category ON film_category.category_id = category.category_id
JOIN film_actor ON film_actor.film_id = film_category.film_id
JOIN actor on actor.actor_id = film_actor.actor_id
WHERE name = 'Documentary' -- where needs to come before the order by
ORDER BY film_id;

-- (pt 2)
SELECT first_name, last_name, COUNT(film_id)
FROM featured_actors
GROUP BY first_name, last_name;

-- SELECT TOP 25 selling films by Category
SELECT name,  rating, COUNT(rental_id) AS purchase_freq
FROM film
JOIN inventory AS inv ON inv.film_id = film.film_id
JOIN film_category AS fc ON fc.film_id = inv.film_id
JOIN category as cat ON cat.category_id = fc.category_id
JOIN rental AS rent ON rent.inventory_id = inv.inventory_id
JOIN customer AS cust ON cust.customer_id = rent.customer_id
JOIN address AS addr ON addr.address_id = cust.address_id
JOIN city ON city.city_id = addr.city_id
JOIN country ON country.country_id = city.country_id
WHERE country = 'United States'
GROUP BY name, rating, release_year;

-- GET THE MOST FREQUENT MOVIE WATCHED

SELECT film.film_id, title, COUNT(rental_id) AS purchase_freq
FROM film
JOIN inventory  inv ON inv.film_id = film.film_id
JOIN rental rent ON rent.inventory_id = inv.inventory_id
GROUP BY film.film_id, title
ORDER BY purchase_freq DESC;
/* I don't need film_id for this query because I don't need any details from the 
film table to complete this task. Instead I can use Inventory_ID since that requires no joins*/

SELECT inventory_id, COUNT(rental_id) AS purchase_freq
FROM rental
GROUP BY inventory_id
ORDER BY purchase_freq DESC;
/* for assessments the query needs to focus on the answer, not the flexibility of data available
from the query. In a work-place setting, a more dynamic query is preferred */

-- WHAT IS THE MOST PROFITABLE FILM (DISPLAY INVENTORY_ID & TOTAL SALES)
SELECT inventory_id, COUNT(rental.customer_id) total_purchase_freq, SUM(amount) total_sales
FROM rental
JOIN payment pay ON pay.customer_id = rental.customer_id
GROUP BY inventory_id
ORDER BY total_sales DESC; 


