/* This document contain 29 cases and queries to an Airline Database using SQL
-- The database is made up of eight (8) tables namely: 
-- 1. airports
-- 2. aircrafts
-- 3. boarding_passes
-- 4. bookings
-- 5. flights
-- 6. seats
-- 7. tickets
-- 8. ticket_flights
*/

-- CASE I: List the cities in which there is no flights from Moscow.

SELECT DISTINCT city->> 'en' AS city
FROM airports
WHERE city->> 'en' <> 'Moscow'
ORDER BY city;


-- CASE II: Select airports with time zone in Asia / Novokuznetsk and Asia / Krasnoyarsk.

SELECT *
FROM airports
WHERE timezone IN ('Asia/Novokuznetsk','Asia/Krasnoyarsk');


-- CASE III: Which planes have a flight range from 3000 km to 6000 km?

SELECT *
FROM aircrafts
WHERE RANGE BETWEEN 3000 AND 6000;


-- CASE IV: Get the model, range and miles of every aircraft exist in the airlines database.
-- Notice that miles = range/1.609 and round the result to 2 numbers after the float point.

SELECT model, RANGE, round(RANGE/1.609, 2) AS miles
FROM aircrafts;


-- CASE V: Calculate the Average ticket sales.

SELECT AVG(total_amount) AS average_ticket_sales
FROM bookings;


-- CASE VI: Return the number of seats in the aircraft that has aircraft code ‘CN1’.

SELECT COUNT (*) AS CN1_seats
FROM seats
WHERE aircraft_code= 'CN1';


-- CASE VII: Return the number of seats in the aircraft that has aircraft code ‘SU9’.

SELECT COUNT (*) AS SU9_seats
FROM seats
WHERE aircraft_code= 'SU9';


-- CASE VIII: Write a query to return the aircraft code and the number of seats 
-- of each aircraft in ascending order.


SELECT aircraft_code, COUNT(*)
FROM seats
GROUP BY aircraft_code
ORDER BY count;


-- CASE IX: Calculate the number of seats for all aircraft models
-- but now taking into account the class of service; Business class and Economic class.

SELECT aircraft_code, fare_condition, COUNT(*)
FROM seats
GROUP BY 1,2
ORDER BY 1,2;


-- CASE X: What was the least day in tickets sales?

SELECT book_date, SUM(total_amount) AS sales
FROM bookings
GROUP BY 1
ORDER BY 2
LIMIT 1;


























