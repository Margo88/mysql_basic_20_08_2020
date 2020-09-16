-- Практическое задание №7 
-- Тема “Сложные запросы”

-- №1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

select 
	*
from 
	(select 
		users.id,
		users.name,
		count(orders.id) as orders_amount
	from 
		users
	join
		orders
		on users.id = orders.user_id
	group by users.id) as all_orders

where orders_amount > 0;

-- №2. Выведите список товаров products и разделов catalogs, который соответствует товару.

select 
	products.name,
	catalogs.name 
from
	products
join
	catalogs
	on products.catalog_id = catalogs.id ;

-- №3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

-- DROP TABLE IF EXISTS flights;
-- CREATE TABLE flights (
-- id SERIAL PRIMARY KEY,
-- departure VARCHAR(50), -- город вылета
-- destination VARCHAR(50) -- город назначения
-- );
-- 
-- DROP TABLE IF EXISTS cities;
-- CREATE TABLE cities (
-- label VARCHAR(50), -- название на англ.
-- name VARCHAR(50) -- название рус.
-- );

select
	id,
	departure_rus,
	cities.name as destination_rus
from
(select
	flights.id,
	cities.name as departure_rus,
	flights.destination as destination
from 
	flights
join
	cities
	on flights.departure = cities.label) as flights_rus
join 
	cities
	on flights_rus.destination = cities.label ; 