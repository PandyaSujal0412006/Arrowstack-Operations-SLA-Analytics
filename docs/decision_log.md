# Project 2: Decision Log & Architectural Trade-Offs
**Candidate**: Sujal Pandya | Roll ID: AS-2026-92197  
**Arrowstack Technologies Virtual Internship (Batch 2026)**  

---

| Decision ID | Decision Title | Options Evaluated | Chosen Approach | Justification & Impact |
| :--- | :--- | :--- | :--- | :--- |
| **DEC-101** | Open Ticket SLA Handling | Exclude vs Include Elapsed In-Flight Hours | **Segregated Compliance Calculation** | SLA compliance % is strictly evaluated on completed (Resolved/Closed) tickets to prevent artificial skewing, while open backlog is tagged with in-flight breach indicators. |
| **DEC-102** | Time Metric Granularity | Calendar Days vs Precise Decimal Hours | **Decimal Hours (HH.hh)** | ITSM P1/P2 incidents require sub-day resolution (e.g. 4.0h and 12.0h SLA windows). Decimal hours enable precise MTTR tracking across shifts. |
| **DEC-103** | Root Cause Categorization | Free-Text Notes vs Structured Taxonomy | **5-Category Root Cause Taxonomy** | Standardizes incident post-mortems, enabling quantitative Pareto cumulative analysis and actionable operational resource planning. |
| **DEC-104** | Visualization Priority | Static Charts vs Interactive Gauge & Pareto | **Interactive Plotly Suite** | Provides immediate executive context via a 95% threshold gauge chart, team breakdown, and Pareto forensic curve. |
