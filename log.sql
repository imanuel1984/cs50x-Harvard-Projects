-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Find the crime scene report for the duck theft (date + Humphrey Street).
SELECT *
FROM crime_scene_reports
WHERE year = 2024 AND month = 7 AND day = 28
  AND street = 'Humphrey Street';
-- Get interviews from the day of the theft; usually contain key leads (bakery/ATM/calls/flight).
SELECT *
FROM interviews
WHERE year = 2024 AND month = 7 AND day = 28;
-- Check bakery parking lot activity around the theft time (adjust hour/minute range as per interviews).
SELECT *
FROM bakery_security_logs
WHERE year = 2024 AND month = 7 AND day = 28
  AND hour = 10
  AND minute BETWEEN 15 AND 25;
-- Convert suspicious license plates into people (license plates are stored in people.license_plate).
SELECT p.id, p.name, p.license_plate
FROM people p
WHERE p.license_plate IN (
    SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2024 AND month = 7 AND day = 28
      AND hour = 10
      AND minute BETWEEN 15 AND 25
      AND activity = 'exit'
);

-- Look for ATM withdrawals mentioned in interviews (often Leggett Street) on the same day.
SELECT *
FROM atm_transactions
WHERE year = 2024 AND month = 7 AND day = 28
  AND transaction_type = 'withdraw';
-- Narrow withdrawals to the ATM location named in interviews (example: Leggett Street).
SELECT *
FROM atm_transactions
WHERE year = 2024 AND month = 7 AND day = 28
  AND transaction_type = 'withdraw'
  AND atm_location LIKE '%Leggett%';
-- Convert suspicious ATM withdrawals into people via bank accounts.
SELECT DISTINCT p.id, p.name
FROM people p
JOIN bank_accounts b ON b.person_id = p.id
JOIN atm_transactions a ON a.account_number = b.account_number
WHERE a.year = 2024 AND a.month = 7 AND a.day = 28
  AND a.transaction_type = 'withdraw'
  AND a.atm_location LIKE '%Leggett%';
-- Find short phone calls on the day of the theft (duration threshold from interviews).
SELECT *
FROM phone_calls
WHERE year = 2024 AND month = 7 AND day = 28
  AND duration < 60;
-- Intersect candidates with callers on short calls (caller side).
SELECT DISTINCT p.name, p.phone_number
FROM people p
WHERE p.phone_number IN (
    SELECT caller
    FROM phone_calls
    WHERE year = 2024 AND month = 7 AND day = 28
      AND duration < 60
);
-- For the suspicious caller(s), find the receiver(s) (accomplice candidates).
SELECT pc.caller, pc.receiver, pc.duration
FROM phone_calls pc
WHERE pc.year = 2024 AND pc.month = 7 AND pc.day = 28
  AND pc.duration < 60
  AND pc.caller IN (
      SELECT phone_number
      FROM people
      WHERE name IN ('PUT_SUSPECT_NAME_HERE')
  );
-- Find Fiftyville airport id.
SELECT id
FROM airports
WHERE city = 'Fiftyville';
-- Find earliest flight leaving Fiftyville on 2024-07-29.
SELECT *
FROM flights
WHERE year = 2024 AND month = 7 AND day = 29
  AND origin_airport_id = (
      SELECT id FROM airports WHERE city = 'Fiftyville'
  )
ORDER BY hour, minute
LIMIT 1;
-- Get the destination city for that earliest flight.
SELECT a.city
FROM flights f
JOIN airports a ON f.destination_airport_id = a.id
WHERE f.id = (
    SELECT id
    FROM flights
    WHERE year = 2024 AND month = 7 AND day = 29
      AND origin_airport_id = (SELECT id FROM airports WHERE city = 'Fiftyville')
    ORDER BY hour, minute
    LIMIT 1
);
-- List passengers on the earliest flight and map to people.
SELECT p.name, p.passport_number
FROM passengers ps
JOIN people p ON p.passport_number = ps.passport_number
WHERE ps.flight_id = (
    SELECT id
    FROM flights
    WHERE year = 2024 AND month = 7 AND day = 29
      AND origin_airport_id = (SELECT id FROM airports WHERE city = 'Fiftyville')
    ORDER BY hour, minute
    LIMIT 1
);
-- Get the accomplice name from the receiver number of the thief's short call.
SELECT p.name
FROM phone_calls pc
JOIN people p ON p.phone_number = pc.receiver
WHERE pc.year = 2024 AND pc.month = 7 AND pc.day = 28
  AND pc.duration < 60
  AND pc.caller = (
      SELECT phone_number FROM people WHERE name = 'THIEF_NAME_HERE'
  );
-- Find the thief by intersecting bakery exit + Leggett ATM withdrawal + short call + earliest flight passenger.
SELECT DISTINCT p.name
FROM people p
JOIN bakery_security_logs bsl ON bsl.license_plate = p.license_plate
JOIN bank_accounts ba ON ba.person_id = p.id
JOIN atm_transactions atm ON atm.account_number = ba.account_number
JOIN phone_calls pc ON pc.caller = p.phone_number
JOIN passengers ps ON ps.passport_number = p.passport_number
WHERE bsl.year = 2024 AND bsl.month = 7 AND bsl.day = 28
  AND bsl.hour = 10 AND bsl.minute BETWEEN 15 AND 25
  AND bsl.activity = 'exit'
  AND atm.year = 2024 AND atm.month = 7 AND atm.day = 28
  AND atm.transaction_type = 'withdraw'
  AND atm.atm_location LIKE '%Leggett%'
  AND pc.year = 2024 AND pc.month = 7 AND pc.day = 28
  AND pc.duration < 60
  AND ps.flight_id = (
      SELECT id
      FROM flights
      WHERE year = 2024 AND month = 7 AND day = 29
        AND origin_airport_id = (SELECT id FROM airports WHERE city = 'Fiftyville')
      ORDER BY hour, minute
      LIMIT 1
  );
-- Find the accomplice: the person Bruce called (short call on July 28).
SELECT DISTINCT p2.name
FROM phone_calls pc
JOIN people p1 ON p1.phone_number = pc.caller
JOIN people p2 ON p2.phone_number = pc.receiver
WHERE pc.year = 2024
  AND pc.month = 7
  AND pc.day = 28
  AND pc.duration < 60
  AND p1.name = 'Bruce';
