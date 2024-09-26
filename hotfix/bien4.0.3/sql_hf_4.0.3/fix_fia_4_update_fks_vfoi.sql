-- --------------------------------------------------------------------
-- Update FK plot_metadata_id in vfoi_dev
-- --------------------------------------------------------------------

SET search_path TO :sch;

-- 
-- Add indexes to vfoi. Column datasource should already have index
-- from previous operation
-- 

DROP INDEX IF EXISTS vfoi_dev_observation_type_idx;
CREATE INDEX vfoi_dev_observation_type_idx ON vfoi_dev (observation_type);
DROP INDEX IF EXISTS vfoi_dev_dataset_idx;
CREATE INDEX vfoi_dev_dataset_idx ON vfoi_dev (dataset);
DROP INDEX IF EXISTS vfoi_dev_plot_name_idx;
CREATE INDEX vfoi_dev_plot_name_idx ON vfoi_dev (plot_name);

-- 
-- Run the update
-- 

UPDATE vfoi_dev a
SET plot_metadata_id=b.plot_metadata_id
FROM plot_metadata_dev b
WHERE a.observation_type='plot'
AND a.datasource=b.datasource
AND a.dataset=b.dataset
AND a.plot_name=b.plot_name
;
