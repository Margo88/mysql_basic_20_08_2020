
-- CRUD:
-- create

insert into
communities(id, name) values
(42, 'Black lives matter')

-- read

select users.name, users.surname, communities.name from 
users join users_communities on users.id = users_communities.user_id join communities on communities.id = users_communities.community_id where communities.id = 7 or communities.id = 3

select * from users 
where birthday < '1990-01-01' order by birthday 

select count(*) as 'all users 1980-1990' from 
users where birthday between '1980-01-01' and '1990-01-01'

select name, surname, email from users 
where email like ('%gmail.com')

select concat(name, ' ', surname) as 'full name', concat(email, ' ', phone) as 'contacts' from users


-- update

update messages 
set body = 'сообщение удалено по требованию роскомнадзор' where body like '%slave%'

-- delete

delete from comments where id = 2