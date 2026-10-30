# Project 2: Data Dictionary & KPI Mathematical Definitions
**Candidate**: Sujal Pandya | Roll ID: AS-2026-92197  
**Arrowstack Technologies Virtual Internship (Batch 2026)**  

---

## 1. Data Dictionary

### Table: `fact_tickets`
| Column Name | Data Type | Constraint | Description |
| :--- | :--- | :--- | :--- |
| `ticket_id` | VARCHAR(64) | PRIMARY KEY | Unique incident identifier (e.g. TCK-202526-00001) |
| `created_at` | TIMESTAMP | NOT NULL | Incident creation timestamp (YYYY-MM-DD HH:MM:SS) |
| `resolved_at` | TIMESTAMP | NULLABLE | Timestamp when ticket was marked Resolved/Closed |
| `ticket_status` | VARCHAR(32) | CHECK IN | Status: 'Open', 'In Progress', 'Escalated', 'Resolved', 'Closed' |
| `priority` | VARCHAR(32) | NOT NULL, FK | Priority: 'P1 - Critical', 'P2 - High', 'P3 - Medium', 'P4 - Low' |
| `category` | VARCHAR(128)| NOT NULL | Incident classification (Cloud Outage, Access, Billing, Bug, Hardware) |
| `assigned_team`| VARCHAR(64) | NOT NULL | Operating unit (Tier 1 Support, DevOps & SRE, etc.) |
| `assigned_agent`| VARCHAR(64)| NOT NULL | Primary assignee handling resolution |
| `customer_tier`| VARCHAR(64) | NOT NULL | Service tier: 'Enterprise Platinum', 'Enterprise Gold', 'Standard Business' |
| `sla_target_hours`| NUMERIC(6,2)| CHECK (> 0) | Contractual target resolution hours according to priority |
| `actual_resolution_hours`| NUMERIC(8,2)| CHECK (>= 0) | Elapsed hours between created_at and resolved_at |
| `sla_status` | VARCHAR(64) | NOT NULL | 'Compliant', 'Breached', or in-flight pending status |
| `breach_root_cause`| VARCHAR(128)| NULLABLE | Primary cause taxonomy for breached tickets |
| `csat_score` | INTEGER | CHECK (1..5) | Post-resolution customer satisfaction rating |
| `is_resolved` | INTEGER | CHECK (0, 1) | Binary resolution indicator (1 if Resolved/Closed, else 0) |
| `is_breached` | INTEGER | CHECK (0, 1) | Binary breach indicator (1 if SLA missed, else 0) |

---

## 2. KPI Formulas & Definitions

### 1. SLA Compliance Rate (%)
$$\text{SLA Compliance Rate \%} = \left(\frac{\sum_{i \in \text{Resolved}} \mathbb{I}(\text{sla\_status}_i = \text{'Compliant'})}{N_{\text{Resolved}}}\right) \times 100$$

### 2. SLA Breach Rate (%)
$$\text{SLA Breach Rate \%} = \left(\frac{\sum_{i \in \text{Resolved}} \mathbb{I}(\text{sla\_status}_i = \text{'Breached'})}{N_{\text{Resolved}}}\right) \times 100 = 100\% - \text{Compliance Rate \%}$$

### 3. Mean Time to Resolve (MTTR in Hours)
$$\text{MTTR} = \frac{\sum_{i \in \text{Resolved}} \text{actual\_resolution\_hours}_i}{N_{\text{Resolved}}}$$

### 4. Open Backlog
$$\text{Open Backlog} = N_{\text{Total Tickets}} - N_{\text{Resolved Tickets}}$$

### 5. Cumulative Breach Share (Pareto)
$$\text{Cumulative Share \%}_k = \left(\frac{\sum_{j=1}^k \text{Breaches}_j}{\sum_{\text{All Causes}} \text{Breaches}}\right) \times 100$$
