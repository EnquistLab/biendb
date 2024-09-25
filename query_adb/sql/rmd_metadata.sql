-- -----------------------------------------------------------------------
-- Create species metadata table for range model data
-- 
-- Requires parameters:
--	$vfoi --> :vfoi					Name of observation table
--	$sch --> :sch					Schema
--	$sql_where --> :sql_where		WHERE filter on observation table
--	$obs_threshold --> :obs_threshold	Filter on # of observations in
--		crosstab table (i.e., after applying filter $sql_where)
--
-- Requirements:
-- -----------------------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS range_model_data_metadata;
CREATE TABLE range_model_data_metadata AS
SELECT DISTINCT 
scrubbed_species_binomial, filter_group,
COUNT(*) AS observations
FROM range_model_data_raw
GROUP BY scrubbed_species_binomial, filter_group
;

ALTER TABLE range_model_data_metadata
ADD COLUMN taxonomic_status text,
ADD COLUMN genus text,
ADD COLUMN family text,
ADD COLUMN "order" text,
ADD COLUMN higher_plant_group text,
ADD COLUMN growth_form text
;

DROP INDEX IF EXISTS range_model_data_metadata_scrubbed_species_binomial_idx;
CREATE INDEX range_model_data_metadata_scrubbed_species_binomial_idx ON range_model_data_metadata (scrubbed_species_binomial);

UPDATE range_model_data_metadata a
SET genus=SPLIT_PART(scrubbed_species_binomial,' ',1)
;

UPDATE range_model_data_metadata a
SET family=b.family,
taxonomic_status=b.taxonomic_status
FROM species_observation_counts_crosstab b
WHERE a.scrubbed_species_binomial=b.species
;

UPDATE range_model_data_metadata a
SET higher_plant_group=b.higher_plant_group
FROM bien_taxonomy b
WHERE a.scrubbed_species_binomial=b.scrubbed_species_binomial
;

UPDATE range_model_data_metadata a
SET "order"=b."order"
FROM bien_taxonomy b
WHERE a.scrubbed_species_binomial=b.scrubbed_species_binomial
;

-- Growth form by species
UPDATE range_model_data_metadata a
SET growth_form=b.growth_form
FROM (
SELECT scrubbed_species_binomial, 
string_agg(DISTINCT trait_value,',') AS growth_form
FROM agg_traits
WHERE trait_name='whole plant growth form'
AND scrubbed_species_binomial IS NOT NULL
AND trait_value IS NOT NULL
GROUP BY scrubbed_species_binomial
) b
WHERE a.scrubbed_species_binomial=b.scrubbed_species_binomial
;

-- Growth form by genus
-- Use only when single growth form for entire genus
UPDATE range_model_data_metadata a
SET growth_form=b.trait_value
FROM (
SELECT scrubbed_genus, trait_value, COUNT(*)
FROM agg_traits
WHERE trait_name='whole plant growth form'
AND scrubbed_genus IS NOT NULL
AND trait_value IS NOT NULL
GROUP BY scrubbed_genus, trait_value
HAVING COUNT(*)=1
) b
WHERE a.genus=b.scrubbed_genus
AND growth_form IS NULL
;

-- Growth form by family
-- Use only when single growth form for entire family
UPDATE range_model_data_metadata a
SET growth_form=b.trait_value
FROM (
SELECT scrubbed_family, trait_value, COUNT(*)
FROM agg_traits
WHERE trait_name='whole plant growth form'
AND scrubbed_family IS NOT NULL
AND trait_value IS NOT NULL
GROUP BY scrubbed_family, trait_value
HAVING COUNT(*)=1
) b
WHERE a.family=b.scrubbed_family
AND growth_form IS NULL
;

-- Mop up some obvious ones
UPDATE range_model_data_metadata a
SET growth_form='tree'
WHERE higher_plant_group='gymnosperms (conifers)'
AND growth_form IS NULL
;




