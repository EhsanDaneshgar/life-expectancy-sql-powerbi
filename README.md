## life-expectancy-sql-powerbi

**End-to-end SQL Server ETL project that starts with two raw CSV source files and produces a single clean, merged life expectancy dataset, with Power BI used for final validation and visualization.**

The project begins by importing two public life expectancy CSV files downloaded at different times from *Our World in Data*. The files differ in schema, column naming, and year coverage, and include overlapping historical records.

The first dataset (downloaded in 2023) is loaded into SQL Server as the initial baseline. The second dataset (downloaded in 2025) is then staged and merged using controlled update–insert logic. For overlapping `(Entity, Year)` records, updated life expectancy values from the newer file replace older values, while new years are appended without creating duplicates.

A staging-table pattern is used throughout to clean column names, standardize data types, validate overlaps, and enforce a natural primary key before loading into the final table. Power BI is connected to the SQL Server database to validate results and visualize multi-country life expectancy trends over time.
