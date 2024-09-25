-- ---------------------------------------------------------------
-- Populates missing values of higher_plant_group
-- Purely manual fix, not sure why these values are missing
-- 
-- DB version not incremented (at 4.1.1)
-- ADDED TO BIEN 4.2 PIPELINE
-- ---------------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

UPDATE view_full_occurrence_individual
SET higher_plant_group = 'bryophytes'
WHERE scrubbed_family='Andreaeobryaceae'
OR scrubbed_genus='Andreaeobryum'
;

\c public_vegbien

UPDATE view_full_occurrence_individual
SET higher_plant_group = 'bryophytes'
WHERE scrubbed_family='Andreaeobryaceae'
OR scrubbed_genus='Andreaeobryum'
;


