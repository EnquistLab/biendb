--
-- One-time fix to apply 500 species embargo only. Not part of pipeline. 
--

BEGIN;

SET search_path TO :sch;

-- Mark records to delete
UPDATE agg_traits a
SET access='delete'
FROM trait_summary b
WHERE b.trait_name=a.trait_name
AND b.species_count<=500
;

-- Remove remaining records
DELETE FROM agg_traits
WHERE access='delete'
;

COMMIT;