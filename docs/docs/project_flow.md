# Project Data Flow

This document describes the logical flow of data through the project.

## Step 1: Source CSV Files
Two life expectancy datasets were downloaded from Our World in Data:
- File 1 (2023 download): historical coverage up to 2021
- File 2 (2025 download): updated values and extended coverage to 2023

The two files differ in:
- Column naming
- Year coverage
- Presence of country codes
- Historical values for overlapping years

## Step 2: Staging Table
Both CSV files are imported into a staging table (`dbo.LifeExpectancy_Staging`).

The staging table:
- Accepts raw data
- Allows NULL values
- Does not enforce constraints
- Acts as a temporary landing zone

## Step 3: Initial Load
File 1 is loaded first and inserted into the main table (`dbo.LifeExpectancy`) as the baseline dataset.

## Step 4: Merge Updated Data
File 2 is then merged into the main table using update–insert logic:
- Existing `(Entity, Year)` rows are updated with newer values
- New `(Entity, Year)` rows are inserted
- No duplicates are created due to the primary key

## Step 5: Final Dataset
The final table:
- Covers years 1543 to 2023
- Contains one row per entity per year
- Represents the single source of truth for analysis and visualization

