-- Модель хранения данных hh.ru
-- хранит таблицы с пользователями, работодателями, резюме, вакансиями

-- drop database if exists head_hunter;
-- create database head_hunter;
-- use head_hunter;

-- ***таблицы для соискателей*** 

-- Таблица 1. Основная информация (данные при регистрации)
create table if not exists applicants(
	id serial primary key,
	name varchar(50) not null,
	surname varchar(50) not null,	 
	email varchar(150) unique,
	phone char(14) unique,
	date_of_birth date,
	gender ENUM('М', 'Ж'),
	photo_id bigint unsigned,
	nationality ENUM('Росиия', 'Украина', 'Беларусь', 'Казахстан', 'Таджикистан', 'Азербайджан'), -- здесь предполагается огромный выпадающий список со всеми странами 
	hometown varchar(30),
	experience bool default 0, -- наличие опыта работа: 1 - есть, 0 -нет
	ready_to_move bool default 0, -- готовность к переезду
	created_at datetime default now(),
	key(name, surname)	
);

-- Создаю отдельную таблицу с резюме, т.к. у пользователя их может быть создано несколько
-- Таблица 2. Резюме соискателей
create table if not exists applicants_cv(
	id serial primary key, -- номер записи в таблице
	applicant_id bigint unsigned not null, -- id соискателя 
	target_position varchar(150) not null, -- желаемая должность
	salary int, -- желаемая зарплата
	occupation_type ENUM('Полная', 'Частичная', 'Проектная', 'Стажировка'), -- занятость
	schedule ENUM('Полный день', 'Сменный график', 'Гибкий график', 'Удаленка'), 
	driver_license ENUM ('A', 'B', 'C', 'D', 'E'), -- категория прав
	about_me text, -- о себе
	created_at datetime default now(),
	foreign key (applicant_id) references applicants(id),	
	index(target_position)
);

-- Далее к резюме создаю отдельные таблицы под каждый блок (образование, опыт работы, клю.нвыки и пр.), 
-- т.к. в каждом блоке может быть несколько записей

-- Таблица 3. Проф. области соискателей 
create table if not exists professional_sphere(
	cv_id bigint unsigned not null,
	sphere ENUM('Административный персонал', 'Банки, инвестиции', 'Закупки', 'Маркетинг', 'IT', 'Продажи') default null,-- предполагается огромный список со всевозможными сферами
	foreign key (cv_id) references applicants_cv(id)
);

-- Таблица 4. Опыт работы
create table if not exists job_experience(
	cv_id bigint unsigned not null, -- id резюме
	start_date date not null, -- дата начала работы
	end_date date not null, -- дата окончания
	company varchar(100) not null, -- организация
	position_name varchar(100) not null, -- название должности 
	description text not null, -- обязанности и достижения
	foreign key (cv_id) references applicants_cv(id),
	index(position_name)
);

-- Таблица 5. Ключевые навыки
create table if not exists skills(
	cv_id bigint unsigned not null, 
	skill varchar(150) not null,
	primary key (cv_id, skill),
	foreign key (cv_id) references applicants_cv(id),
	index(skill)
);

-- Таблица 6. Образование
create table if not exists education(
	cv_id bigint unsigned not null, 
	edu_degree ENUM('Среднее', 'Среднее специальное', 'Неоконченное высшее', 'Высшее', 'Бакалавр', 'Магистр', 'Канидат наук') not null,
	university varchar(200) not null,
	faculty varchar(200) not null,
	specialty varchar(200) not null,
	end_date date, -- дата окончания
	foreign key (cv_id) references applicants_cv(id),
	index(specialty),
	index(edu_degree)
);

-- Таблица 7. Ин.яз
create table if not exists languages(
	cv_id bigint unsigned not null, 
	lang ENUM('Английский', 'Испанский', 'Немецкий', 'Французский', 'Китайский', 'Татарский'), -- предполагается огромный список всевозможных языков
	level ENUM('A1 - Начальный', 'A2 - Элементарный', 'B1 - Средний', 'B2 - Средне-продвинутый', 'C1 - Продвинутый', 'C2 - В совершенстве'),
	primary key (cv_id, lang),
	index(lang),
	foreign key (cv_id) references applicants_cv(id) 
);

-- Таблица 8. Видимость резюме
create table if not exists settings(
	cv_id serial primary key,
	can_see ENUM('Видно всему интернету', 'Не видно никому', 'Видно компаниям-клиентам hh', 'Видно выбранным компаниям', 'Скрыто от выбранных компаний'),
	foreign key (cv_id) references applicants_cv(id)
);

-- ***таблицы для работодателей***

-- Таблица 1. Основная информация (данные при регистрации)
create table if not exists employers(
	id serial primary key,
	company varchar(250) not null,
	INN char(10) unique, -- ИНН
	email varchar(150) unique,
	phone char(10) unique, 
	city varchar(30) not null,
	description text,
	url varchar(250) unique,
	logo_id bigint unsigned,
	created_at datetime default now(),
	index(company)	
);

-- Таблица 2. Вакансии
create table if not exists vacancies(
	id serial primary key, 
	employer_id bigint unsigned not null, -- id работодателя 
	vacancy varchar(150) not null, -- название вакансии
	salary int, -- зарплата
	city varchar(50),
	required_expirience ENUM('Без опыта', '1 год', '1-3 года', '3-6 лет', 'от 6 лет'), -- требуемый опыт работы
	occupation_type ENUM('Полная', 'Частичная', 'Проектная', 'Стажировка'), -- занятость
	schedule ENUM('Полный день', 'Сменный график', 'Гибкий график', 'Удаленка'), 
	description text,-- описание
	contacts varchar(150),
	created_at datetime default now(),
	foreign key (employer_id) references employers(id),
	index(vacancy),
	index(salary),
	index(city)
);

