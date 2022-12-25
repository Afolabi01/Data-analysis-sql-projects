CREATE TABLE IF NOT EXISTS car_price (
   car_id VARCHAR(100),
   price BIGINT,
   fuel_type VARCHAR(100),
   gear_type VARCHAR(100),
   make VARCHAR(100),
   model VARCHAR(100),
   year_of_manufacture BIGINT,
   colour VARCHAR(100),
   condition VARCHAR(100),
   mileage BIGINT,
   engine_size BIGINT,
   selling_condition VARCHAR(100),
   bought_condition VARCHAR(100),
   car_type VARCHAR(100),
   trim VARCHAR(100),
   drivetrain VARCHAR(100),
   seats SMALLINT,
   number_of_cylinders INT,
   horse_power INT,
   registered_city VARCHAR(100)
)

copy car_price(car_id,price,fuel_type,gear_type,make,model,year_of_manufacture,
				colour,condition,mileage,engine_size,selling_condition,bought_condition,
				car_type,trim,drivetrain,seats,number_of_cylinders,horse_power,registered_city

)
from 'C:\Users\Public\car_prices.csv'
delimiter ','
CSV Header;


-- Confirming the properties of the data has over 3700+ rows and 20 columns
SELECT *
FROM car_price
LIMIT 10;

--What car colors are the most purchased
SELECT colour , COUNT(*) as number_of_colours
FROM car_price
WHERE colour IS NOT NULL
GROUP BY colour
ORDER BY number_of_colours DESC;

--What makers are the most purchased?
SELECT make , COUNT(*) as number_of_cars
FROM car_price
WHERE make IS NOT NULL
GROUP BY make
ORDER BY number_of_cars DESC;

--After confirming the most purchased maker,what models are being bought?
SELECT DISTINCT model
FROM car_price
WHERE make = 'Toyota';

--What are the top 5 purchased models of Toyota
SELECT model , COUNT(*) as number_of_cars
FROM car_price
WHERE model IS NOT NULL
GROUP BY model
ORDER BY number_of_cars DESC
LIMIT 5;

--What car maker made the most from sales
SELECT make , SUM(price) as sales
FROM car_price
GROUP BY make
ORDER BY sales DESC;

--What is the total amount made from car sales
SELECT SUM(price) as total_sales
FROM car_price;

--What is the range of year of manufacturing
SELECT MAX(year_of_manufacture), MIN(year_of_manufacture) ,(MAX(year_of_manufacture) - MIN(year_of_manufacture)) as range_of_years
FROM car_price;

--Checking the average mileage of different car makers
SELECT make , ROUND(AVG(mileage),2) as avg_car_mileage
FROM car_price
GROUP BY make
ORDER BY avg_car_mileage DESC;

--How many cars are being purchased for the various gear types and fuel types?
SELECT COUNT(car_id) as count_of_cars,fuel_type , gear_type
FROM car_price
GROUP BY CUBE (fuel_type , gear_type)
ORDER BY count_of_cars DESC;