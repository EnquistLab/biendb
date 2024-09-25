-- 
-- Inserts existing information from plot_metadata
--

SET search_path TO :dev_schema;

-- Insert vfoi source information for specimens only
-- into temp table
DROP TABLE IF EXISTS vfoi_sources_temp;
CREATE TABLE vfoi_sources_temp AS 
SELECT 
datasource,
dataset,
dataowner
FROM view_full_occurrence_individual_dev
WHERE observation_type='specimen'
;

-- Index just column needed for next query
CREATE INDEX ON vfoi_sources_temp (datasource);

-- Correct dataset for primary data providers which 
-- are also herbaria.
-- Should be same as datasource, but Aaron appears to 
-- have inserts a list of duplicate-holding institutions 
-- into this field
UPDATE vfoi_sources_temp
SET dataset='MO',
dataowner='MO'
WHERE datasource='MO'
;
UPDATE vfoi_sources_temp
SET dataset='NY',
dataowner='NY'
WHERE datasource='NY'
;
UPDATE vfoi_sources_temp
SET dataset='NCU',
dataowner='NCU'
WHERE datasource='NCU'
;
UPDATE vfoi_sources_temp
SET datasource='GBIF',
dataset='HIBG',
dataowner='HIBG'
WHERE datasource='HIBG'
;

-- Update Canadensys sources, all screwed up!
UPDATE vfoi_sources_temp
SET 
datasource='Canadensys',
dataset=datasource,
dataowner=datasource
WHERE datasource in ('QFA','TRTE','MT','WIN','TRT','UBC','JBM','ACAD') 
;

-- Add remaining indexes 
CREATE INDEX ON vfoi_sources_temp (dataset);
CREATE INDEX ON vfoi_sources_temp (dataowner);

-- Insert distinct values into second temp table 
DROP TABLE IF EXISTS vfoi_sources;
CREATE TABLE vfoi_sources AS 
SELECT DISTINCT
datasource,
dataset
FROM vfoi_sources_temp
;

-- Create indexes, including unique multi-column indexes, 
-- with one allowing dataset to be null
CREATE INDEX ON vfoi_sources (datasource);
CREATE INDEX ON vfoi_sources (dataset);
CREATE UNIQUE INDEX datasource_dataset_idx 
ON vfoi_sources (datasource, dataset);
CREATE UNIQUE INDEX datasource_dataset_null_idx 
ON vfoi_sources (datasource, dataset) 
WHERE dataset IS NULL;

-- Add dataowner column
ALTER TABLE vfoi_sources
ADD COLUMN dataowner TEXT DEFAULT NULL
; 

UPDATE vfoi_sources AS a
SET dataowner=b.dataowner
FROM vfoi_sources_temp AS b
WHERE a.datasource=b.datasource
AND a.dataset=b.dataset
AND b.dataset IS NOT NULL
AND a.dataset IS NOT NULL
;

UPDATE vfoi_sources AS a
SET dataowner=b.dataowner
FROM vfoi_sources_temp AS b
WHERE a.datasource=b.datasource
AND a.dataowner IS NULL
AND b.dataset IS NULL
AND a.dataset IS NULL
;

CREATE INDEX ON vfoi_sources (dataowner);
DROP TABLE IF EXISTS vfoi_sources_temp;

-- Insert specimen datasources into table datasource, 
-- setting is_herbarium to 0 for now for all records.
-- Will update is_herbarium later by joining to Index
-- Herbariorum table "ih"
-- Notice that we can add dataowner in this step as 
-- well, as previous steps ensured only one primary
-- contact (=dataowner) per unique datasource+dataset
INSERT INTO datasource (
proximate_provider_name,
source_name,
source_type,
observation_type,
is_herbarium,
access_conditions,
primary_contact_fullname
)
SELECT DISTINCT
datasource,
dataset,
'data owner',
'specimen',
0,
'acknowledge',
dataowner
FROM vfoi_sources;

DROP TABLE IF EXISTS vfoi_sources;

