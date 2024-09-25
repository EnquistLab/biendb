-- 
-- Index columns needed to update plot observations
-- 

SET search_path TO :dev_schema;

DROP INDEX IF EXISTS vfoi_datasource_idx;
DROP INDEX IF EXISTS vfoi_plot_name_idx;
DROP INDEX IF EXISTS vfoi_observation_type_idx;

CREATE INDEX vfoi_datasource_idx ON view_full_occurrence_individual_dev USING btree (datasource);
CREATE INDEX vfoi_plot_name_idx ON view_full_occurrence_individual_dev USING btree (plot_name);
CREATE INDEX vfoi_observation_type_idx ON view_full_occurrence_individual_dev USING btree (observation_type);