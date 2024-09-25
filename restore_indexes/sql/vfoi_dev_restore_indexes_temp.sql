-- --------------------------------------------------------------------
-- One-off version for resuming after crash
-- --------------------------------------------------------------------

SET search_path TO :sch, postgis;



-- Deleted previous steps; already done




-- 
-- Spatial indexes and constraints
-- 

DROP INDEX IF EXISTS vfoi_georeferenced_species_idx;
CREATE INDEX vfoi_georeferenced_species_idx ON view_full_occurrence_individual_dev USING btree (scrubbed_species_binomial)
WHERE scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL;

-- Main (gist) index on geometry column
DROP INDEX IF EXISTS vfoi_gist_idx;
CREATE INDEX vfoi_gist_idx ON view_full_occurrence_individual_dev USING gist (geom);

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
   





