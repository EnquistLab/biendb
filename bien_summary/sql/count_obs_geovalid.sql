-- 
-- Adds count of all validly georeferenced observations to table bien_summary
--

SET search_path TO :dev_schema;

UPDATE bien_summary 
SET obs_geovalid_count=(
SELECT COUNT(*) 
FROM view_full_occurrence_individual_dev
WHERE latitude IS NOT NULL AND longitude IS NOT NULL
AND is_geovalid=1
)
WHERE bien_summary_id=(
SELECT MAX(bien_summary_id) FROM bien_summary
)
;
