
CREATE TABLE IF NOT EXISTS world_internet_users (
   country VARCHAR(100),
   region VARCHAR(100),
   population BIGINT,
   internet_users BIGINT,
   percentage_of_population DECIMAL(20)
)

COPY world_internet_users(country,region,population,internet_users,percentage_of_population)
FROM 'C:\Users\Public\world_internet_user.csv'
DELIMITER ','
CSV HEADER;


--Checking if observations were copied correctly
SELECT *
FROM world_internet_users;

--Confirmed our data is complete and we have 243 rows including the world statistics
--Moving forward I would be excluding the world statistics from most of my questions

--What are the population of users(total and internet) per region?
SELECT region, SUM(internet_users) as internet_user_by_region , SUM(population) as region_population
FROM world_internet_users
WHERE country <> 'World'
GROUP BY region
ORDER BY internet_user_by_region DESC;

--What percentage of each region are internet users
SELECT region, ROUND((internet_user_by_region / region_population) *100,2) as percentage_internet_users_by_region
FROM (SELECT region, SUM(internet_users) as internet_user_by_region , SUM(population) as region_population
             FROM world_internet_users
             WHERE country <> 'World'
             GROUP BY region) as region_stat
ORDER BY percentage_internet_users_by_region DESC;

--What country had the highest amount of internet users for each region
WITH max_values as (SELECT country , region , internet_users ,
                    RANK () OVER(PARTITION BY region ORDER BY internet_users DESC) as rank_of_country
FROM world_internet_users
WHERE country <> 'World'
GROUP BY country ,region ,internet_users
ORDER BY region)

SELECT country , internet_users , region 
FROM max_values
WHERE rank_of_country = 1;
