-- 
-- Transfer plot datasource info back to vfoi
-- 

BEGIN;

SET search_path TO :dev_schema;

DROP INDEX IF EXISTS vfoi_observation_type_idx;

-- Should get reasonable peformance using 'UPDATE' instead of 
-- 'CREATE TABLE AS' because nearly all indices have been removed
UPDATE view_full_occurrence_individual_dev AS a
SET 
dataset=b.dataset,
dataowner=b.primary_dataowner
FROM plot_provenance AS b
WHERE a.datasource=b.datasource
AND a.plot_name=b.plot_name 
;

-- Remove all indexes
DROP INDEX IF EXISTS vfoi_datasource_idx;
DROP INDEX IF EXISTS vfoi_plot_name_idx;

COMMIT;