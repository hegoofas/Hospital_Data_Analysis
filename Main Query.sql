/*
===============================================================================
Main Query – Hospital Unified Data View
===============================================================================
Purpose:
    - This main query consolidates all key hospital data from multiple tables 
      into one unified dataset that can be used as the foundation for analytical 
      reporting and dashboard creation.

Highlights:
    1. Combines essential entities:
        - Admissions
        - Patients (with City and Demographics)
        - Departments
        - Staff (Attending Physicians)
        - Billing
        - Diagnoses
        - Lab Results
        - Medications (linked to Drugs)
        - Procedures

    2. Provides comprehensive context for each admission:
        - Patient demographic info (name, gender, DOB, city, region)
        - Admission details (dates, department, outcome, staff)
        - Financial metrics (charges, insurance flag, payments)
        - Clinical data (diagnoses, lab tests, prescribed medications, procedures)

    3. Enables downstream analytical reports such as:
        - Patient Insights and Readmission Trends
        - Department Efficiency Reports
        - Staff Performance Evaluation
        - Medication and Procedure Cost Analysis
        - City/Regional Health Analytics

    4. Acts as a single, wide data source for KPIs including:
        - Length of stay
        - Total hospital cost per patient
        - Number of diagnoses, procedures, and lab results per admission
        - Correlations between treatments and outcomes

Structure:
    - Base Table: Admissions (central fact table)
    - Joins:
        * Patients        ? a.Patient_ID = p.Patient_ID
        * Cities          ? p.City_ID = c.City_ID
        * Departments     ? a.Department_ID = d.Department_ID
        * Staff           ? a.Attending_Staff_ID = s.Staff_ID
        * Billing         ? a.Admission_ID = b.Admission_ID
        * Diagnoses       ? a.Admission_ID = diag.Admission_ID
        * Lab_Results     ? a.Admission_ID = l.Admission_ID
        * Medications     ? a.Admission_ID = m.Admission_ID
        * Procedures      ? a.Admission_ID = pro.Admission_ID

Filtring:
    - Were Admit Date Column Is NOT NULL.

Usage:
    - Use this query as a common source (CTE ) for building patient reports,
      department-level analytics, and financial dashboards.
===============================================================================
*/


USE HospitalDB;

IF OBJECT_ID('fact_table', 'V') IS NOT NULL
    DROP VIEW fact_table;
GO
CREATE VIEW fact_table AS

SELECT 
    a.Admission_ID,
    a.Admit_Date,
    a.Discharge_Date,
    a.Length_of_Stay,
    a.Outcome,
    p.Patient_ID,
    p.Patient_Name,
    p.DOB,
    p.Gender,
    c.City_ID,
    c.City_Name,
    c.Region,
    d.Department_ID,
    d.Department_Name,
    s.Staff_ID,
    s.Staff_Name,
    s.Role,
    b.Bill_ID,
    b.Insurance_Flag,
    b.Paid_Amount,
    b.Total_Charge,
    diag.Diag_ID,
    diag.Diagnosis_Description,
    diag.ICD_Code,
    l.Lab_ID,
    l.Result_Unit,
    l.Result_Value,
    l.Test_Date,
    l.Test_Name,
    m.Med_ID,
    m.Dose,
    m.End_Date,
    m.Start_Date,
    m.drug_id,
    m.Drug_Name,
    pro.Proc_ID,
    pro.Procedure_Code,
    pro.Procedure_Description,
    pro.Cost

FROM dbo.Admissions AS a
LEFT JOIN dbo.Patients AS p 
ON a.Patient_ID = p.Patient_ID
LEFT JOIN dbo.Cities AS c
ON p.City_ID = c.City_ID
LEFT JOIN dbo.Departments AS d
ON a.Department_ID = d.Department_ID
LEFT JOIN dbo.Staff AS s
ON a.Attending_Staff_ID = s.Staff_ID
LEFT JOIN dbo.Billing AS b
ON a.Admission_ID = b.Admission_ID
LEFT JOIN dbo.Diagnoses AS diag
ON a.Admission_ID = diag.Admission_ID
LEFT JOIN dbo.Lab_Results AS l
ON a.Admission_ID = l.Admission_ID
LEFT JOIN dbo.Medications AS m
ON a.Admission_ID = m.Admission_ID
LEFT JOIN dbo.Procedures AS pro
ON a.Admission_ID = pro.Admission_ID
WHERE a.Admit_Date IS NOT NULL;


