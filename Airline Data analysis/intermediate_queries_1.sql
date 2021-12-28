-- CREATE TABLE pilots(
-- 	id SERIAL PRIMARY KEY,
-- 	name TEXT NOT NULL,
-- 	speciality TEXT NOT NULL,
-- 	age TEXT 
-- );

-- INSERT INTO pilots(name, speciality, age)
-- VALUES ('John', 'pilot', 50),
-- 		('Sarah', 'co-pilot', '35'),
-- 		('David', 'pilot', 'null');

-- INSERT INTO pilots(name, speciality, age)
-- VALUES ('Priscilla', 'pilot', NULL);
		
SELECT *
FROM pilots;

SELECT COUNT(age)
FROM pilots;

SELECT COUNT(*)
FROM pilots;

SELECT COUNT(passenger_name)
FROM tickets;

SELECT COUNT(DISTINCT passenger_name)
FROM tickets;

SELECT SUM(total_amount)
FROM bookings;

SELECT MIN(total_amount)
FROM bookings;

-- use groupby only when your select statement has aggregations. kinda makes sense, like pivot tables
-- and groupby in pandas
-- use HAVING in the same role as WHERE in non-aggregating SELECT statements

SELECT city ->> 'en' AS city, COUNT(*)
FROM airports
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY COUNT(*);

-- TEST YOURSELF
-- 1. Calculate the Average tickets Sales
SELECT AVG(total_amount)
FROM bookings;

-- 2. Return the number of seats in the air craft that has aircraft code = 'CN1'
SELECT COUNT(seat_no)
FROM seats
WHERE aircraft_code = 'CN1';

SELECT COUNT(seat_no)
FROM seats
GROUP BY aircraft_code
HAVING aircraft_code = 'CN1';

-- 3. Return the number of seats in the air craft that has aircraft code = 'SU9'
SELECT COUNT(seat_no)
FROM seats
WHERE aircraft_code = 'SU9';

-- 4. Write a query to return the aircraft_code and the number of seats of each air craft ordered ascending?
SELECT aircraft_code, COUNT(seat_no)
FROM seats
GROUP BY aircraft_code
ORDER BY COUNT;

-- 5. calculate the number of seats in the salons for all aircraft models, 
--but now taking into account the class of service Business class and Economic class.
SELECT aircraft_code,fare_conditions, COUNT(seat_no)
FROM seats
GROUP BY aircraft_code, fare_conditions
HAVING fare_conditions IN ('Economy', 'Business');

-- What was the least day in tickets sales? // what day has the least ticket sales?
SELECT book_date, SUM(total_amount)
FROM bookings
GROUP BY book_date
ORDER BY SUM(total_amount)
LIMIT 1;
               -- OR --
SELECT book_date, SUM(total_amount)
FROM bookings
GROUP BY 1
ORDER BY 2
LIMIT 1;


-- SQL AGGREGATION CHALLENGE --
-- 1. Determine how many flights from each city to other cities, return the the name of city and 
-- count of flights more than 50 order the data from the largest no of flights to the least?
SELECT city, COUNT(city)
FROM airports
GROUP BY city
HAVING COUNT(city) > 50
ORDER BY COUNT DESC;


		