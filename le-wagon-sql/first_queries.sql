/* Covers : WHERE, IF, CASE WHEN, SAFE_DIVIDE */

-- after importing a customer table

SELECT id,
  name,
  surname
FROM `course14.gwz_customers`

-- CHecking for Primary key

SELECT 
  DISTINCT id
FROM `course14.gwz_customers`
WHERE id IS NOT NULL

-- Return customers where nbr of orders = 3

SELECT *
FROM `course14.gwz_customers`
WHERE number_of_orders = 3

-- Return customers where nbr of orders >= 3 and creation date on or after 01/09/2022

SELECT *
FROM `course14.gwz_customers`
WHERE 
  number_of_orders >= 3 
  OR creation_date >= '2022-09-01'

-- Get customers where surname ends with s

SELECT *
FROM `course14.gwz_customers`
WHERE surname LIKE '%s'

-- Find customers with name Paul or George

SELECT *
FROM `course14.gwz_customers`
WHERE name IN ('Paul', 'George')

-- Create a column with 1 if orders > 0

SELECT id,
  name,
  surname,
  IF (number_of_orders > 0,1,0) as is_customers
FROM `course14.gwz_customers`

-- Create a segment column based on the number of orders
  
SELECT id,
  name,
  surname,
  number_of_orders,
  CASE
    WHEN number_of_orders = 0 THEN 'New'
    WHEN number_of_orders IN (1,2) THEN 'Occasional'
    WHEN number_of_orders >= 3 THEN 'Frequent'
    ELSE NULL
  END as segment
FROM `course14.gwz_customers`
ORDER BY id

-- Add an average_basket column

SELECT id,
  name,
  surname,
  IF (number_of_orders > 0,1,0) as is_customers,
  number_of_orders,
  total_turnover,
  SAFE_DIVIDE(total_turnover, number_of_orders) as average_basket
FROM `wagon-portfolio.course14.gwz_customers`
ORDER BY number_of_orders DESC
