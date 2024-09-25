-- ---------------------------------------------------------------
-- Add new indexes
-- 
-- BIEN 4.1 manual fix: execute manually
-- Already added to pipeline
-- ---------------------------------------------------------------

SET search_path TO :sch;

-- Default index for geovalid observations for range modeling 
DROP INDEX IF EXISTS vfoi_bien_range_model_default_idx;
CREATE INDEX vfoi_bien_range_model_default_idx ON view_full_occurrence_individual (scrubbed_species_binomial)
WHERE scrubbed_species_binomial IS NOT NULL 
AND is_geovalid = 1 
AND (georef_protocol is NULL OR georef_protocol<>'county centroid')
AND higher_plant_group NOT IN ('Algae','Bacteria','Fungi') 
AND (is_introduced=0 OR is_introduced IS NULL) 
AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) 
AND is_location_cultivated IS NULL 
AND observation_type IN ('plot','specimen','literature','checklist')
AND (is_centroid IS NULL OR is_centroid=0)
;
