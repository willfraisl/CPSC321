/*
Will Fraisl
Homework 6
Queries over the following database

Actor(actor id, first name, last name, last update)
Category(category id, name, last update)
Customer(customer id, store id, first name, last name, email, address id, active, create date,
last update)
Film(film id, title, description, release year, language id, original language id, rental duration,
rental rate, length, replacement cost, rating, special features, last update)
Film Actor(actor id, film id, last update)
Film Category(film id, category id, last update)
Inventory(inventory id, film id, store id, last update)
Payment(payment id, customer id, staff id, rental id, amount, payment date, last update)
Rental(rental id, rental date, inventory id, customer id, return date, staff id, last update)
Staff(staff id, first name, last name, address id, picture, email, store id, active, username,
password, last update)
Store(store id, manager staff id, address id, last update)
*/

-- 1
/* Find the total number of films by category ordered from most to least. Give the name of each
category along with the number of corresponding films. */
SELECT c.name, COUNT(*)
FROM film f, film_category fc, category c
WHERE f.film_id = fc.film_id AND fc.category_id = c.category_id
GROUP BY c.category_id
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 2
/* Find the number of films acted in by each actor ordered from highest number of films to
lowest. For each actor, give their first and last name and the number of films they acted in. */
SELECT a.first_name, a.last_name, COUNT(*)
FROM actor a JOIN film_actor fa USING (actor_id)
GROUP BY fa.actor_id
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 3
/* For each ‘PG’ rated films that costs 2.99 to rent find the number of times it has been rented.
The result should be sorted from most rented to least rented. For each film, give the film
title and the corresponding number of rentals. */
SELECT f.title, COUNT(*)
FROM film f, inventory i, rental r
WHERE f.film_id = i.film_id
    AND i.inventory_id = r.inventory_id
    AND f.rating = 'PG'
    AND f.rental_rate = 2.99
GROUP BY f.film_id
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 4
/* Find all first and last names of customers that have rented at least six ‘R’ rated films costing
0.99 each to rent. For each customer give the number of such films they’ve rented. */
SELECT c.first_name, c.last_name, COUNT(*)
FROM customer c, film f, rental r, inventory i
WHERE c.customer_id = r.customer_id
    AND r.inventory_id = i.inventory_id
    AND i.film_id = f.film_id
    AND f.rating = 'R'
    AND f.rental_rate = 0.99
GROUP BY c.customer_id
HAVING COUNT(*) >= 6
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 5
/* Find the total sales (of payments) for each film category sorted from highest total payments
to least. Give the name of each category and the total payments. */
SELECT c.name, SUM(p.amount)
FROM category c, film_category fc, inventory i, rental r, payment p
WHERE c.category_id = fc.category_id
    AND fc.film_id = i.film_id
    AND i.inventory_id = r.inventory_id
    AND r.rental_id = p.rental_id
GROUP BY c.category_id
ORDER BY SUM(p.amount) DESC
LIMIT 10;

-- 6
/* Find the film category (or categories if there is a tie) with the most number of ‘R’ rated films.
Your query cannot use limit. Return the category name and the corresponding number of R
rated films. */
SELECT c.name, COUNT(*)
FROM category c, film_category fc, film f
WHERE c.category_id = fc.category_id
    AND fc.film_id = f.film_id
    AND f.rating = 'R'
    -- subquery
GROUP BY c.category_id
ORDER BY COUNT(*) DESC;

-- 7
/* Find the ’G’ rated film (or films if there is a tie) that have been rented the most number of
times. You cannot use limit and your query must return only the film(s) rented the most
number of times (not the second, third, etc). Return the film id, title, and the number of
times the film has been rented. */
SELECT f.film_id, f.title, COUNT(*)
FROM film f, inventory i, rental r
WHERE f.film_id = i.film_id
    AND i.inventory_id = r.inventory_id
    AND f.rating = 'G'
    -- subquery
GROUP BY f.film_id
ORDER BY COUNT(*) DESC;

-- 8
/* Find the store (or stores if there is a tie) that have the most rentals. You cannot use limit and
your query must return only the store(s) that have the most rentals (not the second most,
third most, etc). Return the store id and the number of store rentals. */
SELECT s.store_id, COUNT(*)
FROM store s, inventory i, rental r
WHERE s.store_id = i.store_id
    AND i.inventory_id = r.inventory_id
    -- subquery
GROUP BY s.store_id
ORDER BY COUNT(*);

-- 9
/* For each staff member, find the movies they rented for 0.99 and the total number of times
that they were rented to customers by the staff member. Return the first and last name of
each staff member, the title of each movie, and the number of times each movie was rented
by the staff member. The results should be ordered by staff member last name followed by
first name. For each staff member, the movies that they have rented should be ordered from
most rented to least rented. */

-- 10
/* Come up with your own “interesting” query over the database schema. Your query should
involve group by, having, and (necessary) subqueries. Give your query, the query result, and
explain in plain English what the purpose of the query is. */
