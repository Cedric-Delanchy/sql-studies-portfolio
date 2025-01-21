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

-- Join Sales & Product tables and create a gwz_sales_margin table

SELECT date_date,
  ### PK ###
  s.orders_id,
  p.products_id,
  ##########
  s.turnover,
  s.qty,
  p.purchase_price
FROM `course16.gwz_sales` as s
LEFT JOIN `course16.gwz_product` as p
  ON s.products_id = p.products_id

-- Test the PK of the gwz_sales_margin table

SELECT orders_id,
  products_id,
  COUNT(*) AS nb
FROM `course16.gwz_sales_margin`
GROUP BY orders_id, products_id
HAVING nb >= 2
ORDER BY nb DESC

-- Update gwz_sales_margin with a purchase_cost and margin columns

SELECT date_date,
  orders_id,
  products_id,
  turnover,
  qty,
  purchase_price,
  ROUND(qty * purchase_price,2) AS purchase_cost,
  ROUND(turnover - (qty * purchase_price),2) AS margin
FROM `course16.gwz_sales_margin`
ORDER BY date_date;











