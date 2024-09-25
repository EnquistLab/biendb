-- --------------------------------------------------------------
-- Drop temporary indexes 
-- --------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS agg_traits_fk_tnrs_id_idx;

DROP INDEX IF EXISTS analytical_stem_dev_fk_tnrs_id_idx;
DROP INDEX IF EXISTS analytical_stem_dev_datasource_idx;

DROP INDEX IF EXISTS view_full_occurrence_individual_dev_fk_tnrs_id_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_datasource_idx;

DROP INDEX IF EXISTS agg_traits_higher_plant_group_isnotnull_idx;
DROP INDEX IF EXISTS vfoi_dev_higher_plant_group_isnotnull_idx;
