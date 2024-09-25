--
-- ONE TIME USE ONLY, to recover from error
--

SET search_path TO :sch;


CREATE INDEX analytical_stem_cods_proximity_id_idx ON analytical_stem (cods_proximity_id);
CREATE INDEX analytical_stem_cods_keyword_id_idx ON analytical_stem (cods_keyword_id);



-- Compound indexes for frequent queries
-- REVISE THIS INDEX AFTER SCHEMA UPDATE! Last line should read:
-- AND (is_introduced=0 OR is_introduced IS NULL)
CREATE INDEX analytical_stem_validated_species_idx ON analytical_stem USING btree (scrubbed_species_binomial) 
WHERE (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) 
AND higher_plant_group IS NOT NULL
AND (is_geovalid = 1 OR is_geovalid IS NULL)
AND (latitude IS NOT NULL AND longitude IS NOT NULL)
AND (is_introduced=0 OR is_introduced IS NULL)
;

