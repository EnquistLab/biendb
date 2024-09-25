-- ------------------------------------------------------------
-- Check that all embargoes properly applied to table vfoi
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (
SELECT taxonobservation_id 
FROM view_full_occurrence_individual 
WHERE is_embargoed_observation='1' AND (
latitude IS NOT NULL 
OR longitude IS NOT NULL
OR locality<>'[Locality information hidden to protect endangered species]'
OR latlong_verbatim<>'[Information hidden to protect endangered species]'
OR location_id IS NOT NULL
OR occurrence_id IS NOT NULL
OR occurrence_remarks<>'[Information hidden to protect endangered species]'
)
LIMIT 1
) AS a;

