-- ---------------------------------------------------------------
-- Drop name index
-- 
-- Parameters:
-- 	:sch - schema name
-- 	:idx - index name
-- ---------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS :"idx";