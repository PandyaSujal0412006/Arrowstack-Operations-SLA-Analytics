-- ==============================================================================
-- PROJECT 2: OPERATIONS SLA ANALYTICS - DATA QUALITY & INTEGRITY CHECKS
-- Arrowstack Technologies Data Analytics Internship (Batch 2026)
-- Candidate: Sujal Pandya | Roll ID: AS-2026-92197
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- CHECK 1: Primary Key Uniqueness on fact_tickets
-- Expected: 0 duplicate ticket_id records
-- ------------------------------------------------------------------------------
SELECT 
    'Check 1: fact_tickets PK Uniqueness' AS check_name,
    COUNT(*) AS failure_count
FROM (
    SELECT ticket_id 
    FROM fact_tickets 
    GROUP BY ticket_id 
    HAVING COUNT(*) > 1
);

-- ------------------------------------------------------------------------------
-- CHECK 2: Null Checks on Mandatory Columns
-- Expected: 0 records with missing mandatory metadata
-- ------------------------------------------------------------------------------
SELECT 
    'Check 2: Null Checks on Mandatory Fields' AS check_name,
    COUNT(*) AS failure_count
FROM fact_tickets
WHERE ticket_id IS NULL
   OR created_at IS NULL
   OR ticket_status IS NULL
   OR priority IS NULL
   OR assigned_team IS NULL
   OR sla_target_hours IS NULL;

-- ------------------------------------------------------------------------------
-- CHECK 3: Chronological Timestamp Sequence Check
-- Tests: resolved_at must be strictly greater than or equal to created_at
-- Expected: 0 inverted timestamp anomalies
-- ------------------------------------------------------------------------------
SELECT 
    'Check 3: Chronological Timestamp Sequence Check' AS check_name,
    COUNT(*) AS failure_count
FROM fact_tickets
WHERE resolved_at IS NOT NULL 
  AND resolved_at < created_at;

-- ------------------------------------------------------------------------------
-- CHECK 4: Status and Resolution Consistency
-- Tests: Every resolved/closed ticket must have non-null actual_resolution_hours
-- Expected: 0 inconsistent resolution records
-- ------------------------------------------------------------------------------
SELECT 
    'Check 4: Resolution Status Completeness Check' AS check_name,
    COUNT(*) AS failure_count
FROM fact_tickets
WHERE ticket_status IN ('Resolved', 'Closed')
  AND (actual_resolution_hours IS NULL OR resolved_at IS NULL OR actual_resolution_hours < 0);

-- ------------------------------------------------------------------------------
-- CHECK 5: SLA Policy Alignment Check
-- Verifies that sla_target_hours matches the policy defined in dim_sla_policies
-- Expected: 0 misaligned SLA benchmarks
-- ------------------------------------------------------------------------------
SELECT 
    'Check 5: SLA Benchmark Alignment Check' AS check_name,
    COUNT(*) AS failure_count
FROM fact_tickets f
JOIN dim_sla_policies p ON f.priority = p.priority
WHERE ABS(f.sla_target_hours - p.sla_target_hours) > 0.001;

-- ------------------------------------------------------------------------------
-- CHECK 6: CSAT Rating Range Validation
-- Verifies that recorded CSAT scores are integers within [1, 5]
-- Expected: 0 out-of-range satisfaction scores
-- ------------------------------------------------------------------------------
SELECT 
    'Check 6: CSAT Rating Bounds Check' AS check_name,
    COUNT(*) AS failure_count
FROM fact_tickets
WHERE csat_score IS NOT NULL 
  AND (csat_score < 1 OR csat_score > 5);
