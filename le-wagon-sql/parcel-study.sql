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