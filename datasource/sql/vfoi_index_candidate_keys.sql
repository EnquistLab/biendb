-- 
-- Indexes columns that will be linked to 
-- datasource to extract foreign key values
-- 

SET search_path TO :dev_schema;

CREATE INDEX vfoi_dev_datasource_idx ON view_full_occurrence_individual_dev USING btree (datasource);
CREATE INDEX vfoi_dev_dataset_idx ON view_full_occurrence_individual_dev USING btree (dataset);