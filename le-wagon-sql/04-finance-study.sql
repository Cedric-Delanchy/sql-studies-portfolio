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

/*
Objectives: Practice JOINS and create a financial tracker

3 tables : Product, Sales, Ship

Schemas
---

**Product**
Primary key - products_id
Foreign_key - product_id in gwz_sales

**Sales**
Primary key - orders_id, products_id
Foreign_keys - orders_id in gwz_ship and product_id in gwz_product

**Ship**
Primary key - orders_id
Foreign_key - orders_id in gwz_sales

QUERY : Joins, Aggregations

*/

-- Join Sales & Product tables and create a gwz_sales_margin table. Add a purchase_cost and margin columns.

SELECT
  s.date_date,
  ### Key ###
  s.orders_id,
  s.products_id,
  ###########
  s.qty,
  s.turnover,
  p.purchase_price,
  ROUND(s.qty*p.purchase_price,2) AS purchase_cost,
  ROUND(s.turnover - (s.qty*p.purchase_price),2) AS margin
FROM `course16.gwz_sales` AS s
LEFT JOIN `course16.gwz_product` AS p 
  ON s.products_id = p.products_id
  
-- Test the PK of the gwz_sales_margin table

SELECT orders_id,
  products_id,
  COUNT(*) AS nb
FROM `course16.gwz_sales_margin`
GROUP BY orders_id, products_id
HAVING nb >= 2
ORDER BY nb DESC

-- Create a gwz_orders table aggregating gwz_sales_margin values

SELECT date_date,
  orders_id,
  SUM(qty) AS qty,
  ROUND(SUM(turnover),2) AS turnover,
  ROUND(SUM(purchase_cost),2) AS purchase_cost,
  SUM(margin) AS margin
FROM `course16.gwz_sales_margin`
GROUP BY date_date, orders_id
ORDER BY date_date

-- Create a gwz_orders_operational table joining gwz_orders and gwz_sales

SELECT o.date_date,
  ### PK ###
  o.orders_id,
  ##########
  o.qty,
  o.turnover,
  o.purchase_cost,
  o.margin,
  s.shipping_fee,
  s.log_cost,
  s.ship_cost,
FROM `course16.gwz_orders` AS o
LEFT JOIN `course16.gwz_ship` AS s
  ON o.orders_id = s.orders_id
ORDER BY date_date

-- Add operational_margin column

SELECT *,
  ROUND(margin + shipping_fee - (log_cost + ship_cost),2) AS operational_margin
FROM `course16.gwz_orders_operational`
ORDER BY date_date

-- Create a financial table gwz_finance_day aggregating gwz_orders_operational values per day

SELECT date_date,
  COUNT(orders_id) AS nb_transactions,
  ROUND(AVG(turnover),2) AS avg_turnover,
  ROUND(SUM(qty),2) AS qty,
  ROUND(SUM(turnover),2) AS turnover,
  ROUND(SUM (purchase_cost),2) AS purchase_cost,
  ROUND(SUM (margin),2) AS margin,
  ROUND(SUM (shipping_fee),2) AS shipping_fee,
  ROUND(SUM (log_cost),2) AS log_cost,
  ROUND(SUM (ship_cost),2) AS ship_cost,
  ROUND(SUM (operational_margin),2) AS operational_margin
FROM `course16.gwz_orders_operational`
GROUP BY date_date
ORDER BY date_date

