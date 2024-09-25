-- ------------------------------------------------------------
-- Check that is_geovalid always equals 0 when no coordinates
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (
SELECT is_geovalid 
FROM view_full_occurrence_individual 
WHERE (latitude IS NULL OR longitude IS NULL)
AND (is_geovalid<>0 OR is_geovalid IS NULL) 
LIMIT 1
) AS a;
