## Client Retention Analytics System
A pure MySQL relational database system designed to predict customer churn and identify upsell opportunities using advanced SQL analytics. This project demonstrates how to build intelligent, predictive features directly within the database layer without external machine learning frameworks.
-- 
📊 Project Overview
This system transforms raw client data (interactions, subscriptions, usage logs) into actionable business intelligence. It calculates a Churn Risk Score for each client and identifies Upsell Opportunities by analyzing patterns in engagement, sentiment, and behavior—all using optimized SQL queries, stored procedures, and views.

Key Features
Churn Prediction: Automated calculation of client churn risk based on activity trends and support ticket sentiment.

Upsell Identification: Detection of highly engaged clients on lower-tier plans who are ideal candidates for upgrades.

SQL-Powered Analytics: All business logic implemented natively in MySQL using Stored Procedures, CTEs, and Window Functions.

Reporting Ready: Pre-built views for easy integration with dashboards (Metabase, Power BI, Tableau).
-- 
🗄️ Database Schema
The system uses a normalized relational schema built in MySQL:

Core Tables
clients: Client demographics and calculated churn risk score.

interactions: Log of all client communications (support, sales, feedback) with sentiment scoring.

subscriptions: Active client subscriptions, renewal dates, and revenue data.

usage_logs: Track client feature usage and engagement frequency.

-- 

🚀 Getting Started
Prerequisites
- MySQL Server 8.0+

- MySQL Workbench (or command-line client)

- Git

Installation:
Clone the Repository: 

```bash
git clone https://github.com/heubert-69/Client-Retention-System.git
cd Client-Retention-System
```

Run Database Setup Scripts (in order):

Execute these SQL scripts in your MySQL client:

```sql
-- 1. Create database and tables
SOURCE 01_schema.sql;

-- 2. Load sample data
SOURCE 02_sample_data.sql;

-- 3. Create stored procedures and views
SOURCE 03_procs_views.sql;
```

Calculate Initial Risk Scores:
```sql
USE client_retention_db;
CALL calculate_churn_risk();
--📈 How to Use
--1. View High-Risk Clients
SELECT * FROM vw_high_risk_clients;
Returns clients with churn risk score ≥ 0.6, showing their current plan and renewal date.

--2. Identify Upsell Opportunities
SELECT * FROM vw_upsell_opportunities;
Shows engaged clients on lower-tier plans who are ideal for upgrade offers.

--3. Manual Risk Calculation
--Execute the stored procedure to update all client risk scores:

CALL calculate_churn_risk();
```
Sample Data Analysis:
The database comes pre-loaded with sample data that demonstrates:

Sample Clients:
Client #4 (CloudTask Inc.) with high churn risk due to negative interactions

Client #2 (Bean There Coffee) with low risk and positive engagement

Usage patterns that affect risk calculations

🔧 Technical Architecture
Database Technology
DBMS: MySQL 8.0+

Key Features Used:

Stored Procedures

Common Table Expressions (CTEs)

Temporary Tables

Views

ENUM and CHECK constraints

Algorithm Overview
The churn risk algorithm calculates scores based on:

Sentiment Analysis (50% weight): Average sentiment of recent interactions

Usage Trends (50% weight): Percentage change in feature usage compared to previous period

```sql
-- Simplified algorithm logic
risk_score = (0.5 * negative_sentiment) + (0.5 * usage_decline
```
