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

QUERY: 
*/

-- PK

SELECT company,
  COUNT(*) AS nb_lignes
FROM `course15.cc_funnel`
GROUP BY company
ORDER BY 2 DESC;

