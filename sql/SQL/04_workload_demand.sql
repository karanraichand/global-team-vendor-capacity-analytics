-- Request demand and operational workload

SELECT
    request_type,
    priority,
    COUNT(*) AS request_events,
    SUM(handling_time_minutes) AS handling_minutes,
    AVG(handling_time_minutes) AS avg_handling_minutes,
    AVG(response_time_hours) AS avg_response_hours,
    SUM(escalation_flag) AS escalations,
    SUM(sla_breached) AS sla_breaches,
    SUM(sla_breached) / NULLIF(COUNT(*),0) * 100.0 AS sla_breach_rate_pct,
    SUM(revenue_impact) AS revenue_impact
FROM fact_requestcapacityevents
GROUP BY request_type, priority
ORDER BY handling_minutes DESC;

SELECT
    v.vertical_name,
    COUNT(*) AS request_events,
    SUM(e.handling_time_minutes) AS handling_minutes,
    AVG(e.response_time_hours) AS avg_response_hours,
    SUM(e.escalation_flag) / NULLIF(COUNT(*),0) * 100.0 AS escalation_rate_pct,
    SUM(e.sla_breached) / NULLIF(COUNT(*),0) * 100.0 AS sla_breach_rate_pct,
    SUM(e.revenue_impact) AS revenue_impact
FROM fact_requestcapacityevents e
JOIN dim_vertical v ON e.vertical_id=v.vertical_id
GROUP BY v.vertical_name
ORDER BY request_events DESC;

SELECT
    priority,
    COUNT(*) AS request_events,
    AVG(handling_time_minutes) AS avg_handling_minutes,
    AVG(response_time_hours) AS avg_response_hours,
    SUM(sla_breached) / NULLIF(COUNT(*),0) * 100.0 AS sla_breach_rate_pct,
    SUM(revenue_impact) AS revenue_impact
FROM fact_requestcapacityevents
GROUP BY priority
ORDER BY CASE priority WHEN 'Urgent' THEN 1 WHEN 'High' THEN 2 WHEN 'Normal' THEN 3 ELSE 4 END;
