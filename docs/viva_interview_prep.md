# Project 2: Viva / Interview Questions & Model Answers
**Candidate**: Sujal Pandya | Roll ID: AS-2026-92197  
**Arrowstack Technologies Virtual Internship (Batch 2026)**  
**Handbook Alignment**: Section 16 Evaluation Criteria  

---

### Q1: What business or user problem does the project solve, and how did you define success?
**Model Answer**:  
"This project solves operational opacity and customer retention risks resulting from missed Service Level Agreements (SLAs) in enterprise tech support. Organizations often experience SLA breaches without understanding whether the failure stems from staffing shortages, vendor dependencies, or cross-team handoffs.  
I defined success through:
1. **Accurate SLA Modeling**: Measuring compliance strictly against contractual target hours per priority level (P1: 4h, P2: 12h, P3: 48h, P4: 96h).
2. **Root Cause Actionability**: Implementing a quantitative Pareto framework that ranks the primary failure modes.
3. **Data Integrity**: Validating that 100% of resolved tickets have valid timestamps ($resolved\_at \ge created\_at$) and non-negative resolution hours."

### Q2: Which design, technical, analytical or research decision had the biggest impact on the result?
**Model Answer**:  
"Separating completed tickets from in-flight open tickets in the compliance calculation while maintaining an 'In-Flight Breach Warning' indicator. If in-flight tickets were prematurely marked as breached or compliant, overall operational metrics would be mathematically invalid. This architectural boundary ensures defensible reporting for executive audits."

### Q3: How did you validate the quality or correctness of your work?
**Model Answer**:  
"I validated the system using three verification tiers:
1. **SQL Boundary & Logic Checks**: Enforced timestamp chronological sequence, non-negative resolution duration, and priority foreign key constraints.
2. **Pytest Unit Testing**: Executed 6 automated test cases in `test_operations_kpis.py` testing data integrity, formula reconciliation ($Compliant + Breached = TotalResolved$), database view existence, and Excel structure. All 6 passed in 1.80s.
3. **Dual Excel Cross-Verification**: Verified that Excel's `COUNTIFS` and `AVERAGEIFS` dynamic formulas matched the Python pandas calculations to the decimal."

### Q4: What edge cases, limitations or risks did you identify?
**Model Answer**:  
"Key edge cases identified:
* **Weekend and Non-Business Hours**: Tickets logged on Friday evenings in standard business hours tiers vs 24/7 platinum tiers.
* **Escalated Ticket Handoffs**: Capturing resolution times when a ticket is re-assigned across multiple teams (Tier 1 $\rightarrow$ DevOps $\rightarrow$ Engineering).
* **Limitations**: Current dataset models resolution hours as continuous calendar elapsed time rather than filtering by regional business holiday calendars."

### Q5: What would you change if this solution had to support 10x the users/data/workload?
**Model Answer**:  
"To scale from 4,200 tickets to tens of millions:
1. Implement an event-driven Kafka / RabbitMQ streaming architecture that computes running SLA countdowns in memory (e.g. Apache Flink).
2. Transition SQLite to an analytical columnar store (ClickHouse or Amazon Redshift) optimized for time-series aggregation.
3. Configure automated Slack/PagerDuty webhook alerts triggered when in-flight tickets consume 75% of their SLA window."

### Q6: How would you explain the project to a non-technical stakeholder?
**Model Answer**:  
"Think of an emergency hospital triage system: when patients arrive, life-threatening cases must be treated immediately, while routine checkups can wait longer. In our IT business, P1 critical outages must be fixed within 4 hours. This dashboard is our command center: it tells leadership exactly how often we kept our promise, which specialized teams are overloaded, and the main reasons why delays happened so we can fix the root problems."

### Q7: Which part of the project required the most independent problem-solving?
**Model Answer**:  
"Formulating the Pareto root-cause cumulative analysis and correlating it with CSAT degradation. Demonstrating that SLA breaches cause average CSAT to plummet from 4.3 to 2.3 proved the direct commercial ROI of reducing queue latency."
