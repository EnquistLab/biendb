-- ------------------------------------------------------------
-- Check that is_geovalid always equals 0 when point not in
-- political division
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (
SELECT is_geovalid 
FROM view_full_occurrence_individual 
WHERE (is_geovalid<>0 OR is_geovalid IS NULL) 
AND (is_in_country=0 OR is_in_state_province=0 OR is_in_county=0)
LIMIT 1
) AS a;
