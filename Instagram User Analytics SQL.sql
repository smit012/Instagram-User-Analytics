use ig_clone;

#1 Identify the five oldest users on Instagram from the provided database.
use ig_clone;
SELECT *
FROM users
ORDER BY created_at ASC 
LIMIT 5;



SELECT u.id as user_id, u.username
FROM users u
LEFT JOIN photos p 
ON u.id = p.user_id 
WHERE p.image_url IS NULL;



#3 The team has organized a contest where the user with the most likes on a single photo wins.
with photo_detail as(
select 
		p.user_id,
		l.photo_id,
		count(l.user_id) as total_likes
from likes l
join photos p on l.photo_id=p.id
group by l.photo_id
)

select u.id as user_id,
		u.username,	
		u.created_at,
        p.photo_id,
        p.total_likes
from users u
join photo_detail p
on u.id =p.user_id
ORDER BY p.total_likes DESC
LIMIT 1;


#4 Identify and suggest the top five most commonly used hashtags on the platform.
SELECT 
    tags.id, 
    tags.tag_name, 
    COUNT(pt.tag_id) AS tag_count
FROM tags 
JOIN photo_tags pt ON tags.id = pt.tag_id
GROUP BY tags.id
ORDER BY tag_count DESC
LIMIT 5;

#5  Determine the day of the week when most users register on Instagram. Provide insights on when to schedule an ad campaign.

select 
		dayname(created_at) as Registration_day,
        count(*) as Registration_count
from users
group by Registration_day
order  by Registration_count desc;


# Investor Metrics:#
#Calculate the average number of posts per user on Instagram. Also, provide the total number of photos on Instagram divided by the total number of users.
WITH total_stats AS (
SELECT 
    AVG(total_count) AS Avg_Posts_Per_User
FROM (
        SELECT p.user_id,
        count(*) AS total_count
		FROM photos p
		GROUP BY p.user_id) AS total_ )
SELECT 
(SELECT Avg_Posts_Per_User FROM total_stats) AS avg_posts_per_user,
-- total number of users on instagram
(SELECT COUNT(DISTINCT id) FROM users)AS total_users_on_instagram,

-- total number of photos on instagram
(SELECT COUNT(*) FROM photos) as total_photos_on_instagram,

-- the total number of photos on Instagram divided by the total number of users
(SELECT Count(*) FROM   photos) / (SELECT Count(*) FROM  users) AS total_photo_divby_user; 



#6 Identify users (potential bots) who have liked every single photo on the site, as this is not typically possible for a normal user.
with like_count as(
select user_id,
count(*) as likes_photo
from likes
group by user_id),

potential_bots as
(
select* 
from like_count l
where l.likes_photo = (select count(*) from photos)
)

select u.id, u.username, pb.likes_photo
from users u
join potential_bots pb on u.id = pb.user_id;
