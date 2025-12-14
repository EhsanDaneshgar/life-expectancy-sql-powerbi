# life-expectancy-sql-powerbi
SQL Server ETL project demonstrating a staging-table and upsert (update–insert) pattern to integrate overlapping life expectancy datasets, with Power BI used for multi-country time-series visualization.

The project loads an initial dataset downloaded in 2023 and then merges a newer 2025 dataset using controlled update and insert logic. Overlapping (Entity, Year) records are refreshed with updated values, while new years are appended, extending the final dataset coverage to 2023.
