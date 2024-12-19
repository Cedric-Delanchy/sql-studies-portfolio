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

-- Let's proceed to calculate some conversion rates



