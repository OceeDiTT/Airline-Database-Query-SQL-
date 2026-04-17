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


-- CASE XI: Return all information about aircraft that has aircraft code ‘SU9’ and its range in miles.

SELECT *, ROUND(RANGE/1.69,2) AS range_in_miles
FROM aircrafts
WHERE aircraft_code= 'SU9';


-- CASE XII: What is the shortest flight duration for each possible flight from Moscow to St. Petersburg,
-- and how many times was the flight delayed for more than an hour?

SELECT flight_no, (scheduled_arrival - scheduled departure) AS scheduled_duration,
MIN (scheduled_arrival - scheduled departure), MAX(scheduled_arrival - scheduled departure),
SUM(CASE WHEN actual_departure > scheduled_departure + INTERVAL '1 hour' THEN 1 ELSE 0 END) delays
FROM flights
WHERE (SELECT city ->> 'en' FROM airports WHERE airport_code= departure_airport)='Moscow'
AND (SELECT city ->> 'en' FROM airports WHERE airport_code= arrival_airport)='St. Petersburg'
AND status= 'Arrived'
GROUP BY flight_no, (scheduled_arrival - scheduled departure);


-- CASE XIII: Write a query to arrange the range of model of aircrafts so short range is less than 2000,
-- middle range is more than 2000 and less than 5000 and any range above 5000 is long range.

SELECT model, RANGE,
CASE WHEN RANGE < 2000 THEN 'Short'
WHEN RANGE < 5000 THEN 'Middle'
ELSE 'Long'
END AS RANGE
FROM aircrafts
ORDER BY model;


-- CASE XIV: Determine how many flights from each city to other cities, return the name of the city and count of flights more than 50.
-- Order the data from the largest number of flights to the least.

SELECT (SELECT city->> 'en' FROM airports WHERE  airport_code= departure_airport)
AS departure_city, COUNT (*)
FROM flights
GROUP BY (SELECT city->> 'en' FROM airports WHERE airport_code= departure_airport)
HAVING COUNT (*)>= 50
ORDER BY COUNT DESC;


-- CASE XV: Return all flight details in the indicated day (2017-08-28) from airport whose code is ‘KZN’.
-- Include flight count in ascending order, departures count and when departures happens and arrivals count 
-- and when arrivals happen.

SELECT flight_no, scheduled_departure :: time AS dep_time, departure_airport AS departures, arrival_airport AS arrivals,
COUNT(flight_id) AS flight_count
FROM flights
WHERE departure_airport= 'KZN'
AND scheduled_departure >= '2017-08-28':: date
AND scheduled_departure < '2017-08-29':: date
GROUP BY 1,2,3,4, scheduled_departure
ORDER BY flight_count
DESC, arrival_airport, scheduled_departure;


-- CASE XVI: Who travelled from Moscow (SVO) to Novosibirsk (OVB) on seat 1A the day before yesterday,
-- and when was the ticket booked?

/* The day before yesterday is counted from the public.now value,
not from the current date. */

SELECT t.passenger_name, book_date FROM bookings b
JOIN tickets t
ON t.book_ref= b.book_ref
JOIN boarding_passes bp
ON bp.ticket_no= t.ticket_no
JOIN flight f
ON f.flight_id= bp.flight_id
WHERE f.departure_airport= 'SVO' AND f.arrival_airport= 'OVB'
AND f.scheduled_departure::date= public.now()::date - INTERVAL '2 day'
AND bp.seat_no= '1A';


-- CASE XVII: Find the most disciplined passengers who checked in first for all their flights.
-- Take into account only those passengers who took at least two flights.

SELECT t.passenger_name, t.ticket_no FROM tickets t
JOIN boarding_passes bp
ON bp.ticket_no= t.ticket_no
GROUP BY t.passenger_name, t.ticket_no
HAVING MAX(bp.boarding_no)= 1 AND COUNT(*)>1;


-- CASE XVIII: Calculate the number of passengers and number of flights departing from one airport (SVO)
-- during each hour on the indicated day 2017-08-02.

SELECT date_part('hour', f.scheduled_departure) AS hour, COUNT(ticket_no)passengers_cnt,
COUNT(DISTINCT f.flight_id) flights_cnt
FROM flights f
JOIN ticket_flights t
ON f.flight_id= t.flight_id
WHERE f.departure_airport= 'SVO'
AND f.scheduled_departure >= '2017-08-02':: date
AND f.scheduled_departure < '2017-08-03':: date
GROUP BY date_part('hour', f.scheduled_departure);


-- CASE XIX: Return unique city name, flight number, airport and time zone.

