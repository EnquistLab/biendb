-- -----------------------------------------------------------------------
-- Dump range model data for "rare" species (<100 observations)
-- 
-- Requires parameters:
--	$vfoi --> :vfoi					Name of observation table
--	$sch --> :sch					Schema
--	$sql_where --> :sql_where		WHERE filter on observation table
--	$obs_threshold --> :obs_threshold	Filter on # of observations in
--		crosstab table (i.e., after applying filter $sql_where)
--
-- Requirements:
-- 	1. Column species in table species_observation_counts_crosstab
--		MUST be unique (test!)
--	2. Index on column scrubbed_species_binomial in table vfoi
--	3. Indexes on columns species and "8. observation_type" in 
--		table species_observation_counts_crosstab
-- -----------------------------------------------------------------------

SET search_path TO :sch;

INSERT INTO range_model_data_raw (
taxonobservation_id, 
scrubbed_species_binomial, 
species_nospace,
filter_group,
latitude, 
longitude
)
SELECT 
taxonobservation_id, 
scrubbed_species_binomial, 
REPLACE(scrubbed_species_binomial,' ','_'),
'rare',
latitude, 
longitude
FROM :vfoi a JOIN species_observation_counts_crosstab b
ON a.scrubbed_species_binomial=b.species
WHERE :sql_where
AND b."8. observation_type"<:obs_threshold
;

-- Add index, needed for export
DROP INDEX IF EXISTS range_model_data_raw_species_nospace_idx;
CREATE INDEX range_model_data_raw_species_nospace_idx ON range_model_data_raw (species_nospace);
VACUUM ANALYZE range_model_data_raw;



