-- select count(*) from seats
-- SELECT COUNT (DISTINCT timezone) FROM airports
-- SELECT * FROM airports
-- WHERE city ->>'en' = 'Moscow'

-- SELECT * FROM aircrafts
-- WHERE aircraft_code = '773'

-- SELECT * FROM airports
-- WHERE timezone != 'Asia/Yakutsk';

-- SELECT * FROM bookings
-- WHERE total_amount <= 200000

SELECT * FROM seats
WHERE aircraft_code = '319'
	AND fare_conditions = 'Business';

SELECT * FROM seats
WHERE aircraft_code = '319'
	OR fare_conditions = 'Business';
	
SELECT * FROM aircrafts
WHERE model ->> 'en' LIKE 'Airbus%200';

SELECT * FROM aircrafts
WHERE model ->> 'en' NOT LIKE 'Airbus%' AND model ->> 'en' NOT LIKE 'Boeing%';

SELECT * FROM aircrafts
WHERE model->>'en'  LIKE 'A_rbus%';
