-- --------------------------------------------------------------------
-- Transfers temporary datasource_staging foreign key
-- --------------------------------------------------------------------

SET search_path TO :sch;

-- 
-- Create temporary indexes
-- 

DROP INDEX IF EXISTS vfoi_staging_datasource_idx;
CREATE INDEX vfoi_staging_datasource_idx ON vfoi_staging (datasource);
DROP INDEX IF EXISTS vfoi_staging_dataset_idx;
CREATE INDEX vfoi_staging_dataset_idx ON vfoi_staging (dataset);

DROP INDEX IF EXISTS datasource_staging_source_name_idx;
CREATE INDEX datasource_staging_source_name_idx ON datasource_staging (source_name);
DROP INDEX IF EXISTS datasource_staging_proximate_provider_name_idx;
CREATE INDEX datasource_staging_proximate_provider_name_idx ON datasource_staging (proximate_provider_name);

-- 
-- Run the updates
-- 
UPDATE vfoi_staging a
SET datasource_staging_id=b.datasource_staging_id
FROM datasource_staging b
WHERE a.datasource=b.proximate_provider_name
AND a.dataset=b.source_name
;

-- 
-- Drop temporary indexes
-- 

DROP INDEX IF EXISTS vfoi_staging_datasource_idx;
DROP INDEX IF EXISTS vfoi_staging_dataset_idx;
DROP INDEX IF EXISTS datasource_staging_source_name_idx;
DROP INDEX IF EXISTS datasource_staging_proximate_provider_name_idx;