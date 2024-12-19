/*

Objective: study sales of an e-commerce website

Transactions occured between the 01/03/2021 and 31/08/21.

SCHEMA: 
- date_date: The date of the sales.
- orders_id: The id of the order (transaction) made on the website.
- products_id: The id of the product purchased.
- customers_id: The id of the client who made the transaction.
- category 1/2/3: Different category levels to classify the product from top-level 1 to bottom-level 3.
- promo_name: The name of the promotion if the product has been purchased on promotion.
- code: The name of the code if the order was made with a discount code.
- turnover_before_promo: The turnover before the possible reduction of the promotion.
- turnover: The turnover associated with the product. turnover = product price * quaztity.
- purchase_cost: The total purchase cost of the productz
- qty: the quantity of products purchased.

QUERY: Aggregation

*/

-- PK

SELECT
  orders_id,
  products_id,
  COUNT(*) AS nb
FROM `course15.gwz_sales`
GROUP BY orders_id, products_id
ORDER BY 2 DESC

-- Inspect totals for category_1

SELECT category_1,
  COUNT (DISTINCT (orders_id)) AS nb_orders,
  COUNT (DISTINCT (products_id)) AS nb_products,
  COUNT (DISTINCT (customers_id)) AS nb_customers,
  ROUND(SUM (turnover),2) AS total_turnover,
  ROUND(SUM (purchase_cost),2) AS total_purchase_cost,
  SUM (qty) AS total_qty
FROM `course15.gwz_sales`
GROUP BY category_1
ORDER BY total_turnover DESC

-- List top 3 categories and sub-categories by turnover

| category_1    | category_2                   | category_3                      | total_turnover |
|---------------|------------------------------|---------------------------------|----------------|
| Bébé & Enfant | Couches écologiques jetables | Couches jetables T4, 8-14 kg    | 432430.94      |
| Bébé & Enfant | Alimentation bébé            | Lait infantile                  | 392553.12      |
| Bébé & Enfant | Couches écologiques jetables | Couches jetables T5-6, 11-30 kg | 326637.99      |

  SELECT category_1,
  category_2,
  category_3,
  COUNT (DISTINCT (orders_id)) AS nb_orders,
  COUNT (DISTINCT (products_id)) AS nb_products,
  COUNT (DISTINCT (customers_id)) AS nb_customers,
  ROUND(SUM (turnover),2) AS total_turnover,
  ROUND(SUM (purchase_cost),2) AS total_purchase_cost,
  SUM (qty) AS total_qty
FROM `course15.gwz_sales`
GROUP BY category_1,category_2,category_3
ORDER BY total_turnover DESC
LIMIT 3

-- Investigate ratio orders per customers

SELECT 
  category_2,
  category_3,
  COUNT (DISTINCT (orders_id)) AS nb_orders,
  COUNT (DISTINCT (customers_id)) AS nb_customers,
  (ROUND(COUNT(DISTINCT (orders_id))/COUNT(DISTINCT (customers_id)),2)) AS nb_orders_per_customer,
FROM `course15.gwz_sales`
WHERE category_1 = "Bébé & Enfant"
GROUP BY category_2,category_3
ORDER BY nb_orders_per_customer DESC

-- Create a view with nb of products and average purchase price per sub-categories

SELECT 
  category_2,
  category_3,
  COUNT (DISTINCT (products_id)) AS nb_products,
  ROUND(AVG(purchase_cost),2) AS avg_purchase_price,
FROM `course15.gwz_sales`
WHERE category_1 = "Bébé & Enfant"
GROUP BY category_2,category_3
ORDER BY avg_purchase_price DESC
