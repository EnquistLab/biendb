-- ---------------------------------------------------------------
-- Replaces contents of (current) data_dictionary_values with 
-- contents of dd_vals_prev (=previous data_dictionary_values).
-- Shortcut to avoid unnecessary editing of constraint column
-- values. Will do this thoroughly for *next* DB version.
-- ---------------------------------------------------------------

set search_path to analytical_db_dev;

TRUNCATE data_dictionary_values;
INSERT INTO data_dictionary_values SELECT * FROM dd_vals_prev;