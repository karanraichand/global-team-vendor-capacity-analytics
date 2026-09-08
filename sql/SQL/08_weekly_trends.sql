-- Weekly capacity, demand and vendor SLA trends

SELECT
    week_start_date,
    COUNT(DISTINCT consultant_id) AS consultants,
    SUM(requests_handled) AS requests_handled,
    AVG(capacity_utilization_pct) * 100.0 AS avg_utilization_pct,
    AVG(profitability_pct) * 100.0 AS avg_profitability_pct,
    SUM(revenue) AS revenue,
    SUM(profit) AS profit
FROM fact_teamperformance
GROUP BY week_start_date
ORDER BY week_start_date;

SELECT
    week_start_date,
    SUM(request_volume) AS vendor_request_volume,
    AVG(actual_avg_hours) AS avg_vendor_response_hours,
    AVG(sla_compliance_pct) * 100.0 AS avg_vendor_sla_compliance_pct,
    SUM(breach_flag) AS breach_vendor_weeks
FROM fact_vendorsla
GROUP BY week_start_date
ORDER BY week_start_date;
