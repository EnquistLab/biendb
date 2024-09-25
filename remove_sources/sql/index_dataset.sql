-- --------------------------------------------------------------------
-- Index dataset columns (and equivalent source_name)
-- --------------------------------------------------------------------

SET search_path TO :sch;

CREATE INDEX datasource_source_name_idx ON datasource (source_name);
CREATE INDEX plot_metadata_dataset_idx ON plot_metadata (dataset);
CREATE INDEX vfoi_dataset_idx ON view_full_occurrence_individual_dev (dataset);
CREATE INDEX analytical_stem_dev_dataset_idx ON analytical_stem_dev (dataset);
