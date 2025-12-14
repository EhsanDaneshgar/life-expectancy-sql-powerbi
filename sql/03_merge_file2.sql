/*
Project: Life Expectancy Data Integration (SQL Server + Power BI)
File: 03_merge_file2.sql
Author: Ehsan Daneshgar

Purpose
-------
Merge the 2025 version of the dataset (File 2) into the main table by:
1) Detecting overlap between File 2 (staging) and the existing main table (File 1 already loaded)
2) Validating whether overlapping (Entity, Year) rows have updated Life_Expectancy values
3) Updating existing rows in the main table using File 2 values (treat File 2 as the newer source)
4) Inserting rows from File 2 that do not exist in the main table

File 2 details (Downloaded in 2025)
-----------------------------------
- Coverage: 1950 to 2023
- Columns in CSV: Entity, Code, Year, Period life expectancy at birth
- Notes:
  - Column names differ from the SQL schema. During import, map:
      Period life expectancy at birth -> Life_Expectancy

Workflow used in this project
-----------------------------
1) Import File 2 into dbo.LifeExpectancy_Staging (SSMS Import Wizard)
2) Run overlap + mismatch checks (optional but recommended)
3) UPDATE existing (Entity, Year) rows in dbo.LifeExpectancy using staging values
4) INSERT missing (Entity, Year) rows from staging into dbo.LifeExpectancy
5) Validate final coverage (expected to extend to 2023)

Assumptions
-----------
- dbo.LifeExpectancy and dbo.LifeExpectancy_Staging already exist (see 01_create_tables.sql)
- File 1 has already been loaded into dbo.LifeExpectancy (see 02_load_file1.sql)
*/

------------------------------------------------------------
-- Step 0: Start clean (optional but recommended for practice)
------------------------------------------------------------
TRUNCATE TABLE dbo.LifeExpectancy_Staging;
GO

/*
Step 1 (manual step in SSMS)
----------------------------
Import File 2 into dbo.LifeExpectancy_Staging.

Recommended SSMS steps:
- Right-click Database > Tasks > Import Data...
- Data source: Flat File Source
- Destination: SQL Server
- Destination table: dbo.LifeExpectancy_Staging

During column mapping, map:
- Entity                           -> Entity
- Code                             -> Code
- Year                             -> Year
- Period life expectancy at birth   -> Life_Expectancy
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
-- Step 3: Overlap check (how many (Entity, Year) exist in both tables)
------------------------------------------------------------
SELECT COUNT(*) AS OverlapRowCount
FROM dbo.LifeExpectancy_Staging AS s
JOIN dbo.LifeExpectancy         AS m
  ON m.Entity = s.Entity
 AND m.Year   = s.Year;
GO

------------------------------------------------------------
-- Step 4: Mismatch check (how many overlapping rows have updated values in File 2)
-- Using ISNULL to compare safely when one side is NULL.
------------------------------------------------------------
SELECT COUNT(*) AS DifferentValueCount
FROM dbo.LifeExpectancy_Staging AS s
JOIN dbo.LifeExpectancy         AS m
  ON m.Entity = s.Entity
 AND m.Year   = s.Year
WHERE ISNULL(m.Life_Expectancy, -9999) <> ISNULL(s.Life_Expectancy, -9999);
GO

------------------------------------------------------------
-- Step 5: Update existing rows in main table using File 2 (newer dataset)
------------------------------------------------------------
UPDATE m
SET m.Life_Expectancy = s.Life_Expectancy,
    m.Code            = COALESCE(s.Code, m.Code)
FROM dbo.LifeExpectancy AS m
JOIN dbo.LifeExpectancy_Staging AS s
  ON m.Entity = s.Entity
 AND m.Year   = s.Year;
GO

------------------------------------------------------------
-- Step 6: Insert new rows from File 2 that do not exist in the main table
------------------------------------------------------------
INSERT INTO dbo.LifeExpectancy (Entity, Code, Year, Life_Expectancy)
SELECT s.Entity, s.Code, s.Year, s.Life_Expectancy
FROM dbo.LifeExpectancy_Staging AS s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.LifeExpectancy AS m
    WHERE m.Entity = s.Entity
      AND m.Year   = s.Year
);
GO

------------------------------------------------------------
-- Step 7: Final validation (expected max year should be 2023)
------------------------------------------------------------
SELECT
    MIN([Year]) AS MinYear,
    MAX([Year]) AS MaxYear,
    COUNT(*)    AS RowCount
FROM dbo.LifeExpectancy;
GO

