use imdb;
#1. Count the total number of records in each table of the database.
select 'director_mapping'as colunmname ,count(movie_id) as Total_records from director_mapping union
select 'genre',count(movie_id) from genre union
select 'movie',count(id) from movie union
select 'names',count(ID) FROM names union
select 'ratings',count(movie_id) from ratings union
select 'role_mapping',count(movie_id)from role_mapping;



#2. Identify which columns in the movie table contain null values.

select 'id' AS column_name, COUNT(*) - COUNT(id) as null_count from movie union
    select 'title', COUNT(*) - COUNT(title) from movie union 
    select 'year', COUNT(*) - COUNT(year) from movie union 
    select 'date_published', COUNT(*) - COUNT(date_published) from movie union 
    select 'duration', COUNT(*) - COUNT(duration) from movie union 
    select 'country', COUNT(*) - COUNT(country) from movie union
    select 'worlwide_gross_income', COUNT(*) - COUNT(worlwide_gross_income) from movie union
    select 'languages', COUNT(*) - COUNT(languages) from movie union
    select 'production_company', COUNT(*) - COUNT(production_company) from movie;


#3. Determine the total number of movies released each year, and analyze how the trend changes month-wise.
select year, COUNT(*) as total_movies
from movie
group by year;

select year(date_published) as released_year,
      month(date_published) as released_month,
      count(*) AS total_movies from movie
group by year(date_published), month(date_published)
order by released_year,released_month;


#4. How many movies were produced in either the USA or India in the year 2019?
select COUNT(*)  as produced_movies
from movie 
where country in ('usa','india')
and year = 2019;

#5. List the unique genres in the dataset, and count how many movies belong exclusively to one genre.

select distinct genre,count(*)
FROM genre group by genre order by  genre ;

select count(*) AS exclusively_one_genre
from (select movie_id from genre
	 group by movie_id
     having count(genre) = 1) as single_genre_movies;



#6. Which genre has the highest total number of movies produced?
select genre, count(*) as total_movies
from genre
group by genre
order by total_movies desc
limit 1;




#7. Calculate the average movie duration for each genre.
select g.genre, avg(m.duration) as avg_duration
from movie m
join genre g on m.id = g.movie_id
group by g.genre;

#8. Identify actors or actresses who have appeared in more than three movies with an average rating below 5.

select n.name as actor_name,
count(distinct rm.movie_id) as low_rating_movies
from role_mapping rm
join ratings r ON rm.movie_id = r.movie_id 
join names n ON rm.name_id = n.id
where r.avg_rating < 5
group by rm.name_id
having low_rating_movies > 3
order by low_rating_movies desc ;


#9. Find the minimum and maximum values for each column in the ratings table, excluding the movie_id column.
select 
    min(avg_rating) as min_avg_rating,
    max(avg_rating) as max_avg_rating,
    min(total_votes) as min_total_votes,
    max(total_votes) as max_total_votes,
    min(median_rating) as min_median_rating,
    max(median_rating) as max_median_rating
from ratings;


#10. Which are the top 10 movies based on their average rating?

select m.title, r.avg_rating
from movie m
join ratings r on m.id = r.movie_id
order by r.avg_rating desc
limit 10;


#11. Summarize the ratings table by grouping movies based on their median ratings.

select median_rating, count(*) as total_movies
from ratings
group by median_rating
order by median_rating ;





#12. How many movies, released in March 2017 in the USA within a specific genre, had more than 1,000 votes?

select g.genre ,count(distinct m.id) as released_movies
from movie m
join genre g on m.id = g.movie_id
join ratings r on m.id = r.movie_id
where m.country like '%USA%'
and month(m.date_published) = 3 and year(m.date_published) = 2017
and r.total_votes > 1000
group by g.genre ;



#13. Find movies from each genre that begin with the word “The” and have an average rating greater than 8.

select m.Title, g.Genre, r.Avg_Rating from movie m
join genre g on m.id = g.movie_id
join ratings r on m.id = r.movie_id
where m.title like 'The%' and r.avg_rating > 8 order by avg_rating desc;



#14. Of the movies released between April 1, 2018, and April 1, 2019, how many received a median rating of 8?

select count(distinct m.id) as median_rating_8 from movie m
join ratings r on m.id = r.movie_id
where m.date_published between '2018-04-01' and '2019-04-01'and r.median_rating = 8;



#15. Do German movies receive more votes on average than Italian movies?

select avg(case when m.languages like '%German%' then r.total_votes end) as avg_votes_german,
avg(case when m.languages like '%Italian%' then r.total_votes end) as avg_votes_italian 
from movie m
join ratings r on m.id = r.movie_id;


#16. Identify the columns in the names table that contain null values.

select 'id' AS column_name, count(*) - count(id) as null_count from names union all
select 'name', count(*) - COUNT(name) from names union all 
select 'height', count(*) - COUNT(height) from names union all
select 'date_of_birth', COUNT(*) - COUNT(date_of_birth) from names union all
select 'known_for_movies', COUNT(*) - COUNT(known_for_movies) from names;





#17. Who are the top two actors whose movies have a median rating of 8 or higher?

select n.name, COUNT(*) AS movie_count
from role_mapping rm
join names n on rm.name_id = n.id
join ratings rt on rm.movie_id = rt.movie_id
where rm.category in ('actor')
and rt.median_rating >= 8
group by n.name
order by  movie_count desc
limit 2;

#18. Which are the top three production companies based on the total number of votes their movies received

select m.production_company, sum(r.total_votes) as total_votes
from movie m
join ratings r on m.id = r.movie_id
group by  m.production_company
order by  total_votes desc
limit 3;


#19. How many directors have worked on more than three movies?

select count(*) as directors_count
from (select name_id 
from director_mapping
group by  name_id 
having count(movie_id) > 3) as directors_count;



#20. Calculate the average height of actors and actresses separately.

select rm.category, 
avg(n.height) as avg_height
from role_mapping rm
join names n on rm.name_id = n.id
where rm.category in ('actor', 'actress')
group by rm.category;


#21. List the 10 oldest movies in the dataset along with their title, country, and director.

select m.title, m.country, n.name AS director
from movie m
join director_mapping dm ON m.id = dm.movie_id
join names n ON dm.name_id = n.id
order by  m.year, m.date_published
limit 10;




#22. List the top 5 movies with the highest total votes, along with their genres.

select m.title as movie_title,
group_concat(distinct g.genre order by g.genre separator', ') as genres,
r.total_votes from movie m
join ratings r ON m.id = r.movie_id
join genre g ON m.id = g.movie_id
group by m.id
order by r.total_votes desc
limit 5;



#23. Identify the movie with the longest duration, along with its genre and production company.

select m.title, g.genre, m.production_company, m.duration
from movie m
join genre g on m.id = g.movie_id
order by m.duration desc
limit 2;


#24. Determine the total number of votes for each movie released in 2018.

select m.title, sum(r.total_votes) AS total_votes
from movie m
join ratings r on m.id = r.movie_id
where m.year = 2018
group by  m.id;


#25. What is the most common language in which movies were produced?

select languages,COUNT(*) as total_movies from movie
group by languages 
order by total_movies desc limit 1;

