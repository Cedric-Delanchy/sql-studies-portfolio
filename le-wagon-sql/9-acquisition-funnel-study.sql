/*
Objective: analyze a B2B acquisition funnel with SQL. 

Table :
---
cc_funnel:

- company: Company name and unique identifier of the prospect. It would have been better to use an id rather than a name.
- sector: the company’s sector of activity
- date_lead: the date the prospect entered the acquisition funnel
- date_opportunity: date of the B2B customer transitionning from “lead” to “opportunity” after a demo with the sales person
- date_customer: the date on which the prospect became a client by signing the contract
- date_lost: the date the prospect was lost - not interested or no response to the follow-up/revival email
- priority: the level of importance of the prospect in relation to the size and commercial potential of the company

QUERY: COUNTIF()
*/

-- PK

SELECT company,
  COUNT(*) AS nb_lignes
FROM `course15.cc_funnel`
GROUP BY company
ORDER BY 2 DESC;

-- Add a deal stage column and conversion related columns. Create a new cc_funnel_kpi.

SELECT company,
  sector,
  priority,
  CASE
    WHEN date_lost IS NOT NULL THEN "4 - Lost"
    WHEN date_customer IS NOT NULL THEN "3 - Customer"
    WHEN date_opportunity IS NOT NULL THEN "2 - Opportunity"
    WHEN date_lead IS NOT NULL THEN "1 - Lead"
    ELSE null
  END AS deal_stage,
  date_lead,
  date_opportunity,
  date_customer,
  date_lost,
  IF (date_customer IS NOT NULL, 1, 0) AS lead_to_customers,
  DATE_DIFF (date_customer,date_lead, DAY) AS time_to_cutomers,
  IF (date_opportunity IS NOT NULL, 1, 0) AS lead_to_opportunity,
  DATE_DIFF (date_opportunity,date_lead, DAY) AS time_to_opportunity,
  IF (date_opportunity IS NOT NULL AND date_customer IS NOT NULL, 1, 0) AS lead_opportunity_to_customers,
  DATE_DIFF(date_customer,date_opportunity, DAY) AS time_opportunity_to_customer
FROM `course15.cc_funnel`
WHERE company IS NOT NULL

-- Create a lead stage table

| deal_stage      | nbr_of_lead |
|-----------------|-------------|
| 1 - Lead        | 79          |
| 2 - Opportunity | 33          |
| 3 - Customer    | 23          |
| 4 - Lost        | 53          |

SELECT deal_stage,
  COUNT(*) AS nbr_of_lead
FROM `course15.cc_funnel_kpi`
WHERE deal_stage IS NOT NULL
GROUP BY deal_stage
ORDER BY deal_stage

-- By priorities

| priority | lead | opportunity | customer | lost |
|----------|------|-------------|----------|------|
| High     | 31   | 12          | 15       | 33   |
| Low      | 23   | 10          | 3        | 11   |
| Medium   | 25   | 11          | 5        | 9    |

SELECT priority,
  COUNTIF(deal_stage = "1 - Lead") AS lead,
  COUNTIF(deal_stage = "2 - Opportunity") AS opportunity,
  COUNTIF(deal_stage = "3 - Customer") AS customer,
  COUNTIF(deal_stage = "4 - Lost") AS lost
FROM `course15.cc_funnel_kpi`
WHERE priority IS NOT NULL
GROUP BY priority
ORDER BY priority

---

| deal_stage      | priority | nb_prospects |
|-----------------|----------|--------------|
| 1 - Lead        | Low      | 23           |
| 1 - Lead        | High     | 31           |
| 1 - Lead        | Medium   | 25           |
| 2 - Opportunity | Low      | 10           |
| 2 - Opportunity | High     | 12           |
| 2 - Opportunity | Medium   | 11           |
| 3 - Customer    | Low      | 3            |
| 3 - Customer    | High     | 15           |
| 3 - Customer    | Medium   | 5            |
| 4 - Lost        | Low      | 11           |
| 4 - Lost        | High     | 33           |
| 4 - Lost        | Medium   | 9            |

SELECT deal_stage,
  priority,
  COUNT(*) AS nb_prospects
FROM `course15.cc_funnel_kpi`
WHERE deal_stage IS NOT NULL
GROUP BY deal_stage, priority
ORDER BY deal_stage

-- Let's proceed to calculate some conversion rates and lead times

| nb_conversion | lead2customer_cr | avg_lead2customer_time | lead2opportunity_cr | avg_lead2opportunity_time | opportunity2customer_cr | avg_lead2customer_time_1 |
|---------------|------------------|------------------------|---------------------|---------------------------|-------------------------|--------------------------|
| 23            | 12.23            | 19.0                   | 40.96               | 12.0                      | 12.23                   | 8.0                      |

