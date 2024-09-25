-- 
-- Copies table world_geom from production to development schema
-- 

-- note addition of spatial schema to search_path
SET search_path TO :sch, postgis;

BEGIN;

DROP TABLE IF EXISTS :sch.world_geom;

CREATE TABLE :sch.world_geom ( 
LIKE :src_schema.world_geom
INCLUDING DEFAULTS 
INCLUDING CONSTRAINTS 
INCLUDING INDEXES 
);	

INSERT INTO :sch.world_geom
SELECT * FROM :src_schema.world_geom
:limit;

ALTER TABLE :sch.world_geom ALTER COLUMN ogc_fid DROP DEFAULT;

COMMIT;

