-- Vertical-level capacity and profitability gaps

SELECT
    t.vertical_id,
    t.vertical_name,
    COUNT(DISTINCT t.consultant_id) AS consultants,
    AVG(t.capacity_utilization_pct) * 100.0 AS avg_utilization_pct,
    AVG(t.profitability_pct) * 100.0 AS avg_profitability_pct,
    v.target_profitability_pct * 100.0 AS target_profitability_pct,
    SUM(t.requests_handled) AS requests_handled,
    SUM(t.revenue) AS revenue,
    SUM(t.profit) AS profit,
    AVG(t.profitability_pct) * 100.0 - v.target_profitability_pct * 100.0
        AS profitability_gap_to_target_pct
FROM fact_teamperformance t
JOIN dim_vertical v ON t.vertical_id=v.vertical_id
GROUP BY t.vertical_id, t.vertical_name, v.target_profitability_pct
ORDER BY avg_utilization_pct DESC;

-- Verticals combining high utilization with a profitability gap are priority candidates
-- for workflow redesign, staffing mix changes, or vendor intervention.
