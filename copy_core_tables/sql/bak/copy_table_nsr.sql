-- ---------------------------------------------------------
-- Copy table from core schema to development schema
-- Data only, no indexes
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :dev_schema;

LOCK TABLE :core_schema.nsr_daniel_20151213 IN SHARE MODE;

-- Adjust work_mem, but research carefully
-- SET LOCAL work_mem = '500 MB';  -- just for this transaction

-- Copy the table & data
DROP TABLE IF EXISTS :dev_schema.nsr;
CREATE TABLE :dev_schema.nsr ( LIKE :core_schema.nsr_daniel_20151213 );

INSERT INTO :dev_schema.nsr 
SELECT * 
FROM :core_schema.nsr_daniel_20151213
:limit
;

-- Commit & release share lock on original table
COMMIT;