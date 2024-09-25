-- ------------------------------------------------------------
-- Check that all embargoes properly applied for source madidi
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (
SELECT taxonobservation_id 
FROM analytical_stem 
WHERE datasource='Madidi'
LIMIT 1
) AS a;

