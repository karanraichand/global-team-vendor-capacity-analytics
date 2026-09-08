-- Project 04: Global Team & Vendor Capacity Analytics
-- Validated against the uploaded dataset.

SELECT
    COUNT(DISTINCT consultant_id) AS consultants,
    COUNT(DISTINCT week_start_date) AS weeks,
    SUM(requests_handled) AS requests_handled,
    SUM(revenue) AS revenue,
    SUM(profit) AS profit,
    SUM(cost) AS cost,
    AVG(capacity_utilization_pct) * 100.0 AS avg_capacity_utilization_pct,
    AVG(profitability_pct) * 100.0 AS avg_profitability_pct
FROM fact_teamperformance;

SELECT
    COUNT(*) AS request_events,
    SUM(handling_time_minutes) AS handling_minutes,
    AVG(response_time_hours) AS avg_response_hours,
    SUM(escalation_flag) AS escalations,
    SUM(sla_breached) AS sla_breaches,
    SUM(sla_breached) / NULLIF(COUNT(*),0) * 100.0 AS event_sla_breach_rate_pct,
    SUM(revenue_impact) AS revenue_impact
FROM fact_requestcapacityevents;

SELECT
    AVG(sla_compliance_pct) * 100.0 AS avg_vendor_sla_compliance_pct,
    SUM(breach_flag) AS vendor_breach_weeks,
    SUM(request_volume) AS vendor_request_volume
FROM fact_vendorsla;
