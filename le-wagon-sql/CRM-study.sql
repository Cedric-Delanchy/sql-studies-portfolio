-- I need to use a mail table to provide insights to a CRM team.

/* Table has 6 columns and 136 rows:

- journey_id: campaign ID
- journey_name: campaign's name
- sent_nb
- opening_nb
- click_nb
- turnover
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