SELECT 
  SUM(lead_to_customer) AS nb_conversion,
  ROUND(AVG(lead_to_customer)*100,2) AS lead2customer_cr,
  ROUND(AVG(time_to_customer)) AS avg_lead2customer_time,
  ROUND(AVG(lead_to_opportunity)*100,2) AS lead2opportunity_cr,
  ROUND(AVG(time_to_opportunity)) AS avg_lead2opportunity_time,
  ROUND(AVG(lead_opportunity_to_customer)*100,2) AS opportunity2customer_cr,
  ROUND(AVG(time_opportunity_to_customer)) AS avg_lead2customer_time
FROM `course15.cc_funnel_kpi`

-- By Priority

| priority | nb_conversion | lead2customer_cr | avg_lead2customer_time | lead2opportunity_cr | avg_lead2opportunity_time | opportunity2customer_cr | avg_lead2customer_time_1 |
|----------|---------------|------------------|------------------------|---------------------|---------------------------|-------------------------|--------------------------|
| High     | 15            | 16.48            | 21.0                   | 49.45               | 12.0                      | 16.48                   | 8.0                      |
| Low      | 3             | 6.38             | 10.0                   | 31.91               | 13.0                      | 6.38                    | 5.0                      |
| Medium   | 5             | 10.0             | 17.0                   | 34.0                | 11.0                      | 10.0                    | 9.0                      |

SELECT priority,
  SUM(lead_to_customer) AS nb_conversion,
  ROUND(AVG(lead_to_customer)*100,2) AS lead2customer_cr,
  ROUND(AVG(time_to_customer)) AS avg_lead2customer_time,
  ROUND(AVG(lead_to_opportunity)*100,2) AS lead2opportunity_cr,
  ROUND(AVG(time_to_opportunity)) AS avg_lead2opportunity_time,
  ROUND(AVG(lead_opportunity_to_customer)*100,2) AS opportunity2customer_cr,
  ROUND(AVG(time_opportunity_to_customer)) AS avg_lead2customer_time
FROM `course15.cc_funnel_kpi`
GROUP BY priority
ORDER BY priority

-- By Month and priority

| month_lead | priority | nb_conversion | lead2customer_cr | avg_lead2customer_time | lead2opportunity_cr | avg_lead2opportunity_time | opportunity2customer_cr | avg_lead2customer_time_1 |
|------------|----------|---------------|------------------|------------------------|---------------------|---------------------------|-------------------------|--------------------------|
| 5          | High     | 3             | 25.0             | 16.0                   | 83.33               | 13.0                      | 25.0                    | 9.0                      |
| 5          | Low      | 0             | 0.0              |                        | 0.0                 |                           | 0.0                     |                          |
| 5          | Medium   | 0             | 0.0              |                        | 50.0                | 0.0                       | 0.0                     |                          |
| 6          | High     | 3             | 20.0             | 19.0                   | 80.0                | 11.0                      | 20.0                    | 7.0                      |
| 6          | Low      | 1             | 33.33            | 14.0                   | 33.33               | 9.0                       | 33.33                   | 5.0                      |
| 6          | Medium   | 0             | 0.0              |                        | 50.0                | 14.0                      | 0.0                     |                          |
| 7          | High     | 5             | 15.15            | 25.0                   | 30.3                | 12.0                      | 15.15                   | 9.0                      |
| 7          | Low      | 2             | 10.0             | 9.0                    | 25.0                | 10.0                      | 10.0                    | 5.0                      |
| 7          | Medium   | 2             | 8.0              | 11.0                   | 24.0                | 10.0                      | 8.0                     | 6.0                      |
| 8          | High     | 4             | 12.9             | 22.0                   | 41.94               | 14.0                      | 12.9                    | 8.0                      |
| 8          | Low      | 0             | 0.0              |                        | 39.13               | 15.0                      | 0.0                     |                          |
| 8          | Medium   | 3             | 15.79            | 22.0                   | 42.11               | 13.0                      | 15.79                   | 11.0                     |
  
SELECT
  EXTRACT(MONTH FROM date_lead) AS month_lead,
  priority,
  SUM(lead_to_customer) AS nb_conversion,
  ROUND(AVG(lead_to_customer)*100,2) AS lead2customer_cr,
  ROUND(AVG(time_to_customer)) AS avg_lead2customer_time,
  ROUND(AVG(lead_to_opportunity)*100,2) AS lead2opportunity_cr,
  ROUND(AVG(time_to_opportunity)) AS avg_lead2opportunity_time,
  ROUND(AVG(lead_opportunity_to_customer)*100,2) AS opportunity2customer_cr,
  ROUND(AVG(time_opportunity_to_customer)) AS avg_lead2customer_time
FROM `course15.cc_funnel_kpi`
GROUP BY month_lead,priority
ORDER BY month_lead,priority




