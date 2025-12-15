## life-expectancy-sql-powerbi

**End-to-end SQL Server ETL project that starts with two raw CSV source files and produces a single clean, merged life expectancy dataset, with Power BI used for final validation and visualization.**

The project begins by importing two public life expectancy CSV files downloaded at different times from *Our World in Data*. The files differ in schema, column naming, and year coverage, and include overlapping historical records.

The first dataset (downloaded in 2023) is loaded into SQL Server as the initial baseline. The second dataset (downloaded in 2025) is then staged and merged using controlled update–insert logic. For overlapping `(Entity, Year)` records, updated life expectancy values from the newer file replace older values, while new years are appended without creating duplicates.

A staging-table pattern is used throughout to clean column names, standardize data types, validate overlaps, and enforce a natural primary key before loading into the final table. Power BI is connected to the SQL Server database to validate results and visualize multi-country life expectancy trends over time.

## How to Run This Project

1. Create a SQL Server database locally.
2. Run `sql/01_create_tables.sql`.
3. Import `life_expectancy_2023.csv` into `LifeExpectancy_Staging`.
4. Run `sql/02_load_file1.sql`.
5. Import `life_expectancy_2025.csv` into `LifeExpectancy_Staging`.
6. Run `sql/03_merge_file2.sql`.
7. (Optional) Connect Power BI to `dbo.LifeExpectancy`.

### Importing CSV Files into SQL Server

CSV files are imported into SQL Server using the **SQL Server Import and Export Wizard**
via SQL Server Management Studio (SSMS).

For each CSV file, the following steps are used:

1. In SSMS, right-click the target database
2. Select **Tasks → Import Data…**
3. In the Import and Export Wizard, select the CSV file as the source
4. Select **SQL Server** as the destination
5. When prompted for the destination, select the existing table:
   - `dbo.LifeExpectancy_Staging`

6. In the **Column Mappings** step of the wizard, map the source columns
   to the staging table columns as follows:

   **File 1 (2023 dataset):**
   - `entities` → `Entity`
   - `years` → `Year`
   - `life_expectancy` → `Life_Expectancy`
   - `Code` → *(leave NULL; not available in this file)*

   **File 2 (2025 dataset):**
   - `Entity` → `Entity`
   - `Code` → `Code`
   - `Year` → `Year`
   - `Period life expectancy at birth` → `Life_Expectancy`

7. Review data types and confirm that numeric and text fields align
   with the staging table schema.
8. Complete the wizard to load the data into `dbo.LifeExpectancy_Staging`.

Each CSV file is imported separately.  
The staging table is truncated between imports so that each dataset
is processed independently before being merged into the main table.

