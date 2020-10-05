
-- Задание 2
-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

-- анализируем пользователя с id = 99

use social_network;
-- хочу вывести имя , фамилия и ID пользователя. Сначала сортирую по количеству сообщений пользователей, 
 -- в порядке убиывания, вывожу 1 строук, где наибольший показатель, по нему из табл users вывожу имя и фамилию
 
select name, surname, id from users where id = 
(select contact from
	(select contact, count(*) total_msgs from 
	(select from_user_id contact from messages where to_user_id=99
	union all
	select to_user_id contact from messages where from_user_id=99) as contacts
	group by contact order by total_msgs desc limit 1) as max_msgs);


-- Задача 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

-- К сожалению, немного скорректировала задачу. Считала пользователей , которые ПОСТАВИЛИ лайки,  
-- т.к. созданная мной таблица предполагала, сколько лайков от пользователей получили посты.

use social_network;

select sum(total_by_user) as total_likes_10_youngest from 
(select 
	user_id,
	(select birthday from users where id = ul.user_id) birthday,
	post_id,
	count(*) total_by_user
from user_likes ul group by user_id order by birthday limit 10) likes_sort;




-- Задача 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?

use social_network;

select
count(*) total_likes,
(select gender from users where id = l.user_id) gender
from user_likes l
group by gender order by total_likes desc limit 1;

-- Задача 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

use social_network;

-- прописала в порядке важности критериев на мой взгляд (от наиб. важного (лайки), до наим. (комментарии (по себе судила))
select id, name, surname from users where id = 
	(select id from
	(select 
		id,
		(select count(post_id) from user_likes where user_id = u.id) num_likes,
		(select count(body) from posts where user_id = u.id) num_posts,
		(select count(community_id) from users_communities where user_id = u.id) num_communities,
	 -- намеренно не учитывала статус запроса, т.к. активность показывает коилчество запросов в целом:
		(select count(target_user_id) from friend_requests where initiator_user_id = u.id) num_frrequests, -- сколько сам отправил запросов
		(select count(to_user_id) from messages where from_user_id = u.id) num_messages, -- сколько написал писем
		(select count(body) from comments where user_id=u.id) num_comments
	from users u
	group by id order by num_likes, num_posts, num_communities, num_frrequests, num_messages, num_comments
	limit 1) user_statistics);



