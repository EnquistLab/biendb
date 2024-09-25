-- ---------------------------------------------------------------------
-- Update column definitions
-- ---------------------------------------------------------------------

SET search_path TO :sch;

UPDATE data_dictionary_columns a
SET description=b.description
FROM dd_cols_revised b
WHERE a.table_name=b.table_name
AND a.column_name=b.column_name
;

DROP TABLE dd_cols_revised;
