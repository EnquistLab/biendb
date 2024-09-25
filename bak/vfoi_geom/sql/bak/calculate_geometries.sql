-- ---------------------------------------------------------
-- Calculate geometries, by species
-- Run in loop, feeding one species at a time
-- ---------------------------------------------------------

SET search_path TO :dev_schema, postgis;

UPDATE view_full_occurrence_individual_dev SET geom = ST_GeomFromText('POINT(' || longitude || ' ' || latitude || ')',4326) WHERE  (scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL) AND scrubbed_species_binomial = '${SPECIES}'
;

   
