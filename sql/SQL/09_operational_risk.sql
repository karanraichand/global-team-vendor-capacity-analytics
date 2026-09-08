-- Operational risk matrix
-- Combines workload, SLA failure and revenue impact at vertical grain.

WITH demand AS (
    SELECT
        vertical_id,
        COUNT(*) AS events,
        SUM(handling_time_minutes) AS handling_minutes,
        SUM(sla_breached) AS sla_breaches,
        SUM(escalation_flag) AS escalations,
        SUM(revenue_impact) AS revenue_impact
    FROM fact_requestcapacityevents
    GROUP BY vertical_id
),
capacity AS (
    SELECT
        vertical_id,
        AVG(capacity_utilization_pct) AS utilization,
        AVG(profitability_pct) AS profitability
    FROM fact_teamperformance
    GROUP BY vertical_id
)
SELECT
    v.vertical_id,
    v.vertical_name,
    d.events,
    d.handling_minutes,
    d.sla_breaches / NULLIF(d.events,0) * 100.0 AS sla_breach_rate_pct,
    d.escalations / NULLIF(d.events,0) * 100.0 AS escalation_rate_pct,
    d.revenue_impact,
    c.utilization * 100.0 AS avg_utilization_pct,
    c.profitability * 100.0 AS avg_profitability_pct,
    v.target_profitability_pct * 100.0 AS target_profitability_pct
FROM dim_vertical v
JOIN demand d ON v.vertical_id=d.vertical_id
JOIN capacity c ON v.vertical_id=c.vertical_id
ORDER BY d.revenue_impact DESC;
