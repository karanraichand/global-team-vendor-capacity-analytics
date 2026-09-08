-- Consultant-level demand versus recorded weekly capacity
-- Demand fact is event grain; team performance is consultant-week grain.
-- They are aggregated separately before joining to avoid row multiplication.

WITH demand AS (
    SELECT
        consultant_id,
        COUNT(*) AS request_events,
        SUM(handling_time_minutes) AS handling_minutes,
        AVG(response_time_hours) AS avg_response_hours,
        SUM(sla_breached) AS sla_breaches
    FROM fact_requestcapacityevents
    GROUP BY consultant_id
),
capacity AS (
    SELECT
        consultant_id,
        MAX(consultant_name) AS consultant_name,
        MAX(vertical_name) AS vertical_name,
        COUNT(*) AS weeks,
        AVG(capacity_utilization_pct) AS avg_utilization,
        SUM(requests_handled) AS requests_handled,
        SUM(profit) AS profit
    FROM fact_teamperformance
    GROUP BY consultant_id
)
SELECT
    c.consultant_id,
    c.consultant_name,
    c.vertical_name,
    c.weeks,
    c.avg_utilization * 100.0 AS avg_utilization_pct,
    c.requests_handled,
    d.request_events,
    d.handling_minutes,
    d.avg_response_hours,
    d.sla_breaches,
    d.request_events / NULLIF(c.requests_handled,0) AS event_to_handled_request_ratio,
    c.profit
FROM capacity c
JOIN demand d ON c.consultant_id=d.consultant_id
ORDER BY avg_utilization_pct DESC, d.request_events DESC;
