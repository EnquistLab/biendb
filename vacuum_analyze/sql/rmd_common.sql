-- -----------------------------------------------------------------------
-- Dump range model data for "common" species (>=100 observations)
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

-- Add index to confirm requirement #1
-- Better to crash than blow up the resultset
DROP INDEX IF EXISTS species_observation_counts_crosstab_species_idx;
DROP INDEX IF EXISTS species_observation_counts_crosstab_species_uniq_idx;
CREATE UNIQUE INDEX species_observation_counts_crosstab_species_uniq_idx 
ON species_observation_counts_crosstab (species)
;

DROP TABLE IF EXISTS range_model_data_raw;
CREATE TABLE range_model_data_raw AS
SELECT 
taxonobservation_id, 
scrubbed_species_binomial, 
REPLACE(scrubbed_species_binomial,' ','_') AS species_nospace,
'common' AS filter_group,
latitude, 
longitude
FROM :vfoi a JOIN species_observation_counts_crosstab b
ON a.scrubbed_species_binomial=b.species
WHERE :sql_where
AND b."8. observation_type">=:obs_threshold
;