-- Таблица 3. Требуемые навыки
create table if not exists requirement_skills(
	vacancy_id bigint unsigned not null, 
	skill varchar(150) not null, 
	primary key (vacancy_id, skill),
	foreign key (vacancy_id) references vacancies(id),
	index(skill)
);

-- ***Взаимодействия соискателей и работодателей***

-- Таблица 1. Просмотры резюме
create table if not exists cv_views(
	id serial primary key, 
	cv_id bigint unsigned not null,
	employer_id bigint unsigned not null,
	last_view datetime not null, -- дата просмотра
	created_at datetime default now(),
	foreign key (cv_id) references applicants_cv(id),
	foreign key (employer_id) references employers(id)
);

-- Таблица 2. Отклики соискателей
create table if not exists responses(
	cv_id bigint unsigned not null,
	vacancy_id bigint unsigned not null,
	status bool default 0, -- факт просмотра: 1 - просмотрен, 0 -не просмотрен
	created_at datetime default current_timestamp, 
	primary key (cv_id, vacancy_id), -- откликнуться можно только 1 раз
	foreign key (cv_id) references applicants_cv(id),
	foreign key (vacancy_id) references vacancies(id)
);

-- Таблица 3. Приглашения работодателей 
create table if not exists invitations(
	from_employer bigint unsigned not null,
	to_applicant bigint unsigned not null,
	created_at datetime default current_timestamp, 
	primary key(from_employer, to_applicant),
	foreign key (from_employer) references employers(id),
	foreign key (to_applicant) references applicants(id)
);


-- 1. типовые запросы: 

-- поиск вакансий (по названию, сортировка по зп)

select 
	vacancy, 
	description, 
	salary 
from 
	vacancies v2 
where 
	vacancy = 'Повар'
order by salary;

-- Поиск вакансии по названию, городу, сортировка по зп

select 
	company,
	vacancy,
	salary
from 
	employers e 
join
	vacancies v 
	on e.id = v.employer_id
where 
	v.city = 'Москва' and v.vacancy = 'Продавец'
order by salary desc;

-- поиск соискателей по названию
-- карточка соискателя (pic1):
	
select 
	ac.target_position,
	year(current_date() ) - year (a.date_of_birth) as age,
	ac.salary,
	je.end_date,
	je.start_date,
	sum(year(je.start_date ) - year (je.end_date)) as experience,
	je.position_name,
	je.company 
from 
	applicants_cv ac 
join 
	job_experience je 
	on je.cv_id = ac.id 
join 
	applicants a 
	on a.id = ac.applicant_id
where 
	ac.target_position = 'Повар'
group by 
	a.id


-- 1. Триггер на просмотры резюме.
-- В таблицу cv_views добавляется строка при просмотре отклика работодателем в таблице responses (status = 1)
drop trigger if exists views_from_responses;
delimiter //
create trigger views_from_responses after update on responses
for each row 
begin 
	if new.status = 1 then
		insert into cv_views (cv_id, employer_id, last_view)
		values (old.cv_id, (select employer_id from vacancies where id = old.vacancy_id), now() );
	end if;
end//
delimiter ;

-- Триггер на проверку возрасата пользователя

drop trigger if exists check_age;
delimiter //
create trigger check_age before update on applicants
for each row 
begin 
	if year(current_date() ) - year (new.date_of_birth) <= 16 then
		signal sqlstate '45000' set message_text = 'Age must be more then 16';
	end if;
end//
delimiter ;


-- 4. Хранимая процедура рекомендации вакансий
-- Вакансии подбираются по общему городу, зарплате (выше, чем указал пользователь), названию и совпадающим скиллам
drop procedure if exists job_offer;
delimiter //
create procedure job_offer(in for_cv_id int )
begin
	select 
		vacancy,
		v.id,
		v.salary,
		rs.skill		
	from 
		vacancies v 
	join
		applicants a2 
		on v.city = a2.hometown
	join 
		applicants_cv ac 
		on v.vacancy = ac.target_position
	join 
		requirement_skills rs
		on v.id = rs.vacancy_id 
	join skills s 
		on s.skill = rs.skill 
	where  ac.salary < v.salary and a2.id = for_cv_id;
	
end
//
delimiter ;

-- Хранимая функция
-- Подсчет отправленных пользователем откликов и полученных приглашений
drop function if exists statistic;
delimiter //

create function statistic(applicant int)
returns float reads sql data
begin
	declare applicant_responses int;
	declare applicant_invitations int;
	
	set applicant_responses = (select count(*) from responses where cv_id in (select id from applicants_cv where applicant_id = applicant)); -- все отклики, которые разослал соискатель от всех своих резюме
	set applicant_invitations = (select count(*) from invitations where to_applicant = applicant);
	
	return  applicant_invitations / applicant_responses;
end //
delimiter ;

-- Статистика по разобранным откликам
-- (pic2)
drop function if exists views_emp;
delimiter //

create function views_emp(employer int)
returns float reads sql data
begin
	declare all_responses int;
	declare viewed_responses int;
	
	set all_responses = (select count(*) from responses where vacancy_id in (select id from vacancies where employer_id = employer) and status = 1); -- просмотренные отклики
	set viewed_responses = (select count(*) from responses where vacancy_id in (select id from vacancies where employer_id = employer) and status = 0); -- непросмотренные отклики 
	
	return  all_responses / viewed_responses * 100;
end //
delimiter ;

call job_offer(14);
select statistic(14);
select views_emp(14);

