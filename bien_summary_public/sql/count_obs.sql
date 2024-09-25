-- 
-- Adds count of all observations to table bien_summary_public
-- This is first count, so adds new record rather than updating
--

SET search_path TO :dev_schema;

UPDATE bien_summary_public 
SET obs_count=(
SELECT COUNT(*) 
FROM view_full_occurrence_individual
) 
WHERE bien_summary_public_id=(
SELECT MAX(bien_summary_public_id) FROM bien_summary_public
)
;
