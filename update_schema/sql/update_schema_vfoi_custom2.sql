-- ---------------------------------------------------------
-- Delete redundant trait occurrences accidentally recopied 
-- from vfoi to agg_traits and back to vfoi
-- 
-- WARNINGS: 
-- 1. Must have NO indexes on table vfoi!!!
-- 2. Necessary indexes on agg_traits already be present
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :sch;

-- Add indexes needed for delete operation
ALTER TABLE view_full_occurrence_individual ADD PRIMARY KEY (taxonobservation_id);
CREATE INDEX vfoi_observation_type_idx ON view_full_occurrence_individual (observation_type);

-- Delete the offending records
DELETE FROM view_full_occurrence_individual a
USING agg_traits b
WHERE a.observation_type='trait occurrence'
AND a.catalog_number=b.id
AND b.taxonobservation_id IS NOT NULL
;

COMMIT;