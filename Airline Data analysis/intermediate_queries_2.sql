/*
CASE: works like if statements. It goes through conditions and returns a value 
when first condition is met. Must include WHEN and THEN but ELSE part is optional
*/

SELECT DATE_PART('month', book_date) AS month, SUM(total_amount) AS bookings,
CASE WHEN SUM(total_amount) > 6923152600.00 THEN 'the most'
	 WHEN SUM(total_amount) < 6923152600.00 THEN 'the least'
	 ELSE 'the medium' END booking_case
FROM bookings
GROUP BY month;


-- NULLIF: returns null if arg 1 = arg 2, otherwise returns arg1

-- count number of null values from actual departure and actual arrival columns
SELECT COUNT(NULLIF(actual_departure, null)) AS null_departures, 
	COUNT(NULLIF(actual_arrival, null)) AS null_arrivals
FROM flights

-- count non-null arrival and departure values
SELECT COUNT(*)- COUNT(NULLIF(actual_departure, null)) AS non_null_departures,
	COUNT(*) - COUNT(NULLIF(actual_arrival, null)) AS non_null_arrivals
FROM flights


-- COALESCE: By default, returns the firs non-null value in a query
-- often used to substitute a default value for null values when querying the data
-- you do this by specifying the replacement value in the coalesce args

-- replacing null arrival and departure times with current timestamp
SELECT status, COALESCE(actual_arrival, current_timestamp), 
	COALESCE(actual_departure, current_timestamp)
FROM flights

SELECT COUNT(actual_arrival), 
	COUNT(actual_departure)
FROM flights

SELECT 
