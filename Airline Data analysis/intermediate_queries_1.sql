-- CREATE TABLE pilots(
-- 	id SERIAL PRIMARY KEY,
-- 	name TEXT NOT NULL,
-- 	speciality TEXT NOT NULL,
-- 	age TEXT 
-- );
-- ALTER TABLE pilots
-- 	ALTER COLUMN age TYPE INT USING age::integer;

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
-- count of flights more than 50. Order the data from the largest number of flights to the least.
SELECT city ->> 'en' AS city, COUNT(city)
FROM flights
LEFT JOIN airports
ON airport_code = departure_airport
GROUP BY city
HAVING COUNT(city) >= 50
ORDER BY COUNT DESC; -- optimal solution 
					
					-- OR --
SELECT(SELECT city ->> 'en' FROM airports WHERE airport_code = departure_airport) AS departure_city,
COUNT(*)
FROM flights
GROUP BY (SELECT city ->> 'en' 
FROM airports 
WHERE airport_code = departure_airport)
HAVING COUNT(*) >=50
ORDER BY COUNT DESC;

-- 2. Return all flights from KZN airport in the indicated day: 2017-08-28 
-- show all departure times, departure airport, arrival airport and flight number

		
SELECT flight_no, scheduled_departure::time, departure_airport, 
	arrival_airport
FROM flights
WHERE departure_airport = 'KZN' 
	AND scheduled_departure::date = '2017-08-28' 
ORDER BY scheduled_departure

				-- OR --
SELECT f.flight_no,f.scheduled_departure :: time AS dep_time,
f.departure_airport AS departures,f.arrival_airport AS arrivals,
count (flight_id)AS flight_count
FROM flights f
WHERE f.departure_airport = 'KZN'
AND f.scheduled_departure >= '2017-08-28' :: date
AND f.scheduled_departure <'2017-08-29' :: date
GROUP BY 1,2,3,4,f.scheduled_departure
ORDER BY flight_count DESC,f.arrival_airport,f.scheduled_departure;
