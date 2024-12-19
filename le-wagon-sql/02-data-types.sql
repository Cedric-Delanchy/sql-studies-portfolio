/* QUERIES: CAST, 
Provided table :  circle_stock_ok
*/

-- Check the Primary key

SELECT 
  DISTINCT MODEL_ID
FROM `wagon-portfolio.course14.circle_stock`

/* Checking the schema of the circle_stock table, some columns are in a wrong type. 
I used the SAFE_CAST function to avoir an incorrect "-----" value in the price column */

SELECT MODEL_ID, MODEL_TYPE,MODEL_NAME,COLOR, 
  CAST(STOCK AS INT64) as stock,
  CAST(IN_STOCK AS BOOLEAN) as in_stock,
  CAST(DATE_CREATION AS DATE) AS date_creation,
  CAST(STOCK_DAYS AS FLOAT64) AS stock_days,
  SAFE_CAST(PRICE AS FLOAT64) AS price_formated,
FROM `course14.circle_stock_ok`

-- Create a Status column based on the date values

SELECT parcel_id,
  parcel_tracking,
  transporter,
  priority,
  date_purchase,
  date_shipping,
  date_delivery,
  date_cancelled,
  CASE
    WHEN date_cancelled IS NOT NULL THEN "Cancelled"
    WHEN date_shipping IS NULL THEN "In progress"
    WHEN date_delivery IS NULL THEN "In transit"
    WHEN date_delivery IS NOT NULL THEN "Delivered"
    ELSE NULL
  END AS status
FROM `course15.cc_parcel`
