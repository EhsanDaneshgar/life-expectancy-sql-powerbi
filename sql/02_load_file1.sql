/*
Project: Life Expectancy Data Integration (SQL Server + Power BI)
File: 02_load_file1.sql
Author: Ehsan Daneshgar

Purpose
-------
Load the 2023 version of the dataset (File 1) into the main table.

File 1 details (Downloaded in 2023)
-----------------------------------
- Coverage: 1543 to 2021
- Columns in CSV: entities, years, life_expectancy
- Notes:
  - No country code column in this file
  - Column names differ from the SQL schema, so we map them during insert

Workflow used in this project
-----------------------------
1) Import the CSV into dbo.LifeExpectancy_Staging using SSMS Import Wizard.
2) Rename/map columns to match the staging table schema:
   - entities        -> Entity
   - years           -> Year
   - life_expectancy -> Life_Expectancy
   - Code            -> NULL (not available in file 1)
3) Insert all rows from staging into dbo.LifeExpectancy (main table).

Important
---------
This script assumes dbo.LifeExpectancy and dbo.LifeExpectancy_Staging already exist
(see 01_create_tables.sql).
*/

------------------------------------------------------------
-- Step 0: Start clean (optional but recommended for practice)
------------------------------------------------------------
TRUNCATE TABLE dbo.LifeExpectancy_Staging;
GO

/*
Step 1 (manual step in SSMS)
----------------------------
Import File 1 into dbo.LifeExpectancy_Staging.

Recommended SSMS steps:
- Right-click Database > Tasks > Import Data...
- Data source: Flat File Source
- Destination: SQL Server
- Destination table: dbo.LifeExpectancy_Staging

During column mapping, map:
- entities        -> Entity
- years           -> Year
- life_expectancy -> Life_Expectancy

If the wizard creates a new table by accident, cancel and ensure the destination
is dbo.LifeExpectancy_Staging.
*/

------------------------------------------------------------
-- Step 2: Quick validation of staging load (optional)
------------------------------------------------------------
SELECT
    MIN([Year]) AS MinYear,
    MAX([Year]) AS MaxYear,
    COUNT(*)    AS RowCount
FROM dbo.LifeExpectancy_Staging;
GO

------------------------------------------------------------
-- Step 3: Insert File 1 data into main table
-- Note: Code is NULL for File 1
------------------------------------------------------------
INSERT INTO dbo.LifeExpectancy (Entity, Code, Year, Life_Expectancy)
SELECT
    s.Entity,
    NULL AS Code,
    s.Year,
    s.Life_Expectancy
FROM dbo.LifeExpectancy_Staging AS s;
GO

------------------------------------------------------------
-- Step 4: Validate main table after load (optional)
------------------------------------------------------------
SELECT
    MIN([Year]) AS MinYear,
    MAX([Year]) AS MaxYear,
    COUNT(*)    AS RowCount
FROM dbo.LifeExpectancy;
GO

