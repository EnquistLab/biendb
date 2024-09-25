-- 
-- Indexes columns that will be linked to 
-- plot_metadata to extract foreign key values
-- 

SET search_path TO :dev_schema;

CREATE INDEX vfoi_dev_observation_type_idx ON view_full_occurrence_individual USING btree (observation_type);
CREATE INDEX vfoi_dev_datasource_idx ON view_full_occurrence_individual USING btree (datasource);
CREATE INDEX vfoi_dev_dataset_idx ON view_full_occurrence_individual USING btree (dataset);
CREATE INDEX vfoi_dev_plot_name_idx ON view_full_occurrence_individual USING btree (plot_name);
