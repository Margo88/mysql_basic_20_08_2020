-- Практическое задание по теме “Оптимизация запросов”


-- №1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в 
-- таблицах users, catalogs и products в таблицу logs помещается время и дата 
-- создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	name_table VARCHAR(45) NOT NULL,
	new_id BIGINT(20) NOT NULL,
	new_name VARCHAR(45) NOT null
	created_at DATETIME NOT NULL,
) ENGINE = ARCHIVE;

-- создадим триггеры на каждую запись

-- триггер на запись в таблицу users
DROP TRIGGER IF EXISTS users_insertion;
delimiter //
CREATE TRIGGER users_insertion AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (name_table, new_id, new_name, created_at)
	VALUES ('users', NEW.id, NEW.name, NOW());
END //
delimiter ;

-- триггер на запись в таблицу catalogs
DROP TRIGGER IF EXISTS catalogs_insertion;
delimiter //
CREATE TRIGGER catalogs_insertion AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (name_table, new_id, new_name, created_at)
	VALUES ('catalogs', NEW.id, NEW.name, NOW());
END //
delimiter ;

-- триггер на запись в таблицу catalogs
DROP TRIGGER IF EXISTS products_insertion;
delimiter //
CREATE TRIGGER products_insertion AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (name_table, new_id, new_name, created_at)
	VALUES ('products', NEW.id, NEW.name, NOW());
END //
delimiter ;

-- №2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

-- DROP TABLE IF EXISTS users; 
-- CREATE TABLE users (
-- 	id SERIAL PRIMARY KEY,
-- 	name VARCHAR(255),
-- 	birthday_at DATE,
-- 	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
--  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- );

DROP PROCEDURE IF EXISTS million_users ;
delimiter //
CREATE PROCEDURE million_users ()
BEGIN
	DECLARE i INT DEFAULT 100;
	WHILE i < 1000000 DO
		INSERT INTO users(id) VALUES (i);
		SET i = i + 1;
	END WHILE;
END //
delimiter ;

call million_users;