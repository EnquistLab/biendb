-- ------------------------------------------------------------
-- Check that all embargoes properly applied for source madidi
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (
SELECT taxonobservation_id 
FROM view_full_occurrence_individual 
WHERE datasource='Madidi'
LIMIT 1
) AS a;

