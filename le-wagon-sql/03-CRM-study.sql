-- I need to use a CRM data table to provide insights to a CRM team.

/* 
Table has 6 columns and 136 rows:

- journey_id: campaign ID
- journey_name: campaign's name
- sent_nb
- opening_nb
- click_nb
- turnover

QUERIES: CALCULATION, ROUND, SAFE DIVIDE, LIKE/NOT LIKE, WILDCARDS, CAST, CONCAT, SUBSTR

*/

-- First exploration shows a lot of null values. I start by identifying if the ID is the Primary Key

SELECT journey_id,
      ,COUNT(*) AS nb_lignes
FROM `table`
GROUP BY journey_id
ORDER BY 2 DESC;

-- Search for the largest email campaign

SELECT journey_id,
  journey_name,
  sent_nb
FROM `course14.gwz_mail`
ORDER BY sent_nb DESC

-- Identify campaigns generating more than 10k openings

SELECT DISTINCT journey_id,
  journey_name,
  sent_nb,
  opening_nb
FROM `course14.gwz_mail`
WHERE opening_nb > 10000 
ORDER BY opening_nb DESC

-- Identify the 10 most clicked campaigns

SELECT DISTINCT journey_id,
  journey_name,
  sent_nb,
  opening_nb,
  click_nb
FROM `course14.gwz_mail`
ORDER BY click_nb DESC
LIMIT 10

-- Check a specific campaign performance

SELECT DISTINCT journey_id,
  journey_name,
  sent_nb,
  opening_nb,
  click_nb
FROM `course14.gwz_mail`
WHERE journey_name LIKE "210707_nl_happyhour%"

-- Select only Belgium campaign filtering on the campaign name

SELECT DISTINCT journey_id,
  journey_name,
  sent_nb,
  opening_nb,
  click_nb
FROM `course14.gwz_mail`
WHERE journey_name LIKE "%nlbe%"
ORDER BY sent_nb DESC

-- Check newsleters from France based on campaign names while naming contains "_nl_" for France and "_nlbe_" for Belgium

SELECT DISTINCT journey_id,
  journey_name,
  sent_nb,
  opening_nb,
  click_nb
FROM `course14.gwz_mail`
WHERE journey_name LIKE "%_nl_%"
  AND journey_name NOT LIKE "%nlbe%"
ORDER BY sent_nb DESC

-- Get the opening rate, click rate, ctr and turnover per mille

SELECT DISTINCT journey_id,
  journey_name,
  sent_nb,
  opening_nb,
  click_nb,
  ROUND((SAFE_DIVIDE(opening_nb, sent_nb)*100),1) AS opening_rate,
  ROUND((SAFE_DIVIDE(click_nb, sent_nb)*100),1) AS click_rate,
  ROUND((click_nb/opening_nb*100),1) AS ctr,
  ROUND((turnover/sent_nb*1000),1) AS turnover_per_mille
FROM `course14.gwz_mail`
WHERE journey_name LIKE "%_nl_%"
  AND journey_name NOT LIKE "%nlbe%"
ORDER BY sent_nb DESC

-- Get a specific email test with 2 versions based on the campaign name

SELECT DISTINCT journey_id,
  journey_name,
  sent_nb,
  opening_nb,
  click_nb,
  ROUND((SAFE_DIVIDE(opening_nb, sent_nb)*100),1) AS opening_rate,
  ROUND((SAFE_DIVIDE(click_nb, sent_nb)*100),1) AS click_rate,
  ROUND((click_nb/opening_nb*100),1) AS ctr,
  ROUND((turnover/sent_nb*1000),1) AS turnover_per_mille
FROM `course14.gwz_mail`
WHERE journey_name LIKE "%_nl_%"
  AND journey_name NOT LIKE "%nlbe%"
  AND journey_name LIKE "%happyhour%"
ORDER BY sent_nb DESC

-- Extraire la date du nom de la campagne pour alimenter une colonne Date
      
SELECT DISTINCT journey_id,
  CAST(CONCAT(20,SUBSTR(journey_name, 1, 2),'-',
    SUBSTR(journey_name, 3, 2),'-',
    SUBSTR(journey_name, 5, 2)) AS DATE) AS date_date,
  journey_name,
  sent_nb,
  opening_nb,
  click_nb,
  ROUND((SAFE_DIVIDE(opening_nb, sent_nb)*100),1) AS opening_rate,
  ROUND((SAFE_DIVIDE(click_nb, sent_nb)*100),1) AS click_rate,
  ROUND((click_nb/opening_nb*100),1) AS ctr,
  ROUND((turnover/sent_nb*1000),1) AS turnover_per_mille
FROM `course14.gwz_mail`
WHERE journey_name LIKE "%_nl_%"
  AND journey_name NOT LIKE "%nlbe"
  AND journey_name NOT LIKE "%COPY%"
  AND journey_name NOT LIKE "2108_nl_marketplace_1"
ORDER BY date_date DESC



