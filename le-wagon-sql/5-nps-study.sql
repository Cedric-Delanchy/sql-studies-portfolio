/* 
Exploration, cleaning, enrichment and analysis of a NPS score.

QUERIES: COUNT, CASE WHEN, FILTERING, CALCULATION, EXTRACt, CAST, AVERAGE

---
Table: gwz_nps - 9 columns - 6295 rows
Schema: 
- date_date: the date of the review
- global_note: the global score from 1 to 10 given by the client about its overall order experience
- csat_website: customer’s satisfaction with the website experience. Score from 1 to 5
- csat_product: customer’s satisfaction with the product offer and quality. Score from 1 to 5
- csat_price: customer’s satisfaction with the price. Score from 1 to 5
- csat_delivery: customer’s satisfaction with the delivery experience. Score from 1 to 5
- orders_id: the orders_id associated with the review
- transporter: the transporter associated with the order
- sgt: the segment of the client associated with the order
*/

-- Check the PK (orders_id). 

SELECT DISTINCT orders_id
FROM `course14.gwz_nps`

-- Returns only 6294 rows on 6295.

SELECT DISTINCT orders_id,
  COUNT(*) AS nb
FROM `course14.gwz_nps`
GROUP BY orders_id
ORDER BY 2 DESC

-- We have a duplicated row while we should only get one row per order ID. From the team, it is linked to a bug. 

-- First let's copy the table to deduplicate

CREATE TABLE `wagon-portfolio.course14.gwz_nps_deduplicated`
COPY `wagon-portfolio.course14.gwz_nps`;

-- Fixing the duplicate issue by overwritting the deduplicated table with the right values

SELECT DISTINCT *
FROM `course14.gwz_nps`
ORDER BY date_date DESC, orders_id DESC

-----------------------------------------------------------------------------------------------------

-- Creation of a nps column based on the global_note (-1 for detractors, 0 for passive and 1 for promoters) and create a nex table

SELECT date_date,
  orders_id,
  transporter,
  sgt,
  global_note,
  CASE
    WHEN global_note > 8 THEN "1"
    WHEN global_note BETWEEN 7 AND 8 THEN "0"
    WHEN global_note < 7 THEN "-1"
    ELSE null
  END AS nps,
  csat_website,
  csat_product,
  csat_price,
  csat_delivery
FROM `course14.gwz_nps_deduplicated`
ORDER BY date_date DESC

-- calculate the number of not null global_note (6253)

SELECT COUNT(*) AS total_global_note
FROM `course14.gwz_nps_calculated`
WHERE global_note IS NOT null

-- calculate the nbr of promoters

SELECT COUNT(*) AS total_promoters
FROM `course14.gwz_nps_calculated`
WHERE nps = "1"

-- calculate the nbr of detractors (459)

SELECT COUNT(*) AS total_detractors
FROM `course14.gwz_nps_calculated`
WHERE nps = "-1"

-- manually calculate the average nps (65%)

SELECT 
  ROUND((4524 - 459) / 6253 * 100,1) AS average_nps

-----------------------------------------------------------------------------------------------------
-- June vs August comparison
-----------------------------------------------------------------------------------------------------
  
-- Total June (1441)
  
SELECT COUNT(*)
FROM `wcourse14.gwz_nps_calculated`
WHERE global_note IS NOT null
  AND date_date BETWEEN "2021-06-01" AND "2021-06-30"

-- Total promoters June (1061)

ELECT COUNT(*)
FROM `course14.gwz_nps_calculated`
WHERE nps = "1"
  AND date_date BETWEEN "2021-06-01" AND "2021-06-30"

-- Total detractors June (96)

SELECT COUNT(*)
FROM `course14.gwz_nps_calculated`
WHERE nps = "-1"
  AND date_date BETWEEN "2021-06-01" AND "2021-06-30"

-- NPS for June (67%)

SELECT ROUND((1061 -96) / 1441 * 100,1)

-- Total global_note August (1269)

  SELECT COUNT(*)
FROM `wcourse14.gwz_nps_calculated`
WHERE global_note IS NOT null
  AND date_date BETWEEN "2021-08-01" AND "2021-08-31"

-- Total promoters August (902)
  
SELECT COUNT(*)
FROM `course14.gwz_nps_calculated`
WHERE nps = "1"
  AND date_date BETWEEN "2021-08-01" AND "2021-08-31"

-- Total detractors August (104)

SELECT COUNT(*)
FROM `course14.gwz_nps_calculated`
WHERE nps = "-1"
  AND date_date BETWEEN "2021-08-01" AND "2021-08-31"

-- NPS for August (62.9%)

SELECT ROUND((902 - 104) / 1269 * 100,1)

/* We observe a 4 points decrease in NPS between June & August. 
We are being told that this decrease maybe caused by a carrier. 

Going through the same process, filtering on the transporter I get respectively :

- For June: 62.1% of NPS
- For August: 35.1%

Even though volumes are pretty low (87 notes for June & 57 for August) there is a decrease in NPS that we can investigate. */

-- We can isolate customers either detractors or with a low score on delivery who used the faulty carrier and hand it over to the customer team to gather feedbacks

SELECT DISTINCT *
FROM `course14.gwz_nps_calculated`
WHERE date_date BETWEEN "2021-08-01" AND "2021-08-31"
  AND transporter = "Chrono Home"
  AND (nps = "-1" OR csat_delivery <= 3) 
ORDER BY sgt

-- To provide more details, let's create a split per month and per segments of the average NPS

SELECT sgt,
  EXTRACT(month FROM date_date) AS month,
  ROUND(AVG(CAST(nps AS int64))*100,1) as average_nps
FROM `course14.gwz_nps_calculated`
WHERE date_date BETWEEN "2021-06-01" AND "2021-08-31"
GROUP by 1, 2 
ORDER BY 1, 2








