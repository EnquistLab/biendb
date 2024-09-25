-- --------------------------------------------------------------------
-- Remove all indexes potentially added by this module
-- --------------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS datasource_proximate_provider_name_idx;
DROP INDEX IF EXISTS plot_metadata_datasource_idx;
DROP INDEX IF EXISTS vfoi_datasource_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_datasource_idx;
DROP INDEX IF EXISTS analytical_stem_dev_datasource_idx;

DROP INDEX IF EXISTS datasource_source_name_idx;
DROP INDEX IF EXISTS plot_metadata_dataset_idx;
DROP INDEX IF EXISTS vfoi_dataset_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_devdataset_idx;
DROP INDEX IF EXISTS analytical_stem_dev_dataset_idx;
