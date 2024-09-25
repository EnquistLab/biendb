-- ---------------------------------------------------------------------
-- Copies previous data dictionary tables to temp tables
-- Used in later step to transfer information to current tables
-- Old tables 'recycled' can be in same schema or different
-- If same, can use successive cycles of editing and import to 
-- build up content without edit spreadsheets from scratch each time
-- 
-- Parameters:
-- 	:sch: current (development) schema, to which table will be copied
--	:src_sch: source schema from which tables will be copied
-- ---------------------------------------------------------------------

SET search_path TO :sch;

-- 
-- Table names and comments
-- 

DROP TABLE IF EXISTS dd_tables_prev;
CREATE TABLE dd_tables_prev AS
SELECT * FROM :src_sch.data_dictionary_tables
ORDER BY table_name
;
CREATE INDEX ON dd_tables_prev (table_name);

-- 
-- Columns names and definitions
-- 

DROP TABLE IF EXISTS dd_cols_prev;
CREATE TABLE dd_cols_prev AS
SELECT * FROM :src_sch.data_dictionary_columns
ORDER BY table_name, ordinal_position
;
CREATE INDEX ON dd_cols_prev (table_name);
CREATE INDEX ON dd_cols_prev (column_name);

-- 
-- Columns values and definitions
-- 

DROP TABLE IF EXISTS dd_vals_prev;
CREATE TABLE dd_vals_prev AS
SELECT * FROM :src_sch.data_dictionary_values
ORDER BY table_name, column_name, value
;
CREATE INDEX ON dd_vals_prev (table_name);
CREATE INDEX ON dd_vals_prev (column_name);
CREATE INDEX ON dd_vals_prev (value);
