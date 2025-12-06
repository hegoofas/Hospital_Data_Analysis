/*
==============================================================
Final Project: Hospital DB Analysis.
==============================================================
*/


-- Step1: Edit the Medications table to add a new column called drug_id

USE HospitalDB;

ALTER TABLE dbo.Medications
ADD drug_id INT;

-- Step2: Modify the data so that each row takes the correct drug_id

UPDATE m
SET m.drug_id = d.drug_id
FROM medications m
JOIN drugs d
    ON LOWER(TRIM(m.drug_name)) = LOWER(TRIM(d.drug_name));

-- Step3: Make sure there are no NULL values

SELECT *
FROM medications
WHERE drug_id IS NULL;

-- Step4: Modify the medication table to make the drug_id column a foreign key. 
ALTER TABLE dbo.Medications
ADD CONSTRAINT medications_drugs_FK
FOREIGN KEY (drug_id) REFERENCES dbo.Drugs(Drug_ID);