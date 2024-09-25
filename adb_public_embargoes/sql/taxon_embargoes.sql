-- ---------------------------------------------------------
-- Applies locality embargoes to endangered species in table
-- vfoi
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS vfoi_is_embargoed_observation_idx;
CREATE INDEX vfoi_is_embargoed_observation_idx ON view_full_occurrence_individual (is_embargoed_observation)
;

UPDATE view_full_occurrence_individual
SET 
locality='[Locality information hidden to protect endangered species]',
latlong_verbatim='[Information hidden to protect endangered species]',
latitude=NULL,
longitude=NULL,
location_id=NULL,
occurrence_id=NULL,
occurrence_remarks='[Information hidden to protect endangered species]'
WHERE is_embargoed_observation='1'
;

DROP INDEX IF EXISTS vfoi_is_embargoed_observation_idx;