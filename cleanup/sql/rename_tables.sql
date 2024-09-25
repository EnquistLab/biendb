-- ---------------------------------------------------------
-- Remove '_dev' suffix from names of major analytical tables
-- ---------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE view_full_occurrence_individual_dev RENAME TO view_full_occurrence_individual;

ALTER TABLE analytical_stem_dev RENAME TO analytical_stem;