# Project 2. Revenue Metrics Dashboard

## Description
This project calculates key revenue metrics for a gaming product and presents them in a Tableau Public dashboard.

The purpose of the project is to analyze revenue dynamics, paid users, and the main factors influencing MRR growth and decline.

---

## Tools
- PostgreSQL
- SQL
- Tableau Public

---

## Data Source
Data is stored in the `project` schema of a PostgreSQL database:

- `project.games_payments`
- `project.games_paid_users`

---

## Calculated Metrics
The following metrics are calculated on a monthly basis:

- Monthly Recurring Revenue (MRR)
- Paid Users
- ARPPU
- New Paid Users
- New MRR
- Churned Users
- Churn Rate
- Churned Revenue
- Revenue Churn Rate
- Expansion MRR
- Contraction MRR
- Customer Lifetime (LT)
- Customer Lifetime Value (LTV)

---

## SQL Logic
- Aggregations and window functions (LAG / LEAD) are used
- Identifies:
  - new paid users
  - churned users
  - expansion and contraction of MRR
- The final SQL query creates a dataset for visualization

---

## Tableau Public Dashboard
The dashboard includes:
- MRR dynamics
- number of paid users
- MRR change factors (New / Expansion / Contraction / Churn)
- user and revenue churn metrics

Filters:
- time period
- game
- user language
- user age

🔗 Dashboard link:  
_add after publication_

---

## Repository Structure
```text
├── sql/
│   └── revenue_metrics.sql
├── tableau/
│   └── tableau_public_link.txt
└── README.md
