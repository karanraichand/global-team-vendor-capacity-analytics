-- Vendor SLA performance and service-risk concentration

SELECT
    vendor_id,
    vendor_name,
    vendor_type,
    COUNT(*) AS weeks,
    SUM(request_volume) AS request_volume,
    AVG(actual_avg_hours) AS avg_actual_response_hours,
    AVG(sla_compliance_pct) * 100.0 AS avg_sla_compliance_pct,
    SUM(breach_flag) AS breach_weeks,
    SUM(breach_flag) / NULLIF(COUNT(*),0) * 100.0 AS breach_rate_pct
FROM fact_vendorsla
GROUP BY vendor_id, vendor_name, vendor_type
ORDER BY breach_rate_pct DESC;

SELECT
    vendor_type,
    COUNT(DISTINCT vendor_id) AS vendors,
    SUM(request_volume) AS request_volume,
    AVG(actual_avg_hours) AS avg_actual_response_hours,
    AVG(sla_compliance_pct) * 100.0 AS avg_sla_compliance_pct,
    SUM(breach_flag) / NULLIF(COUNT(*),0) * 100.0 AS breach_rate_pct
FROM fact_vendorsla
GROUP BY vendor_type
ORDER BY breach_rate_pct DESC;

-- High-volume / weak-compliance vendor watchlist
SELECT
    vendor_id,
    vendor_name,
    vendor_type,
    SUM(request_volume) AS request_volume,
    AVG(sla_compliance_pct) * 100.0 AS avg_sla_compliance_pct,
    SUM(breach_flag) / NULLIF(COUNT(*),0) * 100.0 AS breach_rate_pct
FROM fact_vendorsla
GROUP BY vendor_id, vendor_name, vendor_type
HAVING SUM(request_volume) >= 200000
ORDER BY avg_sla_compliance_pct ASC, request_volume DESC;
