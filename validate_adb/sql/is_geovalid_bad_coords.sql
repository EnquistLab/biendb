-- ------------------------------------------------------------
-- Check that is_geovalid always equals 0 when invalid coordinate
-- values
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (
SELECT is_geovalid 
FROM view_full_occurrence_individual 
WHERE (latitude>90 OR latitude<-90 OR longitude>180 OR latitude<-180)
AND (is_geovalid<>0 OR is_geovalid IS NULL) 
LIMIT 1
) AS a;
