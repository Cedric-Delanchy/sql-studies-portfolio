/* Covers: CAST, 
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

