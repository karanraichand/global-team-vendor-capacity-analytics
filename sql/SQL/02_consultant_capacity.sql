-- Consultant capacity and productivity

SELECT
    consultant_id,
    consultant_name,
    vertical_name,
    COUNT(*) AS weeks,
    AVG(capacity_utilization_pct) * 100.0 AS avg_utilization_pct,
    AVG(profitability_pct) * 100.0 AS avg_profitability_pct,
    SUM(requests_handled) AS requests_handled,
    SUM(revenue) AS revenue,
    SUM(profit) AS profit,
    SUM(cost) AS cost,
    SUM(requests_handled) / NULLIF(COUNT(*),0) AS requests_per_week,
    SUM(profit) / NULLIF(COUNT(*),0) AS profit_per_week,
    CASE
        WHEN AVG(capacity_utilization_pct) >= 0.90 THEN 'Overloaded'
        WHEN AVG(capacity_utilization_pct) >= 0.80 THEN 'Healthy'
        ELSE 'Underutilized'
    END AS capacity_status
FROM fact_teamperformance
GROUP BY consultant_id, consultant_name, vertical_name
ORDER BY avg_utilization_pct DESC;

-- Productivity ranking: prioritize profit contribution, not volume alone.
SELECT
    consultant_id,
    consultant_name,
    vertical_name,
    SUM(profit) AS profit,
    SUM(revenue) AS revenue,
    SUM(requests_handled) AS requests_handled,
    SUM(profit) / NULLIF(SUM(requests_handled),0) AS profit_per_request
FROM fact_teamperformance
GROUP BY consultant_id, consultant_name, vertical_name
ORDER BY profit DESC;
