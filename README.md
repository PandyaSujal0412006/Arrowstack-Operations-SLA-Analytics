# ⚙️ Arrowstack Project 2: Operations SLA Analytics

**Intern**: Sujal Pandya | **Roll ID**: AS-2026-92197 | **Offer Ref**: AST/INT/2026/OFFER/92197  
**Program**: Arrowstack Technologies Virtual Internship • Data Analytics Track (Batch 2026)  
**Academic Institution**: CHARUSAT  

---

> ⚠️ **Synthetic Data Notice**: In accordance with the Arrowstack Internship Handbook rules, the operational ticketing records and benchmarks utilized in this project are statistically simulated to demonstrate ITIL incident workflows, SLA governance, and root cause analysis. They do not contain proprietary or confidential records of Arrowstack Technologies.

---

## 📌 Executive Overview
The **Operations SLA Analytics** platform provides real-time IT service management (ITSM) operational visibility into incident resolution speed, SLA contractual compliance, team throughput, and breach root cause concentrations.

### Key Capabilities:
- **Core Operations KPI Cards**: Total Inflow Volume (4,200), Resolved Tickets (4,007), In-Flight Open Backlog (193), SLA Compliance Rate (83.88%), Breach Rate (16.12%), and Mean Time to Resolve (MTTR: 33.1 hours).
- **SLA Compliance Gauge**: Visual comparison of actual service delivery against the enterprise 95.0% contractual target threshold.
- **Support Team Throughput & MTTR Leaderboard**: Comparative analysis across DevOps & SRE, Tier 1 Support, Tier 2 Engineering, FinOps & Billing, and Security & SecOps.
- **Priority Severity Matrix**: Target vs actual performance across P1 (4h), P2 (12h), P3 (48h), and P4 (96h) tickets.
- **Forensic Breach Root Cause Pareto Analysis**: Pinpoints the 80/20 concentration of operational delay drivers (staffing shortages, vendor dependencies, and escalation delays).
- **Interactive Multi-Tab Formatted Excel Workbook**: Native formulas (`COUNTIFS`, `AVERAGEIFS`), KPI summary cards, and conditional formatting.
- **Automated Validation Suite**: Pytest test suite with 100% passing results verifying timestamp logic, formula consistency, and database views.

---

## 🗂️ Project Structure
```
02_Project_Operations_SLA_Analytics/
├── app.py                     # Interactive Streamlit Web Application
├── requirements.txt           # Python dependencies
├── README.md                  # Project overview and run guide
├── data/
│   ├── generate_data.py       # Reproducible synthetic ticketing dataset generator
│   ├── raw_tickets_data.csv   # Raw incident records (4,200 rows)
│   ├── cleaned_tickets_data.csv # Validated and transformed analytical dataset
│   └── operations_database.db # SQLite relational database with star schema & views
├── sql/
│   ├── 01_schema.sql          # DDL tables, indexes, constraints, and views
│   ├── 02_kpi_queries.sql     # Analytical queries (Compliance %, Breach %, MTTR, Pareto)
│   └── 03_data_quality_checks.sql # Automated integrity and chronological validation checks
├── analysis/
│   ├── generate_excel.py      # Automated openpyxl workbook generator
│   └── operations_sla_analysis.xlsx # 4-tab formatted Excel analytical model
├── tests/
│   ├── test_operations_kpis.py # Pytest automated test suite (6 passing tests)
│   └── validation_report.txt  # Dated test execution output and evidence log
└── docs/
    ├── requirements_and_scope.md    # Business requirements, stakeholders & scope
    ├── data_dictionary_and_kpi.md   # Field schemas and mathematical definitions
    ├── decision_log.md              # Technical trade-offs and rationale
    └── viva_interview_prep.md       # Handbook Section 16 interview Q&A
```

---

## 🚀 How to Run the Dashboard

### 1. Prerequisites
Ensure Python 3.10+ is installed on your system.
```bash
cd "02_Project_Operations_SLA_Analytics"
python -m pip install -r requirements.txt
```

### 2. Run Data Generation (Optional - Pre-generated files are included)
```bash
python data/generate_data.py
python analysis/generate_excel.py
```

### 3. Run Automated Validation Tests
```bash
pytest tests/test_operations_kpis.py -v
```

### 4. Launch the Interactive Dashboard
```bash
streamlit run app.py --server.port 8502
```
The dashboard will open automatically in your browser at `http://localhost:8502`.

---

## 📊 Key Operational Findings
1. **SLA Gap**: Current SLA compliance is **83.9%**, trailing the **95.0% contractual commitment** by 11.1 percentage points.
2. **Top Root Causes**: "Staffing Deficit / Peak Queue Surge" and "Third-Party Cloud Vendor Dependencies" account for **over 48% of all SLA breaches**.
3. **CSAT Impact**: Breached tickets suffer an average customer satisfaction score of **2.3 / 5.0**, compared to **4.3 / 5.0** for compliant resolutions.
