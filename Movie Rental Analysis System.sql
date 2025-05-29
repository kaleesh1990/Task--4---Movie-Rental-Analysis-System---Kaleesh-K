-- Task 4 : Movie Rental Analysis System

CREATE DATABASE movie_rental;
USE movie_rental;
CREATE TABLE rental_data (
  MOVIE_ID    INT,
  CUSTOMER_ID INT,
  GENRE       VARCHAR(50),
  MOVIE_TITLE VARCHAR(100),
  RENTAL_DATE DATE,
  RETURN_DATE DATE,
  RENTAL_FEE  DECIMAL(6,2)
) 

INSERT INTO rental_data
(MOVIE_ID, CUSTOMER_ID, GENRE, MOVIE_TITLE,
 RENTAL_DATE, RETURN_DATE, RENTAL_FEE) VALUES
  ( 1, 101, 'Action',   'Speed Rush',      '2025-02-10', '2025-02-12', 120.00),
  ( 2, 101, 'Drama',    'Chennai Days',    '2025-02-15', '2025-02-17', 100.00),
  ( 3, 102, 'Comedy',   'Laugh Riot',      '2025-03-01', '2025-03-03',  90.00),
  ( 4, 103, 'Action',   'Bullet Chase',    '2025-03-05', NULL,          150.00),
  ( 5, 104, 'Romance',  'Love in Marina',  '2025-03-10', '2025-03-12', 110.00),
  ( 6, 101, 'Action',   'Night Warrior',   '2025-03-18', '2025-03-20', 130.00),
  ( 7, 102, 'Drama',    'Life Lines',      '2025-04-02', '2025-04-04', 100.00),
  ( 8, 103, 'Action',   'Edge of City',    '2025-04-15', '2025-04-17', 140.00),
  ( 9, 104, 'Drama',    'Silent Whisper',  '2025-04-20', NULL,          100.00),
  (10, 105, 'Comedy',   'Funny Bones',     '2025-05-01', '2025-05-03',  90.00),
  (11, 106, 'Thriller', 'Dark Signal',     '2025-05-05', '2025-05-07', 160.00),
  (12, 101, 'Action',   'Fast Lane',       '2025-05-10', NULL,          150.00);

---- a) Drill Down: Analyze rentals from genre to individual movie level.

SELECT GENRE, MOVIE_TITLE, COUNT(*) AS rentals
FROM   rental_data
GROUP  BY GENRE, MOVIE_TITLE
ORDER  BY GENRE, rentals DESC;

-- b) Roll-Up  : Total rental fee per genre + grand total
SELECT GENRE, SUM(RENTAL_FEE) AS total_fee
FROM   rental_data
GROUP  BY GENRE WITH ROLLUP;

-- c) Cube-like : Fee across genre × month × customer
--    (MySQL lacks full CUBE, so UNION-ALL multiple rollups)
SELECT GENRE,
       DATE_FORMAT(RENTAL_DATE, '%Y-%m') AS month,
       CUSTOMER_ID,
       SUM(RENTAL_FEE)                  AS total_fee
FROM   rental_data
GROUP  BY GENRE, month, CUSTOMER_ID
UNION ALL
SELECT GENRE,
       DATE_FORMAT(RENTAL_DATE, '%Y-%m'),
       NULL,
       SUM(RENTAL_FEE)
FROM   rental_data
GROUP  BY GENRE, DATE_FORMAT(RENTAL_DATE, '%Y-%m')
UNION ALL
SELECT NULL, NULL, CUSTOMER_ID, SUM(RENTAL_FEE)
FROM   rental_data
GROUP  BY CUSTOMER_ID
UNION ALL
SELECT NULL, NULL, NULL, SUM(RENTAL_FEE)
FROM   rental_data;

-- d) Slice : Only 'Action' genre
SELECT *
FROM   rental_data
WHERE  GENRE = 'Action';

-- e) Dice : 'Action' or 'Drama' rentals in last 3 months
SELECT *
FROM   rental_data
WHERE  GENRE IN ('Action', 'Drama')
  AND  RENTAL_DATE >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);




