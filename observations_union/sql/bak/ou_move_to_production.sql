-- 
-- Renames current production schema to "[production_schema_name]_bak" and 
-- replaces with development schema
--

BEGIN;


SET search_path TO :prod_schema;
DROP TABLE IF EXISTS observations_union CASCADE;
DROP TABLE IF EXISTS species CASCADE;

SET search_path TO :dev_schema;
ALTER TABLE observations_union SET SCHEMA :prod_schema;
ALTER TABLE species SET SCHEMA :prod_schema;

COMMIT;