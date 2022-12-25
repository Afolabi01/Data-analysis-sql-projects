 
 CREATE TABLE IF NOT EXISTS movies (
   movie_title VARCHAR(100),
   release_date DATE,
   wikipedia_url VARCHAR(100),
   genre VARCHAR(100),
   director_1 VARCHAR(100),
   director_2 VARCHAR(100),
   cast_1 VARCHAR(100),
   cast_2 VARCHAR(100),
   cast_3 VARCHAR(100),
   cast_4 VARCHAR(100),
   cast_5 VARCHAR(100),
   budget BIGINT,
   revenue BIGINT
)


COPY movies(movie_title,release_date,wikipedia_url,genre,director_1,director_2,
               cast_1,cast_2,cast_3,cast_4,cast_5,budget,revenue)
FROM 'C:\Users\Public\movie_data.csv'
DELIMITER ','
CSV HEADER;


--Checking our data to make sure import is correct
SELECT * 
FROM movies
LIMIT 100;

--Checking for movies with revenue lesser than budget
WITH  profits as(SELECT movie_title , (revenue - budget) as profit_made
FROM movies)
SELECT movie_title , profit_made
FROM profits
WHERE profit_made < 0;

--Checking movies released per genre
SELECT genre ,COUNT(movie_title) as movies 
FROM (SELECT movie_title,genre,EXTRACT(YEAR from release_date) as year_of_release
FROM movies) AS y
GROUP BY genre
ORDER BY movies DESC

--Checking movies released per year 
SELECT year_of_release,COUNT(movie_title) as movies 
FROM (SELECT movie_title,genre,EXTRACT(YEAR from release_date) as year_of_release
FROM movies) AS y
GROUP BY year_of_release
ORDER BY movies DESC

--from above we see the movies in this dataset
--range from 2012 to 2016 with 2015 seeing the 
--highest count of movies and 2016 the lowest.

--We proceed to getting the aggregate budget and 
--revenue of different genres
SELECT genre , SUM(budget) as total_genre_budget, SUM(revenue) as total_genre_revenue
FROM movies 
GROUP BY genre
ORDER BY total_genre_revenue DESC;

--Creating a column to indicate profit or loss
WITH  profits as(SELECT movie_title , (revenue - budget) as profit_made
FROM movies)
SELECT movie_title , 
         CASE WHEN profit_made < 0 THEN 'loss'
         WHEN profit_made > 0 THEN 'profit'
         ELSE 'no returns' END as income
FROM profits;


--Rank the table by Revenue using window functions
SELECT movie_title , revenue ,
          RANK() OVER(ORDER BY revenue DESC) as ranking_by_revenue
FROM movies
ORDER BY ranking_by_revenue;

--Rank the table by Revenue partitioned by genre using window functions
SELECT movie_title ,genre, revenue ,
          RANK() OVER(PARTITION BY genre ORDER BY revenue DESC) as ranking_by_revenue
FROM movies
ORDER BY genre;

--Rank the table by Revenue partitioned by year using window functions
SELECT movie_title , EXTRACT(YEAR from release_date) as year_of_release, revenue ,
              RANK() OVER(PARTITION BY EXTRACT(YEAR from release_date) ORDER BY revenue DESC) as ranking_in_year
FROM movies
ORDER BY EXTRACT(YEAR from release_date);


--Getting the top 3 highest earning movies for all years
SELECT movie_title, year_of_release ,revenue, ranking_in_year
FROM (SELECT movie_title , EXTRACT(YEAR from release_date) as year_of_release, revenue ,
              RANK() OVER(PARTITION BY EXTRACT(YEAR from release_date) ORDER BY revenue DESC) as ranking_in_year
FROM movies) as s
WHERE  ranking_in_year IN(1,2,3)
ORDER BY year_of_release , ranking_in_year;