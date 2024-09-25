-- ---------------------------------------------------------------------
-- Update table definitions
-- ---------------------------------------------------------------------

SET search_path TO :sch;

-- Table names and descriptions
UPDATE data_dictionary_tables a
SET description=b.description
FROM dd_tables_revised b
WHERE a.table_name=b.table_name
;

DROP TABLE dd_tables_revised;
