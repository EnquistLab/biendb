-- ----------------------------------------------------------
-- Delete remaining animal taxa
-- ----------------------------------------------------------

\c vegbien
SET search_path TO analytical_db_dev;

DELETE FROM agg_traits
WHERE name_submitted ILIKE '%idae %'
;

DELETE FROM analytical_stem
WHERE name_submitted ILIKE '%idae %'
;

DELETE FROM view_full_occurrence_individual
WHERE name_submitted ILIKE '%idae %'
;

