-- Vendor dependency and operational exposure

WITH vendor_volume AS (
    SELECT
        vendor_id,
        SUM(request_volume) AS request_volume
    FROM fact_vendorsla
    GROUP BY vendor_id
),
total AS (
    SELECT SUM(request_volume) AS total_volume FROM vendor_volume
)
SELECT
    v.vendor_id,
    v.vendor_name,
    v.vendor_type,
    v.request_volume,
    v.request_volume / NULLIF(t.total_volume,0) * 100.0 AS request_volume_share_pct
FROM vendor_volume v
CROSS JOIN total t
ORDER BY request_volume_share_pct DESC;

SELECT
    e.vendor_id,
    v.vendor_name,
    v.vendor_type,
    COUNT(*) AS request_events,
    SUM(e.revenue_impact) AS revenue_impact,
    SUM(e.sla_breached) / NULLIF(COUNT(*),0) * 100.0 AS event_sla_breach_rate_pct
FROM fact_requestcapacityevents e
JOIN dim_vendor v ON e.vendor_id=v.vendor_id
GROUP BY e.vendor_id, v.vendor_name, v.vendor_type
ORDER BY revenue_impact DESC;
