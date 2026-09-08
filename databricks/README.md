# Databricks setup

## Tables

Create the following managed Delta tables in `workspace.default`:

| Table | Source file |
|---|---|
| `fact_team_performance` | `data/Fact_TeamPerformance.csv` |
| `fact_vendor_sla` | `data/Fact_VendorSLA.csv` |
| `fact_request_capacity_events_enriched` | Generated from `data/Fact_RequestCapacityEvents.csv` |

Run the enrichment script before loading the request-event table:

```powershell
python prepare_databricks_model.py
```

The script joins descriptive attributes from the consultant, vertical, and vendor dimensions while preserving one row per request event.

## Dashboard pages

### Global Capacity Control Tower

- Team Utilization
- SLA Breaches
- Revenue Impact
- Risk by Vertical
- Priority Exposure
- Exception Detail

### Workforce Capacity

- Utilization by Vertical
- Revenue by Vertical
- Utilization versus Profitability
- Monthly Profitability Trend
- Top 10 Consultant Queue

### Vendor Network

- SLA Compliance by Vendor Type
- Volume by Vendor Type
- Response Time versus Target
- Weekly SLA Compliance by Type
- Top 10 Vendors: Intervention Queue

## Metric definitions

| Metric | Definition |
|---|---|
| Team Utilization | Average of `capacity_utilization_pct` |
| SLA Breaches | Sum of `sla_breached` |
| Revenue Impact | Sum of `revenue_impact` |
| Vendor SLA Compliance | Average of `sla_compliance_pct` |
| Vendor Breach Weeks | Sum of `breach_flag` |
| Escalations | Sum of `escalation_flag` |

The dashboard does not join the three fact tables. Each page and visual uses the dataset that owns the metric, preserving the consultant-week, vendor-week, and request-event grains.
