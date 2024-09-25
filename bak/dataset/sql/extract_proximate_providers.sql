-- 
-- Extract and add separate record for each proximate provider
-- Link proximate providers to each dataset via recursive FK
--

SET search_path TO :dev_schema;

UPDATE datasource
SET source_type='data owner';
UPDATE datasource
SET source_type='data owner & proximate provider'
WHERE proximate_provider_name=source_name;

-- Create temporary table of sources which are 
-- proximate providers only
DROP TABLE IF EXISTS proximate_providers;
CREATE TABLE proximate_providers AS
SELECT DISTINCT proximate_provider_name,
CAST(NULL AS TEXT) AS observation_type
FROM datasource
WHERE proximate_provider_name<>source_name;

CREATE INDEX ON proximate_providers (proximate_provider_name);

UPDATE proximate_providers AS a
SET observation_type=b.observation_type
FROM datasource AS b
WHERE a.proximate_provider_name=b.proximate_provider_name
AND b.observation_type IS NOT NULL 
AND b.observation_type<>''
;

INSERT INTO datasource (
proximate_provider_name,
source_name,
source_type,
observation_type,
is_herbarium,
access_conditions
)
SELECT 
proximate_provider_name,
proximate_provider_name,
'proximate provider',
observation_type,
0,
'acknowledge'
FROM proximate_providers
;

-- DROP TABLE IF EXISTS proximate_providers;

-- Update recursive foreign key
UPDATE datasource a
SET proximate_provider_datasource_id=b.datasource_id
FROM datasource b 
WHERE a.proximate_provider_name=b.source_name
;

-- Manual updates
UPDATE datasource
SET source_type='data owner & proximate provider'
WHERE proximate_provider_name=source_name
AND source_name IN ('FIA', 'Madidi', 'TEAM', 'CTFS')
;
UPDATE datasource
SET source_type='proximate provider'
WHERE source_name='HVAA'
;
