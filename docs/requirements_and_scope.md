# Project 2: Requirements & Scope Document
**Domain**: IT Service Management (ITSM) & Operations SLA Analytics  
**Intern**: Sujal Pandya | Roll ID: AS-2026-92197 | Reference: AST/INT/2026/OFFER/92197  
**Entity**: Arrowstack Technologies (Batch 2026)  

---

## 1. Real-World Scenario
An enterprise technology managed service provider handles thousands of technical support, cloud infrastructure, and billing incidents across varying service contract tiers. Leadership lacks unified visibility into whether support teams meet contractual Service Level Agreements (SLAs), where queue bottlenecks occur, and which underlying operational root causes drive customer dissatisfaction and financial SLA penalty penalties.

## 2. Business Stakeholder & Use Case
* **Primary Stakeholder**: Head of Global Technical Operations, VP of Customer Experience (CX), and ITIL Incident Managers.
* **Decisions Enabled**:
  1. Dynamic queue re-balancing and shift scheduling during peak morning ticket surges.
  2. Targeted automation of Tier 1 triage handoffs to DevOps/SRE for P1 Critical infrastructure outages.
  3. Continuous vendor SLA monitoring and remediation for cloud hosting dependencies.
* **Measurable Benefit**: Target lifting SLA compliance from **83.9% to >=95.0%**, reducing P1 Critical MTTR by 25%, and raising average customer satisfaction from 3.7 to >=4.5 / 5.0.

## 3. Scope Boundaries
* **In-Scope**:
  * 4,200 incident records spanning January 2025 to October 2026.
  * 4 ITIL priority tiers: P1 - Critical (4h SLA), P2 - High (12h SLA), P3 - Medium (48h SLA), P4 - Low (96h SLA).
  * 5 Operational teams: DevOps & SRE, Tier 1 Support, Tier 2 Engineering, FinOps & Billing, Security & SecOps.
  * SLA compliance gauge, priority matrix, team leaderboard, and breach Pareto charts.
  * Multi-tab Excel workbook with formulas and relational SQLite database.
* **Out-of-Scope**:
  * Direct webhook polling to live Jira Service Management or ServiceNow cloud instances.
  * Real-time VoIP call recording transcript NLP (captured via CSAT and structured root cause tags).

## 4. Acceptance Criteria Checklist
- [x] Executive KPI metric cards (Total Tickets, Resolved, Open Backlog, Compliance %, Breach %, MTTR, CSAT).
- [x] SLA Compliance health gauge with 95% target threshold and status coloring.
- [x] Team-wise volume, compliance rate, and MTTR comparative visualizations.
- [x] Priority matrix comparing contract SLA target hours against realized MTTR.
- [x] Root-cause Pareto analysis highlighting cumulative driver concentrations.
- [x] Fully populated relational SQLite database with analytical views and query console.
- [x] Automated pytest validation suite with 100% passing tests.
