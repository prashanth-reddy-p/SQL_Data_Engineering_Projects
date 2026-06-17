-- duckdb dw_marts.duckdb -c ".read build_marts.sql"

-- step 1: DW - create star schema tables

.read 01_create_tables_dw.sql

-- step 2: DW - load data from csv files into tables
 
.read 02_load_schema_dw.sql

.read 03_create_flat_mart.sql

.read 04_create_skills_mart.sql

.read 05_create_priority_mart.sql

.read 06_update_priority_mart.sql