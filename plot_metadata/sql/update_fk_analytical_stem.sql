-- ---------------------------------------------------------
-- Updates fk plot_metadata_id in table analytical_stem_dev
-- by joining to table vfoi and using existing value of 
-- plot_metadata_id in the latter table.
-- 
-- WARNING: Make sure plot_metadata_id in table vfoi has been
-- populated before running this step!
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

DROP INDEX IF EXISTS vfoi_taxonobservation_id_idx;
CREATE INDEX vfoi_taxonobservation_id_idx ON view_full_occurrence_individual_dev (taxonobservation_id);
DROP INDEX IF EXISTS analytical_stem_taxonobservation_id_fkey_idx;
CREATE INDEX analytical_stem_taxonobservation_id_fkey_idx ON analytical_stem_dev (taxonobservation_id);

UPDATE analytical_stem_dev a
SET plot_metadata_id=b.plot_metadata_id
FROM view_full_occurrence_individual_dev b
WHERE a.taxonobservation_id=b.taxonobservation_id
;

-- Drop the temporary indexes
DROP INDEX IF EXISTS vfoi_taxonobservation_id_idx;
DROP INDEX IF EXISTS analytical_stem_taxonobservation_id_fkey_idx;
