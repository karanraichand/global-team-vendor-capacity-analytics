-- Data-quality and relationship validation

SELECT COUNT(*) AS consultant_rows FROM dim_consultant;
SELECT COUNT(*) AS vertical_rows FROM dim_vertical;
SELECT COUNT(*) AS vendor_rows FROM dim_vendor;
SELECT COUNT(*) AS date_rows FROM dim_date_weekly;
SELECT COUNT(*) AS team_performance_rows FROM fact_teamperformance;
SELECT COUNT(*) AS vendor_sla_rows FROM fact_vendorsla;
SELECT COUNT(*) AS request_event_rows FROM fact_requestcapacityevents;

SELECT consultant_id, COUNT(*) FROM dim_consultant
GROUP BY consultant_id HAVING COUNT(*)>1;

SELECT vertical_id, COUNT(*) FROM dim_vertical
GROUP BY vertical_id HAVING COUNT(*)>1;

SELECT vendor_id, COUNT(*) FROM dim_vendor
GROUP BY vendor_id HAVING COUNT(*)>1;

SELECT request_event_id, COUNT(*) FROM fact_requestcapacityevents
GROUP BY request_event_id HAVING COUNT(*)>1;

SELECT consultant_id, week_start_date, COUNT(*)
FROM fact_teamperformance
GROUP BY consultant_id, week_start_date HAVING COUNT(*)>1;

SELECT vendor_id, week_start_date, COUNT(*)
FROM fact_vendorsla
GROUP BY vendor_id, week_start_date HAVING COUNT(*)>1;

SELECT COUNT(*) AS unmatched_event_consultants
FROM fact_requestcapacityevents e
LEFT JOIN dim_consultant c ON e.consultant_id=c.consultant_id
WHERE c.consultant_id IS NULL;

SELECT COUNT(*) AS unmatched_event_verticals
FROM fact_requestcapacityevents e
LEFT JOIN dim_vertical v ON e.vertical_id=v.vertical_id
WHERE v.vertical_id IS NULL;

SELECT COUNT(*) AS unmatched_event_vendors
FROM fact_requestcapacityevents e
LEFT JOIN dim_vendor v ON e.vendor_id=v.vendor_id
WHERE v.vendor_id IS NULL;

SELECT COUNT(*) AS unmatched_team_consultants
FROM fact_teamperformance t
LEFT JOIN dim_consultant c ON t.consultant_id=c.consultant_id
WHERE c.consultant_id IS NULL;

SELECT COUNT(*) AS unmatched_sla_vendors
FROM fact_vendorsla s
LEFT JOIN dim_vendor v ON s.vendor_id=v.vendor_id
WHERE v.vendor_id IS NULL;
