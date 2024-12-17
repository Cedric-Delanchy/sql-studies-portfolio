/*
Objective: query parcel data to perfom analysis

Tables :
---
cc_Parcel:
- parcel_id: the unique identifier of the parcel.
- parcel_tracking: the tracking link given by the carrier/transporter. Certainly not valid anymore.
- transporter: the name of the transporter
- priority: the priority of the parcel. High if it is an important order or an important customer. Low if the importance is very low and medium otherwise.
- date_purchase: the date of the order.
- date_shipping: the date the parcel is shipped from the warehouse. It is given to the carrier/transporter.
- date_delivery: the date of parcel delivery to the customer by the transporter.
- date_cancelled: parcel cancellation date. Due to problems or delays during the preparation of the parcel or, more often, during transport, the parcel may be cancelled.

cc_parcel_product:
- parcel_id: the unique identifier of the parcel. Serves as a link to the parcel table
- model_name: the name of the product model in the parcel
- qty: the quantity of the specific product model in a given parcel

QUERY: 
*/

-- Identify PK cc_parcel

SELECT parcel_id,
  COUNT(*) AS nb
FROM `course15.cc_parcel`
GROUP BY parcel_id
ORDER BY 2 DESC

-- Identify PK cc_parcel_product

SELECT parcel_id,
  model_name,
  COUNT(*) AS nb
FROM `course15.cc_parcel_product`
GROUP BY parcel_id, model_name
ORDER BY 2 DESC

/*
- Format date colums and create a status column based on the date values. 
- Add expedition, transport and delivery times columns based on dates.
- Save the query in a cc_parcel_kpi table.
*/

SELECT parcel_id,
  parcel_tracking,
  transporter,
  priority,
  PARSE_DATE("%B %e, %Y", date_purchase) AS date_purchase,
  PARSE_DATE("%B %e, %Y", date_shipping) AS date_shipping,
  PARSE_DATE("%B %e, %Y", date_delivery) AS date_delivery,
  PARSE_DATE("%B %e, %Y", date_cancelled) AS date_cancelled,
  CASE
    WHEN date_cancelled IS NOT NULL THEN 'Cancelled'
    WHEN date_shipping IS NULL THEN 'In Progress'
    WHEN date_delivery IS NULL THEN 'In Transit'
    WHEN date_delivery IS NOT NULL THEN 'Delivered'
    ELSE NULL
  END AS status,
  DATE_DIFF(PARSE_DATE("%B %e, %Y", date_shipping),PARSE_DATE("%B %e, %Y", date_purchase),DAY) AS expedition_time,
  DATE_DIFF(PARSE_DATE("%B %e, %Y", date_delivery),PARSE_DATE("%B %e, %Y", date_shipping),DAY) AS transport_time,
  DATE_DIFF(PARSE_DATE("%B %e, %Y", date_delivery),PARSE_DATE("%B %e, %Y", date_purchase),DAY) AS delivery_time,
FROM `course15.cc_parcel`

-- Create a Macro KPI table for the team and build on it

SELECT
  COUNT(*) AS parcel_quantities,
  ROUND(AVG(expedition_time),2) AS avg_shipping,
  ROUND(AVG(transport_time),2) AS avg_transport_time,
  ROUND(AVG(delivery_time),2) AS avg_delivery_time
FROM `course15.cc_parcel_kpi`

-- By transporters

SELECT transporter,
  COUNT(*) AS parcel_quantities,
  ROUND(AVG(expedition_time),2) AS avg_shipping,
  ROUND(AVG(transport_time),2) AS avg_transport_time,
  ROUND(AVG(delivery_time),2) AS avg_delivery_time
FROM `course15.cc_parcel_kpi`
GROUP BY transporter

-- By priorities
  
SELECT
  priority,
  COUNT(*) AS nb_parcel,
  ROUND(AVG(expedition_time),2) AS expedition_time,
  ROUND(AVG(transport_time),2) AS transport_time,
  ROUND(AVG(delivery_time),2) AS delivery_time,
  ROUND(SAFE_DIVIDE(AVG(transport_time),AVG(delivery_time)),2) AS ratio_transport_delivery
FROM `course15.cc_parcel_kpi`
GROUP BY priority

-- Create a month_purchase column in our cc_parcel_kpi table

SELECT *,
  EXTRACT(MONTH FROM date_purchase) AS month_purchase
FROM `course15.cc_parcel_kpi`

-- Check the evolution accross months

SELECT month_purchase,
  COUNT(*) AS number_of_parcels,
  ROUND(AVG(expedition_time),2) AS avg_expedition_time,
  ROUND(AVG(transport_time),2) AS avg_transport_time,
  ROUND(AVG(delivery_time),2) AS avg_delivery_time,
FROM `course15.cc_parcel_kpi_new`
GROUP BY month_purchase
ORDER BY month_purchase

