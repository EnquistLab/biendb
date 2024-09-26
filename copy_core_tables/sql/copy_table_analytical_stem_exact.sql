-- ---------------------------------------------------------
-- Copy table exactly from previous database, allowing for
-- possible filtering with WHERE and LIMIT clauses, passed
-- as parameters. The simplest use case.
-- ---------------------------------------------------------

-- SET search_path TO analytical_db_dev, postgis;
-- postgis included to enable geospatial columns
SET search_path TO :target_schema, postgis;

BEGIN;

LOCK TABLE :src_schema.analytical_stem IN SHARE MODE;

-- Adjust work_mem, but research carefully
-- SET LOCAL work_mem = '500 MB';  -- just for this transaction
SET temp_buffers = '3000MB';

-- Copy the table using CREATE TABLE AS method
-- This method is fast as it removes all indexes, foreign keys, etc.
DROP TABLE IF EXISTS :target_schema.analytical_stem_dev;
CREATE TABLE :target_schema.analytical_stem_dev AS 
SELECT * FROM :src_schema.analytical_stem
:where 
:limit
;

-- Commit & release share lock on original table
COMMIT;