# Project 04: Global Team and Vendor Capacity Analytics

## Status
**SQL layer complete and validated against the uploaded dataset.**

## Business problem
A global travel/services operation needs to decide where internal consultant capacity is constrained, where workload and service failures are creating commercial risk, and which external vendors require intervention or reallocation.

## Source data
- `Dim_Consultant.csv`: 100 consultants
- `Dim_Vertical.csv`: 12 business verticals
- `Dim_Vendor.csv`: 120 vendors
- `Dim_Date_Weekly.csv`: 105 weekly dates
- `Fact_TeamPerformance.csv`: 10,500 consultant-week records
- `Fact_VendorSLA.csv`: 12,600 vendor-week records
- `Fact_RequestCapacityEvents.csv`: 300,000 request events

## Validated portfolio figures
- Team-performance revenue: **$2.381B**
- Team-performance profit: **$242.78M**
- Average consultant capacity utilization: **77.89%**
- Request events: **300,000**
- Event SLA breach rate: **17.78%**
- Event revenue impact: **$67.15M**
- Average vendor SLA compliance: **91.35%**
- Vendor breach weeks: **7,656**

## Analytical coverage
1. Executive capacity KPIs
2. Consultant productivity and utilization
3. Vertical capacity/profitability gaps
4. Workload demand by request type and priority
5. Consultant capacity versus demand
6. Vendor SLA performance
7. Vendor dependency/concentration
8. Weekly operating trends
9. Operational risk matrix
10. Data-quality validation

## Grain controls
- Team performance is consultant-week grain.
- Vendor SLA is vendor-week grain.
- Request events are event grain.
- Demand and capacity are aggregated separately before consultant-level comparison to avoid many-to-many row multiplication.
