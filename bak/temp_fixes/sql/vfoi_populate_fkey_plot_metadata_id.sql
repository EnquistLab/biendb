-- ---------------------------------------------------------
-- Updates column observation_type by creating second (final)
-- copy table
--
-- Should get reasonable peformance using 'UPDATE' instead of 
-- 'CREATE TABLE AS' because nearly all indices have been removed
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

-- Try joining on three columns
UPDATE view_full_occurrence_individual AS a
SET plot_metadata_id=b.plot_metadata_id
FROM plot_metadata AS b
WHERE a.observation_type='plot'
AND a.datasource=b.datasource
AND a.dataset=b.dataset
AND a.plot_name=b.plot_name 
;

-- Drop the unneeded index
DROP INDEX vfoi_dev_dataset_idx;

-- Index the FK field to speed up checking if null
-- Actual field indexed doesn't matter; fewer values the better
CREATE INDEX vfoi_dev_plot_metadata_id_isnull_idx ON view_full_occurrence_individual (observation_type)
WHERE plot_metadata_id IS NULL
;

-- Mop up remainder by joining on two columns
UPDATE view_full_occurrence_individual AS a
SET plot_metadata_id=b.plot_metadata_id
FROM plot_metadata AS b
WHERE a.observation_type='plot'
AND a.plot_metadata_id IS NULL
AND a.datasource=b.datasource
AND a.plot_name=b.plot_name 
;

-- Drop unwanted indexes
-- Keeping the other two for next step
DROP INDEX vfoi_dev_datasource_idx;
DROP INDEX vfoi_dev_plot_metadata_id_isnull_idx;

-- Extra step to remove plot_names erroneously populated  
-- with GBIF specimen IDs during building of core db
UPDATE view_full_occurrence_individual 
SET 
plot_name=NULL, 
subplot=NULL, 
plot_area_ha=NULL, 
sampling_protocol=NULL, 
cover_percent=NULL
WHERE observation_type<>'plot'
AND plot_name IS NOT NULL
;

DROP INDEX vfoi_dev_observation_type_idx;
DROP INDEX vfoi_dev_plot_name_idx;

