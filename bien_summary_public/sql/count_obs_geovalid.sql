-- 
-- Adds count of all validly georeferenced observations to table bien_summary_public
--

SET search_path TO :dev_schema;

UPDATE bien_summary_public 
SET obs_geovalid_count=(
SELECT COUNT(*) 
FROM view_full_occurrence_individual
WHERE latitude IS NOT NULL AND longitude IS NOT NULL
AND is_geovalid=1
)
WHERE bien_summary_public_id=(
SELECT MAX(bien_summary_public_id) FROM bien_summary_public
)
;
