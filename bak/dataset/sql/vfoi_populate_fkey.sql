-- ---------------------------------------------------------
-- Updates column observation_type by creating second (final)
-- copy table
--
-- Should get reasonable peformance using 'UPDATE' instead of 
-- 'CREATE TABLE AS' because nearly all indices have been removed
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

-- Try joining on two columns
UPDATE view_full_occurrence_individual_dev AS a
SET datasource_id=b.datasource_id
FROM datasource AS b
WHERE a.datasource=b.proximate_provider_name
AND a.dataset=b.source_name
;

-- Drop the unneeded index
DROP INDEX vfoi_dev_dataset_idx;

-- Partial index on FK field to speed up checking if null
CREATE INDEX vfoi_dev_datasource_id_isnull_idx ON view_full_occurrence_individual_dev (datasource_id)
WHERE datasource_id IS NULL
;

-- Mop up remainder by joining on one column
UPDATE view_full_occurrence_individual_dev AS a
SET datasource_id=b.datasource_id
FROM datasource AS b
WHERE a.datasource_id IS NULL
AND a.datasource=b.proximate_provider_name
;

-- Drop remaining indexes
DROP INDEX vfoi_dev_datasource_idx;
DROP INDEX vfoi_dev_datasource_id_isnull_idx;
