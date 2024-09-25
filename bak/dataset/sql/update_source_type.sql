-- 
-- Does a hard-wired update of source_type
-- Bit of a hack, need to find better way to do this
--

SET search_path TO :dev_schema;

UPDATE datasource
SET source_type='proximate provider'
WHERE proximate_provider_name IN (
'Canadensys',
'SALVIAS',
'REMIB',
'SpeciesLink',
'NVS',
'GBIF',
'CVS',
'HVAA',
'VegBank',
'Cyrille_traits',
'SpeciesLink'
)
AND proximate_provider_name=source_name
;
UPDATE datasource
SET source_type='data owner & proximate provider'
WHERE proximate_provider_name IN (
'ARIZ',
'TEX',
'NCU',
'CTFS',
'TEAM',
'U',
'MO',
'UNCC',
'HIBG',
'Madidi',
'BRIT',
'NY',
'FIA'
)
AND proximate_provider_name=source_name
;	
