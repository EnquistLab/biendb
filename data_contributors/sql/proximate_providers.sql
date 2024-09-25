-- -------------------------------------------------------
-- Insert proximate data providers
-- -------------------------------------------------------

SET search_path TO :dev_schema;

-- Insert providers and observation counts
INSERT INTO proximate_providers (
proximate_provider,
obs
)
SELECT
proximate_provider,
SUM(obs)
FROM data_contributors
GROUP BY proximate_provider
ORDER BY proximate_provider
;

-- Populate remaining fields
UPDATE proximate_providers a
SET datasource_id=b.datasource_id,
proximate_provider_name=b.source_fullname,
sourcetype=b.source_type,
observationtype=b.observation_type
FROM datasource b 
WHERE a.proximate_provider=b.proximate_provider_name
AND b.source_name=b.proximate_provider_name
;



--
--  Misc fixes
-- 

UPDATE proximate_providers
SET proximate_provider_name=
CASE
WHEN proximate_provider='HIBG' THEN 'Hiroshima Botanical Garden'
WHEN proximate_provider='ARIZ' THEN 'The University of Arizona Herbarium'
WHEN proximate_provider='Canadensys' THEN 'Canadensys'
WHEN proximate_provider='Madidi' THEN 'Madidi Forest Plots Dataset'
WHEN proximate_provider='SpeciesLink' THEN 'SpeciesLink'
WHEN proximate_provider='VegBank' THEN 'VegBank'
ELSE proximate_provider_name
END
;

UPDATE proximate_providers
SET sourcetype='herbarium',
observationtype='specimen'
WHERE proximate_provider='HIBG'
;

UPDATE proximate_providers
SET proximate_provider_name='BIEN Traits Database'
WHERE proximate_provider='traits'
;

--
-- Fix sourcetype & observationtype
-- 
UPDATE proximate_providers a
SET 
sourcetype='herbarium',
observationtype='specimen'
FROM ih b
WHERE a.proximate_provider=b.specimen_duplicate_institutions
;
UPDATE proximate_providers a
SET sourcetype='aggregator'
WHERE observationtype='specimen'
AND sourcetype<>'herbarium'
;
UPDATE proximate_providers a
SET sourcetype='primary database'
WHERE observationtype='plot'
;
UPDATE proximate_providers a
SET sourcetype='aggregator'
WHERE proximate_provider='GBIF'
;
UPDATE proximate_providers a
SET observationtype='mixed occurrence types'
WHERE proximate_provider='GBIF'
;
UPDATE proximate_providers a
SET sourcetype='primary database'
WHERE sourcetype='provider & data owner'
;

UPDATE proximate_providers
SET sourcetype='primary database'
WHERE sourcetype='primaty database'
;


