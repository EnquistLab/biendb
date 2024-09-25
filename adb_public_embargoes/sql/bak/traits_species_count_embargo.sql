--
-- ----------------------------------------------------------
-- Remove trait records based on number of species. 
-- 
-- Requires table trait_summary
-- Parameter ":sp_count_min" set in local params file
-- Also removes any deleted trait observations from vfoi
-- ----------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS vfoi_catalog_number_idx;
CREATE INDEX vfoi_catalog_number_idx ON view_full_occurrence_individual(catalog_number);

BEGIN;

UPDATE agg_traits a
SET trait_value='delete'
FROM trait_summary b
WHERE a.trait_name=b.trait_name
AND a.unit=b.units
AND b.species_count<=:sp_count_min
;

UPDATE agg_traits a
SET trait_value='delete'
FROM trait_summary b
WHERE a.trait_name=b.trait_name
AND a.unit IS NULL
AND b.units IS NULL
AND b.species_count<=:sp_count_min
;

DELETE FROM view_full_occurrence_individual a
USING agg_traits b
WHERE a.observation_type='trait'
AND a.catalog_number=b.id
AND b.trait_value='delete'
;

DELETE FROM agg_traits
WHERE trait_value='delete'
;

COMMIT;
