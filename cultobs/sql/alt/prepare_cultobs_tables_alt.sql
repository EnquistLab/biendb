-- -------------------------------------------------------------
-- Prepare cultobs results table
-- -------------------------------------------------------------

SET search_path TO :sch;

-- 
-- index the main table
-- 

DROP INDEX IF EXISTS cultobs_latitude_idx;
CREATE INDEX cultobs_latitude_idx ON cultobs (latitude);

DROP INDEX IF EXISTS cultobs_longitude_idx;
CREATE INDEX cultobs_longitude_idx ON cultobs (longitude);

DROP INDEX IF EXISTS cultobs_description_notnull_idx;
CREATE INDEX cultobs_description_notnull_idx ON cultobs (description)
WHERE description IS NOT NULL;

--
-- Create new table of non-null descriptions only
-- 

DROP TABLE IF EXISTS cultobs_descriptions;
CREATE TABLE cultobs_descriptions AS 
SELECT 
cultobs_id,
description,
is_cultivated_observation,
is_cultivated_observation_basis
FROM cultobs
WHERE description IS NOT NULL
;

-- Faster to do on the smaller table
DELETE FROM cultobs_descriptions
WHERE TRIM(description)=''
;

-- 
-- Create tables of distances and minimum distances to herbaria
-- 

-- Distances to all herbaria
-- This table get wiped clean after each query
DROP TABLE IF EXISTS cultobs_herb_dist;
CREATE TABLE cultobs_herb_dist (
cultobs_id bigint,
country text,
state_province text,
herb_dist_km numeric
)
;

-- Distance to closest herbarium
-- This table is built up gradually across all queries and batches
-- Add PK now
DROP TABLE IF EXISTS cultobs_herb_min_dist;
CREATE TABLE cultobs_herb_min_dist (
cultobs_id bigint primary key,
herb_min_dist_km numeric,
is_cultivated_observation smallint default 0
)
;