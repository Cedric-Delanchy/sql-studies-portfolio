/* Exploration, cleaning and enrichment of a stock table

2 tables created from two sheets in a Gsheets:
- sheet stock
- sheet sales

circle_stock
-------------
- model_id - the unique identifier of the model
- color - the product color acronym
- size - the size of the product (XS, S, M, L, XL, XXL)
- model_name - the name of the model corresponding to the model_id
- color_name - the name of the color corresponding to the color acronym
- new - if the product has been recently added to the catalog. It might have been recently added to the catalog without having been stocked yet.
- price - the price of the product in €
- stock - the quantity of products available in the warehouse
- forecast_stock - the quantity of products available in the warehouse + the quantity already ordered by the production team which will be delivered to the warehouse soon

circle_sales
-------------
- date_date - the date of the sales
- product_id - the unique identifier of the product. Corresponding to the concatenation of the model_id, the color and the size in stock table
- qty - the quantity of product sold

QUERY: CONCAT, HAVING, REGEXP_CONTAINS, ROUND, IF, AGGREGATIONS
*/

-- Identifying the PK for our circle_sale table

SELECT product_id,
  COUNT(*) AS nb
FROM `course15.circle_sales` 
GROUP BY product_id
HAVING nb >= 2

SELECT date_date,
  COUNT(*) AS nb
FROM `course15.circle_sales` 
GROUP BY date_date
HAVING nb >= 2

-- product_id and date_date are duplicated. Our PK is a combination of date and product id.

SELECT date_date,
  product_id,
  COUNT(*) AS nb
FROM `course15.circle_sales` 
GROUP BY date_date,
  product_id
HAVING nb >= 2
ORDER BY nb DESC

-- For our circle_stock table

SELECT model_id,
  COUNT(*) AS nb
FROM `course15.circle_stock`
GROUP BY model_id
HAVING nb >= 2
ORDER BY nb DESC

-- model_id is not our PK as it is duplicated due to color and size variations. Our PK will be a combination of those 3 values.

SELECT model_id,
  color,
  size,
  COUNT(*) AS NB
FROM `course15.circle_stock`
GROUP BY model_id,
  color,
  size
HAVING nb >=2

-- Let's create a new product_id column and review our colums for better clarity

SELECT CONCAT(t.model_id,"-",t.color,"-",t.size) AS product_id,
  t.model_id AS product_model,
  t.model_name AS product_name,
  t.color AS color_code,
  t.color_name AS product_color,
  t.size AS product_size,
  t.new AS is_new,
  t.price AS product_price,
  t.forecast_stock,
  t.stock AS current_stock
FROM `course15.circle_stock` AS t

-- Let's check if there are NULL values for our product-id column

SELECT CONCAT(t.model_id,"-",t.color,"-",t.size) AS product_id,
  t.model_id AS product_model,
  t.model_name AS product_name,
  t.color AS color_code,
  t.color_name AS product_color,
  t.size AS product_size,
  t.new AS is_new,
  t.price AS product_price,
  t.forecast_stock,
  t.stock AS current_stock
FROM `course15.circle_stock` AS t
WHERE TRUE
  AND CONCAT(t.model_id,"-",t.color,"-",t.size) IS NULL

-- There 6 rows with NULL values due to some products not having any size

SELECT CONCAT(t.model_id,"-",t.color,"-",IFNULL(t.size,"no-size")) AS product_id,
  t.model_id AS product_model,
  t.model_name AS product_name,
  t.color AS color_code,
  t.color_name AS product_color,
  t.size AS product_size,
  t.new AS is_new,
  t.price AS product_price,
  t.forecast_stock,
  t.stock AS current_stock
FROM `course15.circle_stock` AS t
WHERE TRUE
  AND CONCAT(t.model_id,"-",t.color,"-",t.size) IS NULL

-- Now I'll start enriching the stock table. For the sake of practising I will do it with intermediate tables instead of one single query

-- New colum product_name and creation of a table circle_stock_name

SELECT *,
  CONCAT(model_name," ",color_name," ","Size ",IFNULL(size,"no-size")) AS product_name
FROM `course15.circle_stock` AS 

-- New column model_type as categories based on Regex and create a table stock_cat

SELECT *,
  CASE
    WHEN REGEXP_CONTAINS(model_name,"(?i)(t|tee)[- ]?shirt") THEN "Tshirt"
    WHEN REGEXP_CONTAINS(model_name,"(?i)(brass[iïî]?[eéèêë]re|crop[- ]?top)") THEN "Crop-top"
    WHEN REGEXP_CONTAINS(model_name,"(?i)legg?i?n?s?") THEN "Legging"
    WHEN REGEXP_CONTAINS(model_name,"(?i)shorts?") THEN "Short"
    WHEN REGEXP_CONTAINS(model_name,"(?i)(d[eéèêë]bardeur|haut|tank)") THEN "Top"
    ELSE "Accessories"
  END AS model_type
FROM `course15.circle_stock_name`

-- Add product_id column (PK), in_stock and stock_value, and organize the final table circle_stock_kpi

SELECT CONCAT(s.model_id,"-",s.color,"-",IFNULL(s.size,"no-size")) AS product_id,
  s.product_name,
  s.model_id,
  s.model_name,
  s.model_type,
  s.color,
  s.color_name,
  s.size,
  s.new,
  s.forecast_stock,
  s.stock,
  s.price,
  IF(s.stock<=0,0,1) AS in_stock,
  ROUND(s.stock*price,2) AS stock_value
FROM `course15.circle_stock_cat` as s
ORDER BY product_id

------------------------------------------------------------------------------------------

-- We will now use the circle_stock_kpi table to perform some analysis for the purchasing team

/*  Basic investigations by model_types and model_names

Macro view:
- Total nbr of products (468)
- total pdts in stock (402),
- shortage rate (14.1%)
- total stock value (526 487€) 
- total stock (22 474)

By model_type:


*/

SELECT model_type,
  COUNT(product_id) AS nb_products,
  SUM(in_stock) AS nb_products_in_stock,
  ROUND(AVG(1 - in_stock)*100,3) AS shortage_rate,
  SUM(stock_value) AS total_stock_value,
  SUM(stock) AS total_stock
FROM `course15.circle_stock_kpi`
GROUP BY model_type





