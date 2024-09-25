-- 
-- Final hacks to fix mystery issues
--

SET search_path TO :dev_schema;

UPDATE datasource
SET source_name=proximate_provider_name
WHERE proximate_provider_name IS NOT NULL
AND source_name IS NULL
;

-- 
-- Populate missing values of access_level
--  

UPDATE datasource
SET access_level='public & private'
WHERE proximate_provider_name='Cyrille_traits' 
AND source_name IS NULL
;

UPDATE datasource
SET access_level='private'
WHERE proximate_provider_name='REMIB' 
AND source_name IS NULL
;

UPDATE datasource
SET access_level='public'
WHERE access_level IS NULL
;

