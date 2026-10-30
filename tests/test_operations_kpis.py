"""
==============================================================================
PROJECT 2: OPERATIONS SLA ANALYTICS - AUTOMATED TEST SUITE
Arrowstack Technologies Data Analytics Internship (Batch 2026)
Candidate: Sujal Pandya | Roll ID: AS-2026-92197
==============================================================================
"""

import os
import sqlite3
import pandas as pd
import openpyxl
import pytest

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_PATH = os.path.join(BASE_DIR, "data", "cleaned_tickets_data.csv")
DB_PATH = os.path.join(BASE_DIR, "data", "operations_database.db")
EXCEL_PATH = os.path.join(BASE_DIR, "analysis", "operations_sla_analysis.xlsx")

def test_operations_data_artifacts_exist():
    """Verify that all core project artifacts exist."""
    assert os.path.exists(DATA_PATH), f"Missing data file at {DATA_PATH}"
    assert os.path.exists(DB_PATH), f"Missing database file at {DB_PATH}"
    assert os.path.exists(EXCEL_PATH), f"Missing Excel workbook at {EXCEL_PATH}"

def test_tickets_data_integrity():
    """Verify integrity of ticket attributes, statuses, and priorities."""
    df = pd.read_csv(DATA_PATH)
    assert len(df) >= 3500, f"Expected at least 3,500 records, got {len(df)}"
    
    # Mandatory non-null columns
    for col in ["ticket_id", "created_at", "ticket_status", "priority", "assigned_team", "sla_target_hours"]:
        assert df[col].isnull().sum() == 0, f"Found nulls in mandatory column {col}"
        
    valid_priorities = ["P1 - Critical", "P2 - High", "P3 - Medium", "P4 - Low"]
    assert set(df["priority"].unique()).issubset(set(valid_priorities)), "Unexpected priority level found"
    
    # Target hours validity
    assert (df["sla_target_hours"] > 0).all(), "Found non-positive SLA target hours"

def test_timestamp_and_resolution_validity():
    """Ensure resolved tickets have valid timestamps and resolution hours."""
    df = pd.read_csv(DATA_PATH)
    resolved = df[df["is_resolved"] == 1]
    
    created_dt = pd.to_datetime(resolved["created_at"])
    resolved_dt = pd.to_datetime(resolved["resolved_at"])
    
    # Chronological order
    assert (resolved_dt >= created_dt).all(), "Found ticket where resolved_at is before created_at"
    
    # Resolution hours non-negative
    assert (resolved["actual_resolution_hours"] >= 0).all(), "Found negative resolution hours"

def test_sla_kpi_mathematical_accuracy():
    """Verify SLA compliance %, breach %, and MTTR calculations."""
    df = pd.read_csv(DATA_PATH)
    resolved = df[df["is_resolved"] == 1]
    
    compliant_count = (resolved["sla_status"] == "Compliant").sum()
    breached_count = (resolved["sla_status"] == "Breached").sum()
    total_resolved = len(resolved)
    
    assert compliant_count + breached_count == total_resolved, "Compliant + Breached does not equal total resolved"
    
    compliance_rate = (compliant_count / total_resolved) * 100.0
    breach_rate = (breached_count / total_resolved) * 100.0
    assert abs((compliance_rate + breach_rate) - 100.0) < 0.001, "SLA rate sum does not equal 100%"
    
    actual_mttr = resolved["actual_resolution_hours"].mean()
    assert actual_mttr > 0, "MTTR must be greater than zero"

def test_sqlite_database_tables_and_views():
    """Verify relational database tables and analytical views in SQLite."""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = [r[0] for r in cursor.fetchall()]
    
    for t in ["fact_tickets", "dim_sla_policies", "dim_agents"]:
        assert t in tables, f"Expected table '{t}' in operations database"
        
    cursor.execute("SELECT name FROM sqlite_master WHERE type='view';")
    views = [r[0] for r in cursor.fetchall()]
    assert "v_team_sla_summary" in views, "Expected view 'v_team_sla_summary' in database"
    conn.close()

def test_excel_workbook_sheets():
    """Verify that the generated Excel workbook contains all required worksheets."""
    wb = openpyxl.load_workbook(EXCEL_PATH, data_only=False)
    sheet_names = wb.sheetnames
    
    expected_sheets = [
        "Executive SLA Dashboard", 
        "Team Performance", 
        "Breach Root Cause Analysis", 
        "Cleaned Tickets Data"
    ]
    for s in expected_sheets:
        assert s in sheet_names, f"Missing sheet '{s}' in Excel analysis file"
        
    wb.close()
