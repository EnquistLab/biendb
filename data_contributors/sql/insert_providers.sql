-- 
-- Insert data providers
-- Note that only top-level (proximate) providers inserted for plots
--

SET search_path TO :dev_schema;

--
-- Insert providers and observation counts: non-plots
--
INSERT INTO data_contributors (
proximate_provider,
provider,
obs
)
SELECT 
datasource,
coalesce(dataset,''),
COUNT(*)
FROM view_full_occurrence_individual
WHERE datasource IS NOT NULL
GROUP BY datasource, coalesce(dataset,'')
;

-- Populate observation types
DROP TABLE IF EXISTS datasource_obs_types_temp;
CREATE TABLE datasource_obs_types_temp AS
SELECT datasource, coalesce(dataset,'') AS dataset, 
string_agg(DISTINCT observation_type, ', ' order by observation_type) AS obs_types
FROM view_full_occurrence_individual
GROUP BY datasource, coalesce(dataset,'')
;
UPDATE data_contributors a
SET observationtype=b.obs_types
FROM datasource_obs_types_temp b
WHERE a.proximate_provider=b.datasource
AND coalesce(a.provider,'')=b.dataset
;
DROP TABLE datasource_obs_types_temp;

--
-- Populate datasource_id, if known
-- 

UPDATE data_contributors a
SET datasource_id=b.datasource_id
FROM datasource b
WHERE a.provider=coalesce(b.source_name,'')
AND a.proximate_provider=b.proximate_provider_name 
;

--
-- Update remaining fields from table datasource
--

UPDATE data_contributors a
SET
provider_name=b.source_fullname,
sourcetype=
CASE
WHEN b.source_type LIKE '%data owner%' THEN 'primary database'
ELSE 'aggregator'
END,
url=b.source_url,
is_herbarium=b.is_herbarium
FROM datasource b
WHERE a.datasource_id=b.datasource_id
; 

-- Reset 'plot' to 'primary database'
-- observationtype tells us this is plot
UPDATE data_contributors
SET sourcetype='primary database'
WHERE sourcetype='plot'
;
--
-- Hard-wired fixes
--

UPDATE data_contributors
SET provider_name='BIEN Traits Database'
WHERE provider='traits'
;
UPDATE data_contributors a
SET provider_name='University of Arizona Herbarium'
WHERE proximate_provider='ARIZ'
;
UPDATE data_contributors a
SET provider_name='SpeciesLink'
WHERE proximate_provider='SpeciesLink'
;
;
UPDATE data_contributors a
SET provider_name='VegBank'
WHERE proximate_provider='VegBank'
;
UPDATE data_contributors a
SET provider_name='Madidi Forest Plots'
WHERE proximate_provider='Madidi'
;
UPDATE data_contributors a
SET provider_name='SALVIAS Forest Plots Dataset'
WHERE proximate_provider='SALVIAS'
;
UPDATE data_contributors
SET sourcetype='herbarium',
provider_name = 'Hiroshima Botanical Garden',
is_herbarium=1
WHERE proximate_provider IN ('HIBG')
;
UPDATE data_contributors
SET provider_name='RED Mundial de Biodiversidad'
WHERE provider IN ('REMIB')
AND  (provider_name IS NULL OR provider_name='')
;

--
-- Fix Canadensys herbaria
-- 
UPDATE data_contributors
SET provider='JBM',
provider_name='Jardin Botanique de Montréal'
WHERE proximate_provider='JBM'
;
UPDATE data_contributors
SET provider=proximate_provider
WHERE proximate_provider IN ('JBM','QFA','TRTE','ACAD','MT','WIN','TRT','UBC')
;
UPDATE data_contributors
SET proximate_provider='Canadensys'
WHERE provider IN ('JBM','QFA','TRTE','ACAD','MT','WIN','TRT','UBC')
;

--
-- Fix nonsense institutions
-- 
UPDATE data_contributors
SET provider_name='[Unknown]',
provider='[Unknown]'
WHERE provider IN ('-', '??', '*')
;
UPDATE data_contributors
SET provider_name=NULL,
provider=CONCAT('[Unknown] (', provider, ')')
WHERE public.is_numeric(provider)
;


UPDATE data_contributors
SET sourcetype=
CASE
WHEN provider in ('HIBG','JBM') THEN 'herbarium'
WHEN provider in ('Madidi') THEN 'plot'
WHEN provider in ('REMIB','SpeciesLink') THEN 'aggregator'
ELSE sourcetype
END
;


--
-- Fix multi-institution source
-- 
UPDATE data_contributors
SET provider='[Multiple institutions]'
WHERE provider LIKE '%,%'
AND proximate_provider IN ('REMIB', 'GBIF', 'MO')
;
INSERT INTO data_contributors (
provider,
provider_name,
proximate_provider,
sourcetype,
observationtype,
obs
)
SELECT
'[multiple contributors]',
NULL,
proximate_provider,
sourcetype,
observationtype,
SUM(obs)
FROM data_contributors
WHERE provider='[Multiple institutions]'
AND proximate_provider IN ('REMIB', 'GBIF', 'MO')
GROUP BY proximate_provider, sourcetype, observationtype
;
DELETE FROM data_contributors
WHERE provider='[Multiple institutions]'
;

--
-- Fix MO
--
INSERT INTO data_contributors (
provider,
provider_name,
proximate_provider,
sourcetype,
observationtype,
obs
)
SELECT
'MO',
'keep',
proximate_provider,
'herbarium',
'specimen',
SUM(obs)
FROM data_contributors
WHERE proximate_provider='MO'
GROUP BY proximate_provider
;
DELETE FROM data_contributors
WHERE proximate_provider='MO'
AND provider_name<>'keep'
;
UPDATE data_contributors
SET provider_name='Missouri Botanical Garden Herbarium'
WHERE provider='MO'
;

--
-- Fix NY
--
INSERT INTO data_contributors (
provider,
provider_name,
proximate_provider,
sourcetype,
observationtype,
obs
)
SELECT
'NY',
'keep',
proximate_provider,
'herbarium',
'specimen',
SUM(obs)
FROM data_contributors
WHERE proximate_provider='NY'
GROUP BY proximate_provider
;
DELETE FROM data_contributors
WHERE proximate_provider='NY'
AND provider_name<>'keep'
;
UPDATE data_contributors
SET provider_name='New York Botanical Garden Herbarium'
WHERE provider='NY'
;

--
-- Fix NCU
--
INSERT INTO data_contributors (
provider,
provider_name,
proximate_provider,
sourcetype,
observationtype,
is_herbarium,
obs
)
SELECT
'NCU',
'keep',
proximate_provider,
'herbarium',
'specimen',
1,
SUM(obs)
FROM data_contributors
WHERE proximate_provider='NCU'
GROUP BY proximate_provider
;
DELETE FROM data_contributors
WHERE proximate_provider='NCU'
AND provider_name<>'keep'
;
UPDATE data_contributors
SET provider_name='University of North Carolina at Chapel Hill, Herbarium'
WHERE provider='NCU'
;

--
-- Populate herbarium columns consistently
--

UPDATE data_contributors a
SET 
sourcetype='herbarium',
observationtype='specimen',
is_herbarium=1
FROM ih b
WHERE a.provider=b.specimen_duplicate_institutions
;



