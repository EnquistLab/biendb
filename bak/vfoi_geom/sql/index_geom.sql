-- 
-- Indexes the newly-populated geometry column
-- 

SET search_path TO :dev_schema, postgis;

DROP INDEX IF EXISTS vfoi_gist_idx;
CREATE INDEX vfoi_gist_idx ON view_full_occurrence_individual_dev USING gist (geom);

