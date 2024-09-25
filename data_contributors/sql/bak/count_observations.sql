-- 
-- Add count of observations for each data providers
--

SET search_path TO :dev_schema;

-- Observations by proximate provider
DROP TABLE IF EXISTS obs_count_datasource;
CREATE TABLE obs_count_datasource AS
SELECT datasource, COUNT(*) AS obs
FROM view_full_occurrence_individual_dev
GROUP BY datasource
;

CREATE INDEX ON obs_count_datasource (datasource);

-- Observations by data owner
DROP TABLE IF EXISTS obs_count_datasource_id;
CREATE TABLE obs_count_datasource_id AS
SELECT datasource_id, COUNT(*) AS obs
FROM view_full_occurrence_individual_dev
GROUP BY datasource_id
;

CREATE INDEX ON obs_count_datasource_id (datasource_id);

-- Special handling for Canadensys
DROP TABLE IF EXISTS obs_count_canadensys;
CREATE TABLE obs_count_canadensys AS
SELECT COUNT(*) AS obs
FROM view_full_occurrence_individual_dev
WHERE datasource IN ('JBM','QFA','TRTE','ACAD','MT','WIN','TRT','UBC')
;

-- add just indexes needed for the update
CREATE INDEX ON data_contributors (datasource_id);
CREATE INDEX ON data_contributors (provider);

-- Observations by data owner
UPDATE data_contributors a
SET obs=b.obs
FROM obs_count_datasource_id b
WHERE a.datasource_id=b.datasource_id
;

-- Observations by proximate provider
UPDATE data_contributors a
SET obs=b.obs
FROM obs_count_datasource b
WHERE a.provider=b.datasource
AND a.obs IS NULL
;

-- Observations Canadensys
UPDATE data_contributors a
SET obs=(SELECT obs FROM obs_count_canadensys)
WHERE a.provider='Canadensys'
;

-- Remove temporary tables
DROP TABLE IF EXISTS obs_count_datasource_id;
DROP TABLE IF EXISTS obs_count_datasource;
DROP TABLE IF EXISTS obs_count_canadensys;

-- Delete records without an observation count
-- These are all embargoed records, missing fro public database
DELETE FROM data_contributors
WHERE obs IS NULL
;







