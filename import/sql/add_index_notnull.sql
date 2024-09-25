-- ---------------------------------------------------------------
-- Adds not null partial index.
-- Useful ONLY if majority of records are null for this column
-- 
-- Parameters:
-- 	:sch - schema
-- 	:idx - index name
-- 	:"tbl" - table 
-- 	:"col" - column name 
-- ---------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS :"idx";
CREATE INDEX :idx ON :"tbl" (:"col") WHERE :"col" IS NOT NULL;