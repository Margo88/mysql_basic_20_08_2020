-- Практическое задание по теме “Транзакции, переменные, представления”

-- №1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

start transaction;

insert into
	sample.users 
select 
	* 
from 
	shop.users
where id = 1;

delete from 
shop.users where id = 1;

commit;


-- №2. Создайте представление, которое выводит название name товарной позиции из таблицы products и 
-- соответствующее название каталога name из таблицы catalogs.

create view product_name
as select 
	products.name as product,
	catalogs.name as category
from
	products
join
	catalogs	
	on products.id = catalogs.id;
-- select * from product_name;