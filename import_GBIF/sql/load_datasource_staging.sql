-- ----------------------------------------------------------------
-- Load metadata staging table
-- ----------------------------------------------------------------

-- --------------------------------------------------
-- For source where metadata can be extracted directly 
-- from the main data staging table
-- --------------------------------------------------

SET search_path TO :sch;

-- Record for parent provider GBIF
INSERT INTO datasource_staging (
source_name,
source_fullname,
source_type,
observation_type,
proximate_provider_name,
source_url,
access_conditions,
access_level
)
VALUES 
(
'GBIF',
'Global Biodiversity Information Facility',
'proximate provider',
'mixed occurrence',
'GBIF',
'https://www.gbif.org/',
'acknowledge',
'public'
)
;

-- Create table of unique datasource + dataset combinations
DROP TABLE IF EXISTS distinct_datasets;
CREATE TABLE distinct_datasets AS
SELECT DISTINCT
datasource,
dataset,
observation_type
FROM vfoi_staging
;
DROP TABLE IF EXISTS datasets_staging;
CREATE TABLE datasets_staging AS
SELECT 
datasource,
dataset,
string_agg(observation_type, ',') AS observation_types
FROM distinct_datasets
GROUP BY datasource, dataset
;


INSERT INTO datasource_staging (
source_name,
source_fullname,
source_type,
observation_type,
proximate_provider_name,
source_url,
access_conditions,
access_level
)
SELECT 
dataset,
dataset,
'data owner',
observation_types,
'GBIF',
NULL,
'acknowledge',
'public'
FROM datasets_staging
;

DROP INDEX IF EXISTS datasource_staging_source_name_idx;
CREATE INDEX datasource_staging_source_name_idx ON datasource_staging (source_name);

-- Add acronym to herbarium datasources
UPDATE datasource_staging a
SET is_herbarium=1
FROM ih b
WHERE a.source_name=b.acronym
;

-- Populate (temporary) recursive FKs
UPDATE datasource_staging
SET proximate_provider_datasource_staging_id=
(SELECT datasource_staging_id FROM datasource_staging WHERE source_name='GBIF')
;

DROP TABLE IF EXISTS distinct_datasets;
DROP TABLE IF EXISTS datasets_staging;
