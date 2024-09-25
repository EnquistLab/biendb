-- ---------------------------------------------------------------------
-- Copies definitions for all tables & columns from previous analytical 
-- schema to temp tables in dev schema and updates tables for current
-- schema.
-- ---------------------------------------------------------------------

SET search_path TO :sch;

-- Table names and descriptions
UPDATE data_dictionary_tables a
SET description=b.description
FROM dd_tables_revised b
WHERE a.table_name=b.table_name
;

-- Column names and descriptions
UPDATE data_dictionary_columns a
SET description=b.description
FROM dd_cols_revised b
WHERE a.table_name=b.table_name
AND a.column_name=b.column_name
;

-- Constrained values and definitions
-- Replaces entire contents
-- Previous values, if present, used only
-- as template for revision
TRUNCATE data_dictionary_values;
INSERT INTO data_dictionary_values 
SELECT a.* 
FROM dd_vals_revised a JOIN data_dictionary_columns b
ON a.table_name=b.table_name AND a.column_name=b.column_name
WHERE a.value IS NOT NULL
;

-- Drop the revision tables
DROP TABLE dd_tables_revised;
DROP TABLE dd_cols_revised;
DROP TABLE IF EXISTS dd_vals_revised;