-- I need to use a mail table to provide insights to a CRM team.

/* Table has 6 columns and 136 rows:

- journey_id: campaign ID
- journey_name: campaign's name
- sent_nb
- opening_nb
- click_nb
- turnover
*/

-- First exploration shows a lot of null values. I start by identifying a Primary Key

SELECT DISTINCT journey_id,
FROM `course14.gwz_mail`
