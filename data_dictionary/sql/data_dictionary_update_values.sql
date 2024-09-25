-- ---------------------------------------------------------------------
-- Update constrained values and definitions
-- ---------------------------------------------------------------------

SET search_path TO :sch;

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

DROP TABLE IF EXISTS dd_vals_revised;