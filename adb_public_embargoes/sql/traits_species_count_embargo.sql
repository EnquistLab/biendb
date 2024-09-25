--
-- ----------------------------------------------------------
-- Remove trait records based on number of species. 
-- 
-- Requires table trait_summary
-- Parameter ":sp_count_min" set in local params file
-- Also removes any deleted trait observations from vfoi
-- ----------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE view_full_occurrence_individual
ADD COLUMN fk_catalog_number bigint default null;

DROP INDEX IF EXISTS vfoi_observation_type_idx;
CREATE INDEX vfoi_observation_type_idx ON view_full_occurrence_individual(observation_type);

UPDATE view_full_occurrence_individual
SET fk_catalog_number=catalog_number::bigint
WHERE observation_type='trait'
;

DROP INDEX IF EXISTS vfoi_fk_catalog_number_idx;
CREATE INDEX vfoi_fk_catalog_number_idx ON view_full_occurrence_individual(fk_catalog_number);

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
AND a.fk_catalog_number=b.id
AND b.trait_value='delete'
;

DELETE FROM agg_traits
WHERE trait_value='delete'
;

COMMIT;

ALTER TABLE view_full_occurrence_individual
DROP COLUMN fk_catalog_number;

DROP INDEX IF EXISTS vfoi_observation_type_idx;
