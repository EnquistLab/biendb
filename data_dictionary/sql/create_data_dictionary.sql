-- ---------------------------------------------------------------------
-- Creates tables of definitions for all tables & 
-- columns in schema
-- ---------------------------------------------------------------------

SET search_path TO :sch;

-- 
-- Table names and comments
-- 

DROP TABLE IF EXISTS data_dictionary_tables;
CREATE TABLE data_dictionary_tables AS
SELECT pg_class.relname AS table_name,
pg_desc.description 
FROM ((
(SELECT * FROM pg_description WHERE pg_description.objsubid = 0) AS pg_desc 
RIGHT JOIN pg_class ON ((pg_desc.objoid = pg_class.oid)))
RIGHT JOIN pg_namespace ON ((pg_class.relnamespace = pg_namespace.oid)))
WHERE (((pg_class.relkind = 'r'::"char") AND (pg_namespace.nspname = :'sch'::name))
)
ORDER BY pg_class.relname
;

CREATE INDEX ON data_dictionary_tables (table_name);

DELETE FROM data_dictionary_tables
WHERE table_name IN ('dd_cols_temp','dd_tables_temp','dd_vals_temp');

-- 
-- Columns names and definitions
-- 

DROP TABLE IF EXISTS data_dictionary_columns;
CREATE TABLE data_dictionary_columns AS
SELECT 
cols.table_name,
cols.ordinal_position,
cols.column_name,
cols.data_type,
cols.is_nullable AS can_be_null,
( SELECT col_description(c.oid, (cols.ordinal_position)::integer) AS col_description
FROM pg_class c
WHERE ((c.oid = ( SELECT ((cols.table_name)::regclass)::oid AS table_name)) AND (c.relname = (cols.table_name)::name))) AS description
FROM information_schema.columns cols 
WHERE (((cols.table_catalog)::text = 'vegbien'::text) AND ((cols.table_schema)::text = :'sch'::text))
ORDER BY cols.table_name, cols.column_name
;

CREATE INDEX ON data_dictionary_columns (table_name);
CREATE INDEX ON data_dictionary_columns (column_name);
CREATE INDEX ON data_dictionary_columns (data_type);

-- 
-- Columns values
-- This one must be a table, as information not store in database.
-- Column "value" should actually be not null; this constraint
-- will be changed after data added
-- 

DROP TABLE IF EXISTS data_dictionary_values;
CREATE TABLE data_dictionary_values (
table_name text not null,
column_name text not null,
value text default null,
definition text default null
)
;

--
-- Delete these temp tables from the dictionary
--

DELETE FROM data_dictionary_tables
WHERE table_name IN ('dd_cols_temp','dd_tables_temp','dd_vals_temp');


-- 
-- Set permissions
-- 

GRANT USAGE ON SCHEMA :sch TO bien_private;
GRANT SELECT ON ALL TABLES IN SCHEMA :sch TO bien_private;

GRANT USAGE ON SCHEMA :sch TO jmcgann;
GRANT SELECT ON ALL TABLES IN SCHEMA :sch TO jmcgann;

GRANT USAGE ON SCHEMA :sch TO fengxiao;
GRANT SELECT ON ALL TABLES IN SCHEMA :sch TO fengxiao;

