-- проектирование БД соцсети

create database if not exists fb2020;
-- или create database fb2020 - создание без проверки существования одноименной
-- также сущ. команда drop - удаление БД: drop database if exists fb2020

-- таблица для зарегестрированных пользователей
create table if not exists users(
    id SERIAL primary key, -- аналогично следующему: BIGINT unsigned not null auto_increment UNIQUE
    email varchar(150) unique, -- varchar - символы длиной 150 знаков 
    pass varchar(100),
    name varchar(50),
    surname varchar(50),
    phone varchar(20),
    gender char(1), 
    birthday date,
    hometown varchar(100),
    photo_id bigint unsigned, -- bigint: big integer. Заморачиваться на типах даных рекомендуется при создании крупных проектов 
    created_at datetime default now(),
    key(phone), -- индекс, позволяющий осущ. поиск по указанному полю
    key(name, surname)
); 

-- таблица для сообщений
create table if not exists messages(
	id serial primary key,
	from_user bigint unsigned not null,
	to_user bigint unsigned not null, -- значение не может быть пустым
	body text,
	is_read bool default 0,
	created_at datetime default current_timestamp,
	foreign key (from_user) references users(id), -- foreign key указывает, что введенный столбец ('назв. столбца') прямо соотносится к конкретному столбцу существующей таблицы 'таблица'('назв.столбца')
	foreign key (to_user) references users(id)
);

-- таблица настроек приватности
create table if not exists settings(
	user_id serial primary key,
	can_see ENUM('all', 'friends', 'friends_of_friends'), -- 'выпадающий список'
	can_comment ENUM('all', 'friends', 'friends_of_friends', 'nobody'),
	can_message ENUM('all', 'friends', 'friends_of_friends'),
	foreign key (user_id) references users(id)
);
-- таблица для запросов в друзья
create table if not exists friend_requests(
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
    status ENUM('requested', 'approved', 'unfriended', 'declined'),
    requested_at datetime default now(),
    confirmed_at datetime, 
    primary key (initiator_user_id, target_user_id),
    foreign key (initiator_user_id) references users(id),
    foreign key (target_user_id) references users(id),
    index(initiator_user_id),
    index(target_user_id)
);

-- таблица для сообществ
create table if not exists communities(
 	id serial,
	name varchar(255),
	primary key(id),
	index(name) -- команда, ктр говорит базе осуществлять поиск начиная с указанного столбца, как из отдельного объекта. Позволяет уменьшить ресурсы системы, затрачиваемые на поиск
); 

-- таблица о пользователях в сообществах. Т.к. один и тот же пользователь может состоять в нескольких сообществах,
-- и в одном сообществе может состоять много пользователей, логично выделить эти связи в отдельной таблице
create table if not exists users_communities(
	user_id bigint unsigned not null,
	community_id bigint unsigned not null,
	is_admin bool default 0,
	primary key (user_id, community_id), -- составной первичный ключ. исключает ситуацию, в ктр один и тот же юзер состоит в коммьюнити дважды
	foreign key (user_id) references users(id),
	foreign key (community_id) references communities(id)
);

-- таблица для постов пользователей
create table if not exists posts(
	id serial primary key,
	user_id bigint unsigned not null, -- автор поста
	body text, -- содержание поста
	created_at datetime default current_timestamp,
	updated_at datetime,
	foreign key (user_id) references users(id),
	index(user_id)
);

-- таблица для комментов
create table if not exists comments(
	id serial primary key,
	user_id bigint unsigned not null, -- автор коммента
	post_id bigint unsigned not null, -- пост, под которым коммент
	body text,
	created_at datetime default current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
);

-- таблица для фоток
create table if not exists photos(
	id serial primary key,
	user_id bigint unsigned not null,
	description varchar(255), -- описание фотки
	created_at datetime default current_timestamp,
	foreign key (user_id) references users(id),
	index(user_id)
);