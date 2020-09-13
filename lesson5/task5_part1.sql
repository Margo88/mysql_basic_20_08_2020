-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»

-- №1. пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем.

update users
set created_at = now() where created_at is null;

update users
set updated_at = now() where updated_at is null;
-- №2. таблица users была неудачно спроектирована. Записи creatae_at и updated_at 
-- были заданы типом varchar и в них долгое время помещались
-- значения в формате 20.10.2017 8:10. Необходимо преобразовать 
-- поля к типу datetime, сохранив введенные ранее значения

update 
	users
set
	created_at = str_to_date(created_at, '%d.%m.%Y %H:%i');

update 
	users
set
	updated_at = str_to_date(updated_at , '%d.%m.%Y %H:%i');

alter table users modify created_at datetime;	
alter table users modify updated_at datetime;	

-- №3. В таблице складских запасов storehouses_products в поле value могут встречаться 
-- самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
-- Однако нулевые запасы должны выводиться в конце, после всех записей.


 select * from storehouses_products order by case when value = 0 then 1 else 0 end, value;

-- №4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий (may, august)

select * from users where birthday_at like '%august%' or birthday_at like '%may%';

-- №5. Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- Отсортируйте записи в порядке, заданном в списке IN.

SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by field(id,5,1,2);



