-- 
-- Add FK datasource_id to table plot_metadata 
-- 

SET search_path TO :dev_schema;

UPDATE plot_metadata a
SET datasource_id=b.datasource_id
FROM datasource b
WHERE a.datasource=b.proximate_provider_name
AND a.dataset=b.source_name
AND b.observation_type='plot'
;

-- Probably not needed but will mop up any missed by 
-- previous query
UPDATE plot_metadata a
SET datasource_id=b.datasource_id
FROM datasource b
WHERE a.datasource=b.proximate_provider_name
AND b.observation_type='plot'
AND a.datasource_id IS NULL
;