SELECT DISTINCT a.city->> 'en' AS cities, f.flight_no, a.airport_name->> 'en' AS airport, a.timezone
FROM flights f
JOIN airports a
ON a.airport_code= f.departure_airport;


-- CASE XX: How many people can be included into a single booking according to the available data?

SELECT tt.bookings_no, count(*) passengers_no
FROM (SELECT t.book_ref, COUNT(*)bookings_no FROM tickets t GROUP BY t.book_ref)tt
GROUP BY tt.bookings_no
ORDER BY tt.bookings_no;


-- CASE XXI: Which combination of first and last names occur most often?
-- What is the ratio of the passengers with such names to the total number of passengers?

SELECT passenger_name, ROUND(100.0*cnt/SUM(cnt)OVER(),2) AS percent
FROM (SELECT passenger_name, COUNT(*)cnt FROM tickets GROUP BY passenger_name)sub
ORDER BY percent DESC;


-- CASE XXII: What are the maximum and minimum ticket prices in all directions?

SELECT (SELECT city->>'en' FROM airports WHERE airport_code= f.departure_airport) AS departure_city,
SELECT city->>'en' FROM airports WHERE airport_code= f.arrival_airport) AS arrival_city, MAX(tf.amount), MIN(tf.amount)
FROM flights f
JOIN ticket_flights tf
ON f.flight_id = tf.flight_id
GROUP BY 1,2
ORDER BY 1,2;


-- CASE XXIII: Get a list of airports in cities with more than one airports.

SELECT aa.city->>'en' AS city, aa.airport_code, aa.airport_name->>'en' AS airport
FROM (SELECT city, COUNT(*) FROM airports GROUP BY city HAVING COUNT(*)>1) AS a
JOIN airports AS aa
ON a.city= aa.city
ORDER BY aa.city, aa.airport_name;


-- CASE XXIV: What will be the total number of different routes that are theoretically laid between all cities?

SELECT COUNT(*)
FROM(SELECT DISTINCT city FROM airports) AS a1
JOIN(SELECT DISTINCT city FROM airports) AS a2
ON a1.city <> a2.city;


-- CASE XXV: Suppose our airline marketers want to know how often there are different names among the passengers?

SELECT LEFT(passenger_name, STRPOS(passenger_name, ' ')-1) AS firstname, COUNT(*)
FROM tickets
GROUP BY 1
ORDER BY 2 DESC;


-- CASE XXVI: What combination of first names and last names separately occur most often?
-- What is the ratio of the passengers with such names to the total number of passengers?

WITH p AS (SELECT LEFT(passenger_name, POSITION(' ' IN passenger_name)) AS passenger_name FROM tickets)
SELECT passenger_name, round(100.0*cnt/SUM(cnt)OVER(),2) AS percent
FROM(SELECT passenger_name, COUNT(*)cnt FROM p GROUP BY passenger_name)t
ORDER BY percent DESC;


-- CASE XXVII: For each ticket, display all the included flight segments, together with connection time.
-- Limit the result to the tickets booked a week ago.

SELECT tf.ticket_no, f.departure_airport, f.arrival_airport, f.scheduled_arrival,
LEAD(f.scheduled_departure)OVER w AS next_departure,
LEAD(f.scheduled_departure)OVER w - f.scheduled_arrival AS gap
FROM bookings b
JOIN tickets t
ON t.book_ref = b.book_ref
JOIN ticket_flights tf
ON tf.ticket_no = t.ticket_no
JOIN flights f
ON tf.flight_id = f.flight_id
WHERE b.book_date = public.now()::date - INTERVAL '7day'
WINDOW w AS (PARTITION BY tf.ticket_no ORDER BY f.scheduled_departure);


-- CASE XXVIII: Which flights had the longest delays?

SELECT f.flight_no, f.scheduled_departure, f.actual_departure,
(f.actual_departure - f.scheduled_departure) AS delay
FROM flights f
WHERE f.actual_departure IS NOT NULL
ORDER BY f.actual_departure - f.scheduled_departure DESC;


-- CASE XXIX: How many seats remained free on the flight PG0404 
-- in the day before the last in the airlines database?

SELECT COUNT(*) AS free_seats
FROM flights f
JOIN seats s
ON s.aircraft_code = f.aircraft_code
WHERE f.flight_no = 'PG0404'
AND f.scheduled_departure::date = public.now()::date - INTERVAL '1day'
AND NOT EXISTS (SELECT NULL FROM boarding_passes bp WHERE bp.flight_id = f.flight_id AND bp.seat_no = s.seat_no);























