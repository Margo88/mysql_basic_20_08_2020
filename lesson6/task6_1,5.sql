-- №2. Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

-- вытащим все сообщения, которые написал наш пользователь и все сообщения, которые нашему пользователю написали: 
-- select to_user as msg_friend, count(body) as msg_qty from messages where from_user = 17 group by to_user 
-- union
-- select from_user as msg_friend, count(body) as msg_qty from messages where to_user = 17 group by from_user


select 
		msg_friend, 
		sum(msg_qty) as msg_amount
from 
		(select to_user as msg_friend, count(body) as msg_qty from messages where from_user = 17 group by to_user 
		union
		select from_user as msg_friend, count(body) as msg_qty from messages where to_user = 17 group by from_user) as all_messages 
group by 
		msg_friend
order by
		msg_amount desc;
		
-- №3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

-- DROP TABLE IF EXISTS `likes_posts`;
-- CREATE TABLE `likes_posts` (
--   `id` bigint unsigned NOT NULL AUTO_INCREMENT,
--   `post_id` bigint unsigned NOT NULL,
--   `profile_id` bigint unsigned NOT NULL,
--   `likepage` bigint unsigned NOT NULL,
--   `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
--   PRIMARY KEY (`id`),
--   UNIQUE KEY `id` (`id`),
--   KEY `user_id` (`profile_id`),
--   KEY `post_id` (`post_id`),
--   CONSTRAINT `likes_posts_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `users` (`id`),
--   CONSTRAINT `likes_posts_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
-- ) ENGINE=InnoDB AUTO_INCREMENT=34787 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- создадим таблицу с id, именами пользователей, их возрастом, у которых есть лайки 
select 
	users.id, users.name, timestampdiff(year, users.birthday , now()) as age, likes_posts.likepage 
from 
	users

join 
	likes_posts
on 
	likes_posts.profile_id = users.id ;
