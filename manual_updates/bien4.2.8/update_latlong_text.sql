-- ------------------------------------------------------------------
-- Delete contents of latlong_text for embargoed records
-- This fixes result of bug which failed to fully clear all locality
-- information for embargoed species.
-- ------------------------------------------------------------------

\c public_vegbien
SET search_path TO PUBLIC;

UPDATE view_full_occurrence_individual
SET latlong_text=NULL
WHERE is_embargoed_observation=1
AND latlong_text IS NOT NULL
;

