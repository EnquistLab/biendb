-- ---------------------------------------------------------
-- Create constraints to prevent invalid geometries
-- ---------------------------------------------------------

SET search_path TO :dev_schema, postgis;

-- Geometry dimensions must be 2 (point)
ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS enforce_dimensions_geom;
ALTER TABLE view_full_occurrence_individual_dev
   ADD CONSTRAINT enforce_dimensions_geom
   CHECK (ST_NDims(geom) = 2);
   
-- Geometry type is only point      
ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS enforce_geometrytype_geom;
ALTER TABLE view_full_occurrence_individual_dev
   ADD CONSTRAINT enforce_geometrytype_geom
   CHECK (geometrytype(geom) = 'POINT'::text
     OR geom IS NULL);
     
-- Projection (SRID) is 4326 (WGS84)
ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE view_full_occurrence_individual_dev
   ADD CONSTRAINT enforce_srid_geom
   CHECK (ST_SRID(geom) = 4326);
   
