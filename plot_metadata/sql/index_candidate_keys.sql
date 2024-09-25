-- 
-- Indexes columns that will be linked to 
-- plot_metadata to extract foreign key values
-- 

BEGIN;

SET search_path TO :dev_schema;

LOCK TABLE view_full_occurrence_individual_dev IN SHARE MODE;

CREATE INDEX vfoi_dev_observation_type_idx ON view_full_occurrence_individual_dev USING btree (observation_type);
CREATE INDEX vfoi_dev_datasource_idx ON view_full_occurrence_individual_dev USING btree (datasource);
CREATE INDEX vfoi_dev_dataset_idx ON view_full_occurrence_individual_dev USING btree (dataset);
CREATE INDEX vfoi_dev_plot_name_idx ON view_full_occurrence_individual_dev USING btree (plot_name);

COMMIT;
