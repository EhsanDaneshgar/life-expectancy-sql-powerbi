/*
Project: Life Expectancy Data Integration (SQL Server + Power BI)
Author: Ehsan Daneshgar

Purpose
-------
This file documents the database table structures used in the project.

Important clarification for readers
-----------------------------------
The tables were created ONCE using SQL Server Management Studio (SSMS)
Table Designer (UI):

  Database > Tables > Right-click > New > Table...

After creation, the tables were scripted using:
  Script Table as > CREATE To > New Query Editor Window

This SQL file exists for:
- Documentation
- Version control (GitHub)
- Reproducibility

It is NOT a second or alternative method of table creation.

Design notes
------------
1) Primary key selection (Entity, Year):
   - Life expectancy is defined per entity per year.
   - Neither Entity nor Year alone is unique.
   - Together they form a natural key that uniquely identifies a record.
   - This prevents duplicate loads and supports safe merge operations.

2) Entity uses NVARCHAR(200) instead of NVARCHAR(MAX):
   - Entity is part of the primary key and frequently used in joins.
   - NVARCHAR(MAX) is a large-object type and not suitable for indexed keys.
   - 200 characters is a realistic upper bound for country/region names,
     balancing flexibility, performance, and data quality.

3) Staging table has no primary key or constraints:
   - Used only as a temporary landing zone for raw CSV imports.
   - Validation and reconciliation occur during the merge step.
*/

-- =========================================================
-- Main Table: dbo.LifeExpectancy
-- Final integrated dataset
-- One row per (Entity, Year)
-- =========================================================
IF OBJECT_ID('dbo.LifeExpectancy', 'U') IS NOT NULL
    DROP TABLE dbo.LifeExpectancy;
GO

CREATE TABLE dbo.LifeExpectancy
(
    Entity           NVARCHAR(200) NOT NULL,
    Code             CHAR(3)        NULL,
    Year             INT            NOT NULL,
    Life_Expectancy  DECIMAL(5,2)   NULL,

    CONSTRAINT PK_LifeExpectancy
        PRIMARY KEY (Entity, Year)
);
GO

-- =========================================================
-- Staging Table: dbo.LifeExpectancy_Staging
-- Temporary landing table for raw CSV imports
-- =========================================================
IF OBJECT_ID('dbo.LifeExpectancy_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.LifeExpectancy_Staging;
GO

CREATE TABLE dbo.LifeExpectancy_Staging
(
    Entity           NVARCHAR(200) NULL,
    Code             CHAR(3)        NULL,
    Year             INT            NULL,
    Life_Expectancy  DECIMAL(5,2)   NULL
);
GO


