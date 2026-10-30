-- ==============================================================================
-- PROJECT 2: OPERATIONS SLA ANALYTICS - DATABASE SCHEMA
-- Arrowstack Technologies Data Analytics Internship (Batch 2026)
-- Candidate: Sujal Pandya | Roll ID: AS-2026-92197
-- Database Dialect: SQLite / ANSI SQL-compliant
-- ==============================================================================

-- 1. DIMENSION: Service Level Agreement (SLA) Policy Rules
CREATE TABLE IF NOT EXISTS dim_sla_policies (
    priority VARCHAR(32) PRIMARY KEY,
    sla_target_hours NUMERIC(6, 2) NOT NULL CHECK (sla_target_hours > 0),
    target_compliance_pct NUMERIC(5, 2) NOT NULL DEFAULT 95.0
);

-- 2. DIMENSION: Support Agents and Engineering Teams
CREATE TABLE IF NOT EXISTS dim_agents (
    agent_id INTEGER PRIMARY KEY AUTOINCREMENT,
    agent_name VARCHAR(64) NOT NULL UNIQUE,
    team_name VARCHAR(64) NOT NULL
);

-- 3. FACT: Operational Incident & Support Tickets
CREATE TABLE IF NOT EXISTS fact_tickets (
    ticket_id VARCHAR(64) PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    resolved_at TIMESTAMP,
    ticket_status VARCHAR(32) NOT NULL CHECK (ticket_status IN ('Open', 'In Progress', 'Escalated', 'Resolved', 'Closed')),
    priority VARCHAR(32) NOT NULL,
    category VARCHAR(128) NOT NULL,
    assigned_team VARCHAR(64) NOT NULL,
    assigned_agent VARCHAR(64) NOT NULL,
    customer_tier VARCHAR(64) NOT NULL,
    sla_target_hours NUMERIC(6, 2) NOT NULL,
    actual_resolution_hours NUMERIC(8, 2) CHECK (actual_resolution_hours IS NULL OR actual_resolution_hours >= 0),
    sla_status VARCHAR(64) NOT NULL,
    breach_root_cause VARCHAR(128),
    csat_score INTEGER CHECK (csat_score IS NULL OR (csat_score >= 1 AND csat_score <= 5)),
    created_date DATE,
    created_year_month VARCHAR(7),
    is_resolved INTEGER NOT NULL CHECK (is_resolved IN (0, 1)),
    is_breached INTEGER NOT NULL CHECK (is_breached IN (0, 1)),
    FOREIGN KEY (priority) REFERENCES dim_sla_policies(priority)
);

-- Analytical Indexing Strategy
CREATE INDEX IF NOT EXISTS idx_fact_tickets_created ON fact_tickets(created_at);
CREATE INDEX IF NOT EXISTS idx_fact_tickets_team ON fact_tickets(assigned_team);
CREATE INDEX IF NOT EXISTS idx_fact_tickets_priority ON fact_tickets(priority);
CREATE INDEX IF NOT EXISTS idx_fact_tickets_status ON fact_tickets(ticket_status);
CREATE INDEX IF NOT EXISTS idx_fact_tickets_sla ON fact_tickets(sla_status);

-- Analytical View: Team SLA Performance Summary
CREATE VIEW IF NOT EXISTS v_team_sla_summary AS
SELECT 
    assigned_team,
    COUNT(ticket_id) AS total_tickets,
    SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END) AS resolved_tickets,
    SUM(CASE WHEN is_resolved = 0 THEN 1 ELSE 0 END) AS open_tickets,
    SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Compliant' THEN 1 ELSE 0 END) AS compliant_tickets,
    SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Breached' THEN 1 ELSE 0 END) AS breached_tickets,
    ROUND(
        SUM(CASE WHEN is_resolved = 1 AND sla_status = 'Compliant' THEN 1 ELSE 0 END) * 100.0 / 
        NULLIF(SUM(CASE WHEN is_resolved = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS sla_compliance_pct,
    ROUND(AVG(CASE WHEN is_resolved = 1 THEN actual_resolution_hours ELSE NULL END), 2) AS mttr_hours,
    ROUND(AVG(csat_score), 2) AS avg_csat_score
FROM fact_tickets
GROUP BY assigned_team;
