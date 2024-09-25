-- --------------------------------------------------------------------
-- Update FK plot_metadata_id in view_full_occurrence_individual_dev
-- --------------------------------------------------------------------

SET search_path TO :sch;

-- 
-- Add additional indexes to view_full_occurrence_individual. 
-- Column datasource should already have index from previous operation
-- 

DROP INDEX IF EXISTS view_full_occurrence_individual_dev_observation_type_idx;
CREATE INDEX view_full_occurrence_individual_dev_observation_type_idx ON view_full_occurrence_individual_dev (observation_type);

DROP INDEX IF EXISTS view_full_occurrence_individual_dev_dataset_idx;
CREATE INDEX view_full_occurrence_individual_dev_dataset_idx ON view_full_occurrence_individual_dev (dataset);

DROP INDEX IF EXISTS view_full_occurrence_individual_dev_plot_name_idx;
CREATE INDEX view_full_occurrence_individual_dev_plot_name_idx ON view_full_occurrence_individual_dev (plot_name);

-- 
-- Run the update
-- Only the FIA fks need updating
-- 

UPDATE view_full_occurrence_individual_dev a
SET plot_metadata_id=b.plot_metadata_id
FROM plot_metadata b
WHERE a.observation_type='plot'
AND a.datasource='FIA'
AND b.datasource='FIA'
AND a.dataset=b.dataset
AND a.plot_name=b.plot_name
;
