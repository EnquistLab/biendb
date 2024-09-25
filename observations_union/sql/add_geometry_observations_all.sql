-- ---------------------------------------------------------
-- Populates geometry column in table observations_all
-- ---------------------------------------------------------

SET search_path TO :sch, postgis;

-- ---------------------------
-- Add geometry constraints
-- ---------------------------

-- Geometry dimensions must be 2 (point)
ALTER TABLE observations_all DROP CONSTRAINT IF EXISTS observations_all_enforce_dimensions_geom;
ALTER TABLE observations_all
   ADD CONSTRAINT observations_all_enforce_dimensions_geom
   CHECK (ST_NDims(geom) = 2);
   
-- Geometry type is only point      
ALTER TABLE observations_all DROP CONSTRAINT IF EXISTS observations_all_enforce_geometrytype_geom;
ALTER TABLE observations_all
   ADD CONSTRAINT observations_all_enforce_geometrytype_geom
   CHECK (geometrytype(geom) = 'POINT'::text
     OR geom IS NULL);
     
-- Projection (SRID) 4326=WGS84)
-- Projection (SRID) 3857=WGS84)
ALTER TABLE observations_all DROP CONSTRAINT IF EXISTS observations_all_enforce_srid_geom;
ALTER TABLE observations_all
   ADD CONSTRAINT observations_all_enforce_srid_geom
   CHECK (ST_SRID(geom) = 3857);

-- ---------------------------
-- Populate geom and index
-- ---------------------------

UPDATE observations_all 
SET geom = ST_GeomFromText('POINT(' || longitude || ' ' || latitude || ')',3857) ;

DROP INDEX IF EXISTS observations_all_gist_idx;
CREATE INDEX observations_all_gist_idx ON observations_all USING gist (geom);