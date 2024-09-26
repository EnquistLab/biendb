-- ---------------------------------------------------------------
-- Fix GBIF metadata in table datasource
-- 
-- BIEN 4.1 manual fix: executed manually
-- ---------------------------------------------------------------

\c vegbien
SET search_path TO analytical_db_dev;

-- Add GBIF DOI to version release notes on DB metadata table
-- Requested by Xiao
UPDATE bien_metadata
SET version_comments='Major changes: (1) Complete refresh of source GBIF (doi: https://doi.org/10.15468/dl.yubndf); (2) New validation Political Division Geovalidation (PDG) added to pipeline as shell/PostgresSQL/PostGIS, previously in R; (3) New validation centroid, flags likely centroids; (4) updated validation flag is_geovalid to include missing coordinates and invalid coordinates (lat or long out of range). Minor changes: (1) New column is_geovalid_issue indicating reason is_geovalid=0; (2) New column continent added to major analytical tables.'
WHERE db_version='4.1'
;

-- Make backup of table datasource
DROP TABLE IF EXISTS datasource_bak_22102108;
CREATE TABLE datasource_bak_22102108 (
LIKE datasource 
INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES 
);
INSERT INTO datasource_bak_22102108 SELECT * FROM datasource;

-- Remove orphan datasets (GBIF holdovers from previous database)
DELETE FROM datasource
WHERE proximate_provider_name='GBIF' and source_name<>source_fullname
AND source_name<>'GBIF'
;
DELETE FROM datasource
WHERE proximate_provider_name='GBIF' AND proximate_provider_datasource_id=1435
;

-- Remove orphan parent records for GBIF
DELETE FROM datasource
WHERE datasource_id IN (
SELECT parent.datasource_id
FROM (
SELECT datasource_id, source_name, proximate_provider_name, proximate_provider_datasource_id
FROM datasource 
WHERE source_name='GBIF'
) parent 
LEFT JOIN datasource child
ON parent.datasource_id=child.proximate_provider_datasource_id
WHERE child.proximate_provider_datasource_id IS NULL
);

-- Add columns download date and DOI to table datasource
ALTER TABLE datasource
ADD COLUMN date_accessed date default null,
ADD COLUMN doi text default null
;

-- Update information for GBIF
UPDATE datasource
SET date_accessed='2018-08-14',
doi='https://doi.org/10.15468/dl.fpwlzt',
source_citation='GBIF.org (14 August 2018) GBIF Occurrence Download https://doi.org/10.15468/dl.fpwlzt',
source_url='https://www.gbif.org/',
access_conditions='acknowledge; conditions of component datasets as specified'
WHERE source_name='GBIF'
;

-- Update doi for GBIF datasets
UPDATE datasource
SET date_accessed='2018-08-14',
doi='https://doi.org/10.15468/dl.fpwlzt'
WHERE proximate_provider_name='GBIF' AND  source_name<>'GBIF'
;