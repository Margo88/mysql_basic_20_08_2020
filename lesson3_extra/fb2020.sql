-- �������������� �� �������

create database if not exists fb2020;
-- ��� create database fb2020 - �������� ��� �������� ������������� �����������
-- ����� ���. ������� drop - �������� ��: drop database if exists fb2020

-- ������� ��� ������������������ �������������
create table if not exists users(
    id SERIAL primary key, -- ���������� ����������: BIGINT unsigned not null auto_increment UNIQUE
    email varchar(150) unique, -- varchar - ������� ������ 150 ������ 
    pass varchar(100),
    name varchar(50),
    surname varchar(50),
    phone varchar(20),
    gender char(1), 
    birthday date,
    hometown varchar(100),
    photo_id bigint unsigned, -- bigint: big integer. �������������� �� ����� ����� ������������� ��� �������� ������� �������� 
    created_at datetime default now(),
    key(phone), -- ������, ����������� ����. ����� �� ���������� ����
    key(name, surname)
); 

-- ������� ��� ���������
create table if not exists messages(
	id serial primary key,
	from_user bigint unsigned not null,
	to_user bigint unsigned not null, -- �������� �� ����� ���� ������
	body text,
	is_read bool default 0,
	created_at datetime default current_timestamp,
	foreign key (from_user) references users(id), -- foreign key ���������, ��� ��������� ������� ('����. �������') ����� ����������� � ����������� ������� ������������ ������� '�������'('����.�������')
	foreign key (to_user) references users(id)
);

-- ������� �������� �����������
create table if not exists settings(
	user_id serial primary key,
	can_see ENUM('all', 'friends', 'friends_of_friends'), -- '���������� ������'
	can_comment ENUM('all', 'friends', 'friends_of_friends', 'nobody'),
	can_message ENUM('all', 'friends', 'friends_of_friends'),
	foreign key (user_id) references users(id)
);
-- ������� ��� �������� � ������
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

-- ������� ��� ���������
create table if not exists communities(
 	id serial,
	name varchar(255),
	primary key(id),
	index(name) -- �������, ��� ������� ���� ������������ ����� ������� � ���������� �������, ��� �� ���������� �������. ��������� ��������� ������� �������, ������������� �� �����
); 

-- ������� � ������������� � �����������. �.�. ���� � ��� �� ������������ ����� �������� � ���������� �����������,
-- � � ����� ���������� ����� �������� ����� �������������, ������� �������� ��� ����� � ��������� �������
create table if not exists users_communities(
	user_id bigint unsigned not null,
	community_id bigint unsigned not null,
	is_admin bool default 0,
	primary key (user_id, community_id), -- ��������� ��������� ����. ��������� ��������, � ��� ���� � ��� �� ���� ������� � ���������� ������
	foreign key (user_id) references users(id),
	foreign key (community_id) references communities(id)
);

-- ������� ��� ������ �������������
create table if not exists posts(
	id serial primary key,
	user_id bigint unsigned not null, -- ����� �����
	body text, -- ���������� �����
	created_at datetime default current_timestamp,
	updated_at datetime,
	foreign key (user_id) references users(id),
	index(user_id)
);

-- ������� ��� ���������
create table if not exists comments(
	id serial primary key,
	user_id bigint unsigned not null, -- ����� ��������
	post_id bigint unsigned not null, -- ����, ��� ������� �������
	body text,
	created_at datetime default current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
);

-- ������� ��� �����
create table if not exists photos(
	id serial primary key,
	user_id bigint unsigned not null,
	description varchar(255), -- �������� �����
	created_at datetime default current_timestamp,
	foreign key (user_id) references users(id),
	index(user_id)
);