# Global Team and Vendor Capacity Control Tower

This SQL and Databricks project examines workforce capacity, operational demand, service risk, profitability, and vendor performance across a global services operation. It brings consultant, vertical, request, and vendor measures into a three-page management dashboard built for weekly operating reviews.

## Business objective

Operational leaders need to know where delivery capacity is under pressure, which requests are creating service failures, and which vendors require intervention. Looking at utilization, profitability, demand, and SLA results separately can hide the points where those risks overlap.

This project supports five practical decisions:

- Identify verticals and consultants approaching capacity constraints
- Compare workload demand with available delivery capacity
- Track SLA breaches, escalations, response time, and revenue exposure
- Assess vendor compliance, request volume, and service dependency
- Prioritize consultant and vendor intervention queues

## Dashboard

The report is built in Databricks Dashboards and contains three focused pages.

| Page | Purpose |
|---|---|
| Global Capacity Control Tower | Summarizes utilization, SLA breaches, revenue impact, priority exposure, vertical risk, and operating exceptions. |
| Workforce Capacity | Compares utilization, profitability, revenue, and consultant performance across business verticals. |
| Vendor Network | Reviews SLA compliance, request volume, response time, weekly movement, and vendors requiring attention. |

[Open the Databricks dashboard](https://dbc-ada626ba-2611.cloud.databricks.com/dashboardsv3/01f1ab51d3b516798606567b7a2354e7/published/pages/27ec13be?o=7474659204199089)

The dashboard is hosted in a private Databricks workspace. The repository contains the complete source data, preparation logic, SQL analysis, metric definitions, and report documentation needed to review or rebuild the project.

## Key results

| Metric | Result |
|---|---:|
| Team revenue | $2.381B |
| Team profit | $242.78M |
| Average capacity utilization | 77.89% |
| Request events | 300,000 |
| Event SLA breach rate | 17.78% |
| Revenue impact | $67.15M |
| Average vendor SLA compliance | 91.35% |
| Vendor breach weeks | 7,656 |

## Business findings

- Overall utilization is 77.89%, which suggests that the main issue is where capacity is constrained rather than a shortage across the whole operation.
- The request layer contains 300,000 events and 53,340 SLA breaches, creating a 17.78% breach rate.
- Revenue impact totals $67.15M, making service performance a commercial issue as well as an operational one.
- Vendor SLA compliance averages 91.35%, but 7,656 vendor-week observations recorded a breach.
- SLA breach rates are similar across priority levels, which points to a broader operating issue rather than a problem limited to urgent work.
- Profitability remains below the project benchmark across every vertical, so utilization should not be used as the only basis for staffing decisions.

## Data model and grain

The project uses three fact tables with different grains. Each is aggregated independently before dashboard measures are compared.

| Table | Grain | Rows | Main use |
|---|---|---:|---|
| Fact_TeamPerformance | One row per consultant per week | 10,500 | Utilization, requests handled, revenue, cost, and profitability |
| Fact_VendorSLA | One row per vendor per week | 12,600 | Request volume, response time, SLA compliance, and breach weeks |
| Fact_RequestCapacityEvents | One row per request event | 300,000 | Demand, priority, handling time, escalations, breaches, and revenue impact |
| Dim_Consultant | One row per consultant | 100 | Consultant name, team, location, and role |
| Dim_Vertical | One row per vertical | 12 | Business vertical reporting |
| Dim_Vendor | One row per vendor | 120 | Vendor name, type, and target SLA |
| Dim_Date_Weekly | One row per reporting week | 105 | Weekly reporting calendar |

The event enrichment script adds readable consultant, vertical, and vendor attributes to the request-event table before it is loaded into Databricks. The original fact tables remain separate, which prevents many-to-many multiplication and protects the totals shown in the report.

## Databricks implementation

The source files were loaded as managed Delta tables in the `workspace.default` schema:

- `fact_team_performance`
- `fact_vendor_sla`
- `fact_request_capacity_events_enriched`

The dashboard uses reusable metric datasets rather than combining the fact tables into one wide query. This keeps utilization, vendor compliance, request counts, and revenue impact aligned to their correct business grain.

## SQL analysis

| Script | Analysis |
|---|---|
| 01_executive_capacity_kpis.sql | Executive workforce, request, and vendor KPIs |
| 02_consultant_capacity.sql | Consultant utilization, productivity, and profitability |
| 03_vertical_capacity.sql | Vertical capacity and financial performance |
| 04_workload_demand.sql | Request demand by type and priority |
| 05_capacity_vs_demand.sql | Consultant capacity compared with demand |
| 06_vendor_sla.sql | Vendor SLA performance and breach rates |
| 07_vendor_dependency.sql | Vendor concentration and dependency |
| 08_weekly_trends.sql | Weekly demand and operating movement |
| 09_operational_risk.sql | Capacity, SLA, escalation, and profitability risk |
| 10_validation.sql | Grain, key, row-count, and metric reconciliation checks |

## Dashboard design

- Charcoal and slate surfaces create a compact operations-control environment.
- Orange highlights the primary measures and category comparisons.
- Red is reserved for material service risk and exceptions.
- KPI cards are arranged vertically to keep the layout different from a standard card strip.
- Detailed queues sit below the summary visuals so managers can move from a signal to a specific consultant or vendor.
- Each report page uses the fact table that owns the measure rather than relying on cross-fact joins.

## Technology

- Databricks Dashboards
- Databricks SQL
- Delta tables
- SQL
- Python
- Data modelling
- Data validation
- Git and GitHub

## Repository structure

```text
Project_04_Global_Team_Vendor_Capacity/
|-- data/                         Source CSV files
|-- databricks/                   Databricks setup and dashboard notes
|-- sql/SQL/                      Analytical SQL scripts
|-- sql/Documentation/            Validated results and business findings
|-- prepare_databricks_model.py   Request-event enrichment script
|-- .gitignore
`-- README.md
```

## Rebuild the project

1. Clone or download the repository.
2. Run `prepare_databricks_model.py` to create the enriched request-event file.
3. Upload the three fact files listed in `databricks/README.md` to Databricks.
4. Create managed Delta tables in the `workspace.default` schema.
5. Use the SQL scripts to validate the loaded data.
6. Recreate the three dashboard pages using the metric definitions and layout notes.

The dataset is synthetic and contains no real consultant, customer, or vendor information.
