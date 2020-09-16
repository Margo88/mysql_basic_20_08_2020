-- Практическое задание №6 по теме 
-- “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
-- продолжение...

-- №3 Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
select
	(concat(users.name, ' ', users.surname)) as full_name,
	timestampdiff(year, users.birthday, now()) as age,
	posts.body, -- текст поста
	likes_posts.profile_id, -- автор лайка
	count(*) as likes_amount
from 
	users
join
	posts
	on users.id = posts.user_id
join 
	likes_posts
	on posts.id = likes_posts.post_id 
group by 
	full_name
order by
	age asc, likes_amount desc
limit 10;

-- №4 Определить кто больше поставил лайков (всего) - мужчины или женщины?

select
	users.gender, -- пол из users
	count(likes_posts.profile_id) as likes_amount
from 
	users
join 
	likes_posts
	on users.id = likes_posts.profile_id
group by users.gender;

-- №5 Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- в качестве критериев оценки активности пользователя в соц.сети примем число комментариев, постов, исх. сообщений и исх. запросов в друзья

select 
	*
from
(select 
	users.id,
	concat(users.name, ' ', users.surname) as full_name,
	count(comments.body) as all_comments,
	count(posts.body) as all_posts,
	count(messages.body) as all_messages,
	count(friend_requests.target_user_id) as all_requests
from 	
	users
left join
	comments
	on users.id = comments.user_id -- написанные комментарии
left join
	posts
	on users.id = posts.user_id -- опубликованные посты
left join 
	messages
	on users.id = messages.from_user -- исходящие сообщения
left join	
	friend_requests
	on users.id = friend_requests.initiator_user_id -- исходящие запросы в друзья
group by full_name) as all_activities
order by all_comments, all_posts, all_messages, all_requests 
limit 10;

