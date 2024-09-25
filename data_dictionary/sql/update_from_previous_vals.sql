-- ---------------------------------------------------------------------
-- Copies column value definitions from previous versions
-- ---------------------------------------------------------------------

SET search_path TO :sch;

-- Set NULL values to literal 'NULL'
UPDATE data_dictionary_values a
SET value='NULL'
WHERE value IS NULL
;

-- Add indexes
DROP INDEX IF EXISTS data_dictionary_values_table_name_idx;
CREATE INDEX data_dictionary_values_table_name_idx ON data_dictionary_values (table_name);

DROP INDEX IF EXISTS data_dictionary_values_column_name_idx;
CREATE INDEX data_dictionary_values_column_name_idx ON data_dictionary_values (column_name);

DROP INDEX IF EXISTS data_dictionary_values_value_idx;
CREATE INDEX data_dictionary_values_value_idx ON data_dictionary_values (value);

DROP INDEX IF EXISTS dd_vals_prev_definition_notnull_idx;
CREATE INDEX dd_vals_prev_definition_notnull_idx ON dd_vals_prev (table_name) WHERE definition IS NOT NULL;

-- Transfer the definitions
UPDATE data_dictionary_values a
SET definition=b.definition
FROM dd_vals_prev b
WHERE a.table_name=b.table_name
AND a.column_name=b.column_name
AND a.value=b.value
AND b.definition IS NOT NULL 
;

-- Add final index
DROP INDEX IF EXISTS data_dictionary_values_table_name_column_name_value_idx;
CREATE INDEX data_dictionary_values_table_name_column_name_value_idx ON data_dictionary_values (table_name, column_name, value);
