-- -------------------------------------------------------------
-- Add indexed integer column 'is_range_model_obs' to table vfoi
-- Where is_range_model_obs=1 when all conditions in default 
-- range model where clause are true, otherwise 0
-- -------------------------------------------------------------

-- Private DB
-- \c vegbien
-- SET search_path TO analytical_db;

-- Public DB
\c public_vegbien

--
-- Create the table and insert unique species + political divisions
--

ALTER TABLE view_full_occurrence_individual
ADD COLUMN is_range_model_obs smallint default 0 not null
;

UPDATE view_full_occurrence_individual
SET is_range_model_obs=1
WHERE scrubbed_species_binomial IS NOT NULL
AND observation_type IN ('plot','specimen','literature','checklist')
AND is_geovalid = 1
AND (georef_protocol is NULL OR georef_protocol<>'county centroid')
AND (is_centroid IS NULL OR is_centroid=0)
AND is_location_cultivated IS NULL
AND higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)')
AND (is_introduced=0 OR is_introduced IS NULL)
AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL)
;

-- Create partial index on is_range_model_obs
DROP INDEX IF EXISTS vfoi_is_range_model_obs_idx;
CREATE INDEX vfoi_is_range_model_obs_idx ON view_full_occurrence_individual
USING btree (is_range_model_obs)
WHERE is_range_model_obs=1
;

VACUUM ANALYZE view_full_occurrence_individual;


