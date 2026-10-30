-- ==============================================================================
-- PROJECT 2: OPERATIONS SLA ANALYTICS - CORE KPI ANALYTICAL QUERIES
-- Arrowstack Technologies Data Analytics Internship (Batch 2026)
-- Candidate: Sujal Pandya | Roll ID: AS-2026-92197
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. EXECUTIVE OPERATIONS KPI SUMMARY
-- Computes Total Tickets, Resolved vs Open, SLA Compliance %, Breach %, 
-- Mean Time to Resolve (MTTR), and Average CSAT
-- ------------------------------------------------------------------------------
SELECT 
    COUNT(ticket_id) AS total_tickets,
    SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END) AS resolved_tickets,
    SUM(CASE WHEN is_resolved = 0 THEN 1 ELSE 0 END) AS open_tickets,
    SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Compliant' THEN 1 ELSE 0 END) AS compliant_tickets,
    SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Breached' THEN 1 ELSE 0 END) AS breached_tickets,
    ROUND(
        (SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Compliant' THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS sla_compliance_pct,
    ROUND(
        (SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Breached' THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS sla_breach_pct,
    ROUND(AVG(CASE WHEN is_resolved = 1 THEN actual_resolution_hours ELSE NULL END), 2) AS avg_resolution_time_mttr_hours,
    ROUND(AVG(csat_score), 2) AS average_csat_score
FROM fact_tickets;


-- ------------------------------------------------------------------------------
-- 2. PRIORITY-WISE SLA COMPLIANCE & MTTR MATRIX
-- Evaluates performance against contractual service levels across P1 to P4
-- ------------------------------------------------------------------------------
SELECT 
    priority,
    sla_target_hours,
    COUNT(ticket_id) AS total_tickets,
    SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END) AS resolved_count,
    ROUND(AVG(CASE WHEN is_resolved = 1 THEN actual_resolution_hours ELSE NULL END), 2) AS actual_mttr_hours,
    SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Compliant' THEN 1 ELSE 0 END) AS compliant_count,
    SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Breached' THEN 1 ELSE 0 END) AS breached_count,
    ROUND(
        (SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Compliant' THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS sla_compliance_pct,
    ROUND(
        (SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Breached' THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS sla_breach_pct
FROM fact_tickets
GROUP BY priority, sla_target_hours
ORDER BY priority ASC;


-- ------------------------------------------------------------------------------
-- 3. TEAM-WISE PERFORMANCE & QUEUE EFFICIENCY
-- Analysis of support tier throughput, resolution speed, and compliance
-- ------------------------------------------------------------------------------
SELECT 
    assigned_team,
    COUNT(ticket_id) AS total_tickets,
    SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END) AS resolved_tickets,
    SUM(CASE WHEN is_resolved = 0 THEN 1 ELSE 0 END) AS open_tickets,
    ROUND(
        (SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Compliant' THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS sla_compliance_pct,
    ROUND(AVG(CASE WHEN is_resolved = 1 THEN actual_resolution_hours ELSE NULL END), 2) AS mttr_hours,
    ROUND(AVG(csat_score), 2) AS avg_csat
FROM fact_tickets
GROUP BY assigned_team
ORDER BY total_tickets DESC;


-- ------------------------------------------------------------------------------
-- 4. CATEGORY-WISE INCIDENT BREAKDOWN
-- Identifies systemic issue domains, MTTR variations, and customer sentiment
-- ------------------------------------------------------------------------------
WITH total_calc AS (
    SELECT COUNT(*) AS grand_total FROM fact_tickets
)
SELECT 
    t.category,
    COUNT(t.ticket_id) AS ticket_count,
    ROUND((COUNT(t.ticket_id) * 100.0) / c.grand_total, 2) AS volume_share_pct,
    ROUND(AVG(CASE WHEN t.is_resolved = 1 THEN t.actual_resolution_hours ELSE NULL END), 2) AS category_mttr_hours,
    ROUND(
        (SUM(CASE WHEN t.is_resolved = 1 AND t.sla_status = 'Compliant' THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(SUM(CASE WHEN t.is_resolved = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS sla_compliance_pct,
    ROUND(AVG(t.csat_score), 2) AS avg_csat
FROM fact_tickets t
CROSS JOIN total_calc c
GROUP BY t.category, c.grand_total
ORDER BY ticket_count DESC;


-- ------------------------------------------------------------------------------
-- 5. SLA BREACH ROOT-CAUSE PARETO ANALYSIS
-- Ranks drivers of delayed resolutions to prioritize operational remediation
-- ------------------------------------------------------------------------------
WITH breach_counts AS (
    SELECT 
        breach_root_cause,
        COUNT(*) AS breach_count
    FROM fact_tickets
    WHERE is_resolved = 1 AND sla_status = 'Breached'
    GROUP BY breach_root_cause
),
total_breaches AS (
    SELECT SUM(breach_count) AS total_breach_count FROM breach_counts
)
SELECT 
    b.breach_root_cause,
    b.breach_count,
    ROUND((b.breach_count * 100.0) / t.total_breach_count, 2) AS cause_share_pct,
    ROUND(
        SUM(b.breach_count) OVER (ORDER BY b.breach_count DESC) * 100.0 / t.total_breach_count,
        2
    ) AS cumulative_share_pct
FROM breach_counts b
CROSS JOIN total_breaches t
ORDER BY b.breach_count DESC;


-- ------------------------------------------------------------------------------
-- 6. CUSTOMER TIER EXPERIENCE & SERVICE ASSURANCE
-- Compares service delivery metrics across contract SLA tiers
-- ------------------------------------------------------------------------------
SELECT 
    customer_tier,
    COUNT(ticket_id) AS total_tickets,
    ROUND(
        (SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Compliant' THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS sla_compliance_pct,
    ROUND(AVG(CASE WHEN is_resolved = 1 THEN actual_resolution_hours ELSE NULL END), 2) AS mttr_hours,
    ROUND(AVG(csat_score), 2) AS avg_csat
FROM fact_tickets
GROUP BY customer_tier
ORDER BY total_tickets DESC;
