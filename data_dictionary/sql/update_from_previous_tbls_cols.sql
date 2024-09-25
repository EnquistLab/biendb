-- ---------------------------------------------------------------------
-- Copies definitions for all tables & columns from previous versions 
-- temp tables of previous versions are created in separate script
-- 'import_provious.sql'
-- ---------------------------------------------------------------------

SET search_path TO :sch;

-- 
-- Table names and comments
-- 

UPDATE data_dictionary_tables a
SET description=b.description
FROM dd_tables_prev b
WHERE a.table_name=b.table_name
AND b.description IS NOT NULL 
AND a.description IS NULL
;

-- 
-- Columns names and definitions
-- 

UPDATE data_dictionary_columns a
SET description=b.description
FROM dd_cols_prev b
WHERE a.table_name=b.table_name
AND a.column_name=b.column_name
AND b.description IS NOT NULL 
AND a.description IS NULL
;

-- 
-- Columns values and definitions
-- 

-- Make temp table of table and columns shared between previous
-- constrained-values table and current database. This will remove 
-- any tables & columns from previous database no longer present 
-- in current database. However, new columns (plus their tables 
-- and constrained values) must be added by hand to the revised 
-- values spreadsheet
DROP TABLE IF EXISTS dd_vals_columns_prev;
CREATE TABLE dd_vals_columns_prev AS
SELECT DISTINCT 
a.table_name,
a.column_name
FROM (
SELECT DISTINCT table_name, column_name
FROM dd_vals_prev
) AS a
JOIN data_dictionary_columns b
ON a.table_name=b.table_name 
AND a.column_name=b.column_name 
;

-- Continue by inserting all distinct values for each table+column 
-- in dd_vals_columns_prev. Best done by looping in shell.