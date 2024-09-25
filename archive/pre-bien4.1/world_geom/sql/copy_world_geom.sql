-- 
-- Copies table world_geom from production to development schema
-- 

SET search_path TO :dev_schema, postgis;

BEGIN;

-- Drop original table
-- DROP TABLE IF EXISTS :dev_schema.world_geom;
CREATE TABLE :dev_schema.world_geom ( 
LIKE :prod_schema.world_geom
INCLUDING DEFAULTS 
INCLUDING CONSTRAINTS 
INCLUDING INDEXES 
);	

INSERT INTO :dev_schema.world_geom
SELECT * FROM :prod_schema.world_geom;

ALTER TABLE :dev_schema.world_geom ALTER COLUMN ogc_fid DROP DEFAULT;

COMMIT;

