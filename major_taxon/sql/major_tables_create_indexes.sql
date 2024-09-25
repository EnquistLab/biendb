-- --------------------------------------------------------------
-- Add indexes needed for next steps
-- Assumes all other indexes have been dropped
-- --------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS agg_traits_fk_tnrs_id_idx;
CREATE INDEX agg_traits_fk_tnrs_id_idx ON agg_traits (fk_tnrs_id);

DROP INDEX IF EXISTS analytical_stem_dev_fk_tnrs_id_idx;
CREATE INDEX analytical_stem_dev_fk_tnrs_id_idx ON analytical_stem_dev (fk_tnrs_id);
DROP INDEX IF EXISTS analytical_stem_dev_datasource_idx;
CREATE INDEX analytical_stem_dev_datasource_idx ON analytical_stem_dev (datasource);


DROP INDEX IF EXISTS view_full_occurrence_individual_dev_fk_tnrs_id_idx;
CREATE INDEX view_full_occurrence_individual_dev_fk_tnrs_id_idx ON view_full_occurrence_individual_dev (fk_tnrs_id);
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_datasource_idx;
CREATE INDEX view_full_occurrence_individual_dev_datasource_idx ON view_full_occurrence_individual_dev (datasource);
