-- -----------------------------------------------------------
-- Create temporary table of query results
-- 
-- Uses standard (revised) range modeling query with additional
-- filter 'is_new_world=1'
-- 
-- Parameters:
-- 	:target_sch: target schema where table will be created
-- 	:src_sch: source schema to be queried (should be analytical_db)
-- 	:tbl: Name of temporary table to be created
-- 	:limit: for testing with small sample; set to "" for production
-- -----------------------------------------------------------

SET search_path TO :target_sch;

DROP TABLE IF EXISTS :tbl;

-- Set limit parameter for testing
-- For production, let limit=""
CREATE TABLE :tbl AS
SELECT taxonobservation_id, scrubbed_family AS family, scrubbed_genus AS genus, scrubbed_species_binomial AS species, latitude, longitude 
FROM :src_sch.view_full_occurrence_individual 
WHERE scrubbed_species_binomial IS NOT NULL
AND observation_type IN ('plot','specimen','literature','checklist')
AND is_geovalid = 1
AND (georef_protocol is NULL OR georef_protocol<>'county centroid')
AND (is_centroid IS NULL OR is_centroid=0)
AND is_location_cultivated IS NULL
AND
(
(higher_plant_group='bryophytes')
OR
( higher_plant_group IN ('ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)')
AND (is_introduced=0 OR is_introduced IS NULL)
AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) )
)
AND is_new_world=1
:limit
;
