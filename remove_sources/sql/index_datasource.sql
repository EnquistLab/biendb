-- --------------------------------------------------------------------
-- Index datasource columns (and equivalent proximate_provider_name)
-- --------------------------------------------------------------------

SET search_path TO :sch;

CREATE INDEX datasource_proximate_provider_name_idx ON datasource (proximate_provider_name);
CREATE INDEX plot_metadata_datasource_idx ON plot_metadata (datasource);
CREATE INDEX vfoi_datasource_idx ON view_full_occurrence_individual_dev (datasource);
CREATE INDEX analytical_stem_dev_datasource_idx ON analytical_stem_dev (datasource);
