SELECT *
FROM tickets 
WHERE ticket_no BETWEEN '0005432001020' AND '0005432001040';

SELECT *
FROM tickets 
WHERE ticket_no >= '0005432001020' AND ticket_no <= '0005432001040';

SELECT *
FROM aircrafts 
WHERE range IN (3000, 4200, 20000);

SELECT * 
FROM bookings
WHERE book_date IN ('2017-7-05%', '2017-7-15%', '2017-7-20%', '2017-7-25%');

SELECT * 
FROM bookings
WHERE left(to_char(book_date, 'YYYY-MM-DD HH24:MI:SS+MS'), 10) IN ('2017-07-05', '2017-07-10', '2017-07015');

-- SELECT *
-- FROM bookings
-- WHERE to_char(book_date, 'YYYY-MM-DD HH24:MI:SS+MS') IN ('2017-07-05 *', '2017-07-15 *', '2017-07-20 *', '2017-07-25 *');

SELECT book_date AS date_of_booking, total_amount AS amount
FROM bookings
WHERE left(to_char(book_date, 'YYYY-MM-DD HH24:MI:SS+MS'), 10) IN ('2017-07-05', '2017-07-10', '2017-07015');

SELECT passenger_name
FROM tickets
WHERE passenger_name LIKE '__IN%';

SELECT * 
FROM ticket_flights
WHERE fare_conditions = 'Business'
LIMIT 10;

SELECT passenger_name, contact_data
FROM tickets
ORDER BY passenger_name DESC
LIMIT 50;

SELECT * 
FROM boarding_passes
LIMIT 10;

SELECT *
FROM boarding_passes
FETCH FIRST 10 ROW ONLY;

SELECT * 
FROM boarding_passes
OFFSET 4
LIMIT 10;

SELECT *
FROM boarding_passes
OFFSET 4
FETCH FIRST 10 ROW ONLY;

-- Both LIMIT and FETCH give the same results in the examples above, but LIMIT/OFFSET are off standard
-- and are not portable across several RDBMS


SELECT * 
FROM aircrafts
WHERE aircraft_code NOT IN ('SU9', 'CN1', '763');

SELECT flight_id, flight_no, departure_airport, arrival_airport, status
FROM flights
WHERE status NOT IN ('Scheduled', 'Delayed', 'Cancelled');

SELECT * 
FROM flights
WHERE actual_departure ISNULL AND actual_arrival ISNULL;

SELECT * 
FROM flights
WHERE actual_departure IS NOT NULL AND actual_arrival IS NOT NULL;

SELECT '50'::INTEGER;
SELECT '01-01-2020'::TIMESTAMPTZ;
-- same as
SELECT CAST('50' AS INTEGER);
SELECT CAST('01-01-2020' AS TIMESTAMPTZ);

SELECT 'true'::BOOLEAN;
SELECT CAST('t' AS BOOLEAN);

SELECT '2 weeks'::INTERVAL;


-- BEGINNER SQL CHALLENGE

-- SELECT flights.departure_airport, airports.city AS departure_city , 
-- 	flights.arrival_airport, airports.city AS arrival_city
-- FROM flights
-- LEFT JOIN airports 
-- ON (flights.departure_airport = airports.airport_code OR flights.arrival_airport = airports.airport_code)
-- --WHERE airports.city ->> 'en' <> 'Moscow'

SELECT DISTINCT city ->> 'en' AS city
FROM airports
WHERE city ->> 'en' <> 'Moscow'
ORDER BY city;

SELECT airport_name ->> 'en' AS airport
FROM airports
WHERE timezone IN ('Asia/Novokutznetsk', 'Asia/Krasnoyarsk')
ORDER BY airport_name;

SELECT model ->> 'en' AS aircraft_model
FROM aircrafts
WHERE range BETWEEN 3000 AND 6000;

SELECT model, range, ROUND(range/1.609, 2) AS mileage
FROM aircrafts;

-- Return all information about air craft that has aircraft_code = 'SU9' and its range in miles ?
SELECT *, ROUND(range/1.609,2) AS mileage
FROM aircrafts
WHERE aircraft_code = 'SU9';

