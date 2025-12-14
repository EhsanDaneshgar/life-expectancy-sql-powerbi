/*
Project: Life Expectancy Data Integration
Author: Ehsan Daneshgar

Purpose:
This script creates the main and staging tables used to integrate
two life expectancy datasets with different schemas and time ranges.

Design notes:
- A staging table is used to load raw CSV data
- A main table enforces one row per (Entity, Year)
- File 2 is treated as the more recent source when overlaps exist
*/

-- ===============================
-- Main Table
-- ===============================
-- Stores the cleaned and integrated life expectancy data
-- One row per country (Entity) per year

CREATE TABLE dbo.LifeExpectancy (
    Entity            NVARCHAR(200) NOT NULL,
    Code              CHAR(3)        NULL,
    Year              INT            NOT NULL,
    Life_Expectancy   DECIMAL(5,2)   NULL,

    CONSTRAINT PK_LifeExpectancy
        PRIMARY KEY (Entity, Year)
);
GO

-- ===============================
-- Staging Table
-- ===============================
-- Temporary landing table for CSV imports
-- Schema matches the cleaned structure, but without constraints

CREATE TABLE dbo.LifeExpectancy_Staging (
    Entity            NVARCHAR(200) NULL,
    Code              CHAR(3)        NULL,
    Year              INT            NULL,
    Life_Expectancy   DECIMAL(5,2)   NULL
);
GO

