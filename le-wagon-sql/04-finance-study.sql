/* We are working on 3 different Finance tables. Goal is to understand the relationship between tables and create a diagram.

- Products: contains the listing of product ids and purchase prices
- Sales: order datas with:
  - Date
  - orders_id
  - products_id
  - turnover
  - qty
- ship: shipping informations with:
  - orders_id
  - shipping_fee
  - log_cost
  - ship_cost

*/

-- I start by identifying each primary keys

SELECT products_id,
  COUNT(*) AS nb_lignes
FROM `course16.gwz_product`
GROUP BY products_id
ORDER BY 2 DESC;

SELECT orders_id,
  COUNT(*) AS nb_lignes
FROM `course16.gwz_ship`
GROUP BY orders_id
ORDER BY 2 DESC;

SELECT orders_id,
  COUNT(*) AS nb_lignes
FROM `course16.gwz_sales`
GROUP BY orders_id
ORDER BY 2 DESC; 

-- order id is not the primary key for SALES as it is duplicated. I check if it could be orders id and products ids associated

SELECT orders_id,
  products_id,
  COUNT(*) AS nb
FROM `course16.gwz_sales`
GROUP BY orders_id,
  products_id
HAVING nb>=2


-- Diagram: https://github.com/Cedric-Delanchy/sql-studies-portfolio/blob/main/le-wagon-sql/4-finance-diagram.png

--------------------------------
-- PART 2
--------------------------------



