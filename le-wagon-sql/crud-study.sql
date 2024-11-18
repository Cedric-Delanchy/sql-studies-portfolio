/* Practice around some basic CRUD operations

QUERY: 
*/

-- Creation of a customer table

CREATE TABLE `course19.gwz_customers`(
  id INT64,
  name STRING,
  surname STRING,
  creation_date DATE,
  number_of_orders INT64,
  total_turnover FLOAT64
)

-- insert values in the customer table

INSERT INTO `course19.gwz_customers`
VALUES
  (1,"Paul","Mochkovitch","2020-05-12",4,246.21),
  (2,"Maris","Dupuis","2021-08-07",1,54.63),
  (3,"George","Smith","2021-09-23",2,186.21),
  (6,"David","Martin","2022-09-02",2,306.99),
  (4,"Samantha","Davis","2022-04-12",3,162.1),
  (5,"Paul","Belmond","2022-08-28",0,0.0)

-- Update some datas for a specific customer

UPDATE `course19.gwz_customers`
SET 
  number_of_orders = 3,
  total_turnover = 278.21
WHERE id = 3

-- Delete a customer

DELETE
FROM `course19.gwz_customers`
WHERE id = 2

--------------------------------------------------------------------------------------------------------

-- Working on a CRM campaigns table, we want to delete belgian campaigns base on the name of the campaign

DELETE
FROM `course19.gwz_mail`
WHERE journey_name LIKE "%nlbe%"

-- Update a campaign name using SET

UPDATE `course19.gwz_mail`
SET journey_name = "210721_nl_hh_midi"
WHERE journey_name = "COPY_OF_210721_nl_hh_midi"

-- Add values to the CRM table

INSERT INTO `wagon-portfolio.course19.gwz_mail` (journey_id,journey_name,sent_nb,opening_nb,click_nb,turnover)
VALUES
(1753,"210826_nl_bb_b",11528,2139,271,0),
(1755,"	210826_nl_dej",71566,15723,1131,0)

-- Add all values from other tables

INSERT INTO `wagon-portfolio.course19.gwz_mail`
  SELECT * FROM `course19.gwz_mail_batch1`

INSERT INTO `wagon-portfolio.course19.gwz_mail`
  SELECT * FROM `course19.gwz_mail_batch2`


