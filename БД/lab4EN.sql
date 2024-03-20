USE sakila;

/*покупатели из списка стран*/
SELECT customer.first_name AS 'Имя', customer.last_name AS 'Фамилия', country.country AS 'Страна'
FROM customer
JOIN address
ON customer.address_id = address.address_id
JOIN city
ON city.city_id = address.city_id
JOIN country
ON city.country_id = country.country_id AND (city.country_id = 1 OR city.country_id = 2 OR city.country_id = 10);

/*фильмы одного актера*/
SELECT film.title AS 'Название', category.name AS 'Жанр'
FROM film 
JOIN film_category
ON film_category.film_id = film.film_id
JOIN category
ON category.category_id = film_category.category_id
JOIN film_actor
ON film.film_id = film_actor.film_id AND film_actor.actor_id = 2;

/*топ 10 жанров по доходам*/
SELECT category.name AS 'Жанр', SUM(payment.amount) AS 'Деньги'
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN film 
ON film_category.film_id = film.film_id
JOIN inventory
ON inventory.film_id = film.film_id
JOIN rental 
ON rental.inventory_id = inventory.inventory_id
JOIN payment
ON rental.customer_id = payment.customer_id AND (MONTH(payment.payment_date) = MONTH('2005-02-01'))
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 10;

/*ывести список из 5 клиентов, упорядоченный по количеству купленных
фильмов с указанным актером, начиная с 10-й позиции: отобразить имя,
фамилию, количество купленных фильмов.*/

SELECT customer.first_name AS 'Имя', customer.last_name AS 'Фамилия', COUNT(rental.rental_id) AS 'Кол-во' 
FROM customer
JOIN rental
ON customer.customer_id = rental.customer_id
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON film.film_id = inventory.film_id
JOIN film_actor
ON film.film_id = film_actor.film_id AND (film_actor.actor_id = 1)
GROUP BY customer.first_name, customer.last_name
ORDER BY COUNT(rental.rental_id) DESC
LIMIT 5 OFFSET 10;

/*Вывести для каждого магазина его город, страну расположения и суммарный
доход за первую неделю продаж*/
SELECT store.store_id, country.country AS'Страна', city.city AS 'Город', SUM(payment.amount) AS 'Доход в первую неделю'
FROM country
JOIN city ON city.country_id = country.country_id
JOIN address ON address.city_id = city.city_id
JOIN store ON store.address_id = address.address_id
JOIN customer ON customer.store_id = store.store_id
JOIN payment ON customer.customer_id = payment.customer_id AND( WEEK(payment.payment_date) = WEEK('2005-05-25'))
JOIN rental ON payment.rental_id = rental.rental_id
GROUP BY store.store_id, country.country, city.city;

SELECT *  FROM payment
WHERE WEEK(payment_date) = WEEK('2005-05-25');

/*Вывести всех актеров для фильма, принесшего наибольший доход: отобразить
фильм, имя актера, фамилия актера*/

SELECT actor.first_name, actor.last_name, film.title
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film.film_id = film_actor.film_id
WHERE film.film_id = 
	(SELECT film.film_id 
    FROM film
    JOIN inventory ON inventory.film_id = film.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    JOIN payment ON payment.rental_id = rental.rental_id
    GROUP BY film.film_id
    ORDER BY SUM(payment.amount)
    LIMIT 1);
    
/*Для всех покупателей вывести информацию о покупателях и актерах-
однофамильцах (используя LEFT JOIN, если однофамильцев нет – вывести
NULL)*/

SELECT customer.first_name, customer.last_name, actor.first_name, actor.last_name
FROM customer
LEFT JOIN actor
ON customer.last_name = actor.last_name;

/*Для всех актеров вывести информацию о покупателях и актерах-однофамильцах
(используя RIGHT JOIN, если однофамильцев нет – вывести NULL)*/

SELECT customer.first_name, customer.last_name, actor.first_name, actor.last_name
FROM customer
RIGHT JOIN actor
ON customer.last_name = actor.last_name;

/*вывести статистические данные о фильмах*/


WITH Lengther AS
(
	SELECT film.length, COUNT(film_id) AS idcounter
	FROM film
	WHERE film.length = (SELECT MAX(length) FROM film)
	GROUP BY film.length
	UNION
	SELECT film.length, COUNT(film_id) AS idcounter
	FROM film
	WHERE film.length = (SELECT MIN(length) FROM film)
	GROUP BY film.length
),
Actorcounter AS
(
	(SELECT I.actorcount, COUNT(I.filmid) AS idcounter
	FROM (SELECT COUNT(film_actor.actor_id) AS actorcount, film_actor.film_id AS filmid
		FROM film_actor
		GROUP BY film_actor.film_id) AS I
	WHERE I.actorcount = (SELECT MAX(I2.actorcount) FROM (SELECT COUNT(film_actor.actor_id) AS actorcount, film_actor.film_id AS filmid
						FROM film_actor
						GROUP BY film_actor.film_id) AS I2)
	GROUP BY I.actorcount
	UNION
	SELECT I.actorcount, COUNT(I.filmid) AS idcounter
	FROM (SELECT COUNT(film_actor.actor_id) AS actorcount, film_actor.film_id AS filmid
		FROM film_actor
		GROUP BY film_actor.film_id) AS I
		WHERE I.actorcount = (SELECT MIN(I2.actorcount) FROM (SELECT COUNT(film_actor.actor_id) AS actorcount, film_actor.film_id AS filmid
							FROM film_actor
							GROUP BY film_actor.film_id) AS I2)
	GROUP BY I.actorcount)
)
SELECT Actorcounter.idcounter AS "Количество фильмов", Actorcounter.actorcount AS "Макс и Мин актеров", Lengther.length AS "Макс и мин длина" FROM Actorcounter
LEFT JOIN Lengther
ON Actorcounter.idcounter=Lengther.idcounter
UNION 
SELECT Lengther.idcounter, Actorcounter.actorcount, Lengther.length  FROM Actorcounter
RIGHT JOIN Lengther
ON Actorcounter.idcounter=Lengther.idcounter;