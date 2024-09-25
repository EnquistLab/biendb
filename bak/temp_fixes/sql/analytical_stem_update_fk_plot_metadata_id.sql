-- ---------------------------------------------------------
-- Updates fk plot_metadata_id in table analytical_stem_dev
-- by joining to table vfoi and using existing value of 
-- plot_metadata_id in the latter table.
-- 
-- WARNINGS: 
-- 1. Make sure plot_metadata_id in table vfoi has been
-- populated before running this step!
-- 2. Joining columns must be indexed.
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

UPDATE analytical_stem a
SET plot_metadata_id=b.plot_metadata_id
FROM view_full_occurrence_individual b
WHERE a.taxonobservation_id=b.taxonobservation_id
;
