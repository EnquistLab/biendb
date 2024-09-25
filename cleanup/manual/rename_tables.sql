-- Remove _dev suffix from the two main analytical tables
ALTER TABLE analytical_stem_dev RENAME TO analytical_stem;
ALTER TABLE view_full_occurrence_individual_dev RENAME TO view_full_occurrence_individual;
